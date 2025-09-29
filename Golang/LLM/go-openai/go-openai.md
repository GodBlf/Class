# boot
```go
package chatsession

import "context"

type ChatSessionInterface interface {
	Chat(ctx context.Context, userMsg string) (string, error)
	//直接把error发货到管道里
	ChatStream(ctx context.Context, userMsg string)
	ChatStreamOut()
    //设置系统提示词
	SetSystemPrompt(prompt string)
    //清空聊天记录
	ClearHistory()
}

// model 流式chat的流元素
type ChatStreamElement struct {
	Content string
	Err     error
}

package chatsession

import (
	"context"
	"errors"
	"fmt"
	"io"
	"strings"
	"sync"
	"xmu_roll_call/global"

	openai "github.com/sashabaranov/go-openai"
	"go.uber.org/zap"
)

// 需要lazyglobal时候实现单例
var (
	ChatSessionImplVar *ChatSessionImpl = &ChatSessionImpl{}
	csionce                             = &sync.Once{}
)

type ChatSessionImpl struct {
	Messages       []openai.ChatCompletionMessage
	client         *openai.Client
	model          string
	ChatStreamChan chan ChatStreamElement
}

func NewChatSessionImpl() *ChatSessionImpl {
	config := openai.DefaultConfig(global.LlmApiKey)
	config.BaseURL = global.LlmUrl + "/" + global.OpenaiVersion
	return &ChatSessionImpl{
		Messages:       make([]openai.ChatCompletionMessage, 0),
		client:         openai.NewClientWithConfig(config),
		model:          global.LlmModel,
		ChatStreamChan: make(chan ChatStreamElement, 16),
	}
}

func (cs *ChatSessionImpl) Chat(ctx context.Context, userMsg string) (string, error) {
	cs.AddMessage(openai.ChatMessageRoleUser, userMsg)
	response, err := cs.client.CreateChatCompletion(ctx, openai.ChatCompletionRequest{
		Model:    cs.model,
		Messages: cs.Messages,
	})
	if err != nil {
		zap.L().Error("ChatCompletion error", zap.Error(err))
		return "", err
	}
	if len(response.Choices) == 0 {
		return "", errors.New("no response from model")
	}
	reply := response.Choices[0].Message.Content
	cs.AddMessage(openai.ChatMessageRoleAssistant, reply)
	return reply, nil
}

func (cs *ChatSessionImpl) ChatStream(ctx context.Context, userMsg string) {
	cs.AddMessage(openai.ChatMessageRoleUser, userMsg)
	stream, err := cs.client.CreateChatCompletionStream(ctx, openai.ChatCompletionRequest{
		Model:    cs.model,
		Messages: cs.Messages,
	})
	if err != nil {
		cs.ChatStreamChan <- ChatStreamElement{Err: err}
		close(cs.ChatStreamChan)
		zap.L().Error("request stream", zap.Error(err))
		return
	}
	defer stream.Close()

	reply := &strings.Builder{}
	for true {
		response, err := stream.Recv()
		if errors.Is(err, io.EOF) {
			break
		}
		if err != nil {
			cs.ChatStreamChan <- ChatStreamElement{Err: err}
			close(cs.ChatStreamChan)
			return
		}
		delta := response.Choices[0].Delta.Content
		if delta != "" {
			reply.WriteString(delta)
			cs.ChatStreamChan <- ChatStreamElement{Content: delta}
		}
	}
	cs.AddMessage(openai.ChatMessageRoleAssistant, reply.String())
	close(cs.ChatStreamChan)
}

func (cs *ChatSessionImpl) ChatStreamOut() {
	for element := range cs.ChatStreamChan {
		if element.Err != nil {
			zap.L().Error("stream error", zap.Error(element.Err))
			return
		}
		fmt.Print(element.Content)
	}
}

func (cs *ChatSessionImpl) AddMessage(role, content string) {
	cs.Messages = append(cs.Messages, openai.ChatCompletionMessage{
		Role:    role,
		Content: content,
	})
}

func (cs *ChatSessionImpl) ClearHistory() {
	cs.Messages = make([]openai.ChatCompletionMessage, 0)
}
func (cs *ChatSessionImpl) SetSystemPrompt(prompt string) {
	cs.ClearHistory()
	cs.AddMessage(openai.ChatMessageRoleSystem, prompt)
}

package main

func main() {
	initialize.InitLogger()
	initialize.InitConfig()
	chatsession := chatsession.NewChatSessionImpl()
	chatsession.SetSystemPrompt("我在学习golang的库go-openai,你是一个资深的golang开发者,请你帮助我理解go-openai的用法")
	ctx := context.Background()
	reply, err := chatsession.Chat(ctx, "你是谁")
	if err != nil {
		zap.L().Error("Chat error", zap.Error(err))
		return
	}
	zap.L().Info("reply", zap.String("reply", reply))
	chat, _ := chatsession.Chat(ctx, "请记住我的名字我叫许昊龙")
	zap.L().Info("reply", zap.String("reply", chat))
	chat2, _ := chatsession.Chat(ctx, "我是谁")
	zap.L().Info("reply", zap.String("reply", chat2))
	//clear
	chatsession.ClearHistory()
	str := "介绍下chatgpt"
    //装饰器闭包实现等待组的并发控制外移
	wg := &sync.WaitGroup{}
	wg.Add(1)
	go func() {
		defer wg.Done()
		chatsession.ChatStream(ctx, str)
	}()
	wg.Add(1)
	go func() {
		defer wg.Done()
		chatsession.ChatStreamOut()
	}()
	wg.Wait()
}

```


# 常量

## 角色常量
| 常量名 | 字符串值 | 含义 | 使用场景 |
|--------|----------|------|----------|
| `ChatMessageRoleSystem` | `"system"` | 系统提示信息，用来给模型设定整体行为和规则 | 比如告诉模型“你是一个翻译助手” |
| `ChatMessageRoleUser` | `"user"` | 用户输入的消息 | 真实的用户问题、请求 |
| `ChatMessageRoleAssistant` | `"assistant"` | AI 的回复消息 | 在多轮对话中，保存模型的回答 |
| `ChatMessageRoleFunction` | `"function"` | 函数返回的内容（旧版 function calling） | 当模型调用一个函数后，你把函数返回值喂回模型时使用 |
| `ChatMessageRoleTool` | `"tool"` | 表示工具调用或工具返回（未来 API 角色） | 用来表示外部工具的输出 |
| `ChatMessageRoleDeveloper` | `"developer"` | 给开发者特定的指令（实验性） | 在开发模式下，传递只对模型开发有效的提示 |

### 用法示例
```golang

const (
	ChatMessageRoleSystem    = "system"
	ChatMessageRoleUser      = "user"
	ChatMessageRoleAssistant = "assistant"
	ChatMessageRoleFunction  = "function"
	ChatMessageRoleTool      = "tool"
	ChatMessageRoleDeveloper = "developer"
)
package main

import (
    "context"
    "fmt"
    "os"

    openai "github.com/sashabaranov/go-openai"
)

func main() {
    client := openai.NewClient(os.Getenv("OPENAI_API_KEY"))
    ctx := context.Background()

    // 构造对话消息
    messages := []openai.ChatCompletionMessage{
        {
            Role:    openai.ChatMessageRoleSystem,
            Content: "你是一个专业的数学老师，回答要清晰简洁。",
        },
        {
            Role:    openai.ChatMessageRoleUser,
            Content: "请帮我解方程 2x + 3 = 7",
        },
    }

    resp, err := client.CreateChatCompletion(ctx, openai.ChatCompletionRequest{
        Model:     openai.GPT3Dot5Turbo, // 或 GPT4
        Messages:  messages,
    })
    if err != nil {
        panic(err)
    }

    fmt.Println(resp.Choices[0].Message.Content)
}
messages = append(messages, openai.ChatCompletionMessage{
    Role:    openai.ChatMessageRoleAssistant,
    Content: "上一步的计算结果是 x = 2。",
})
messages = append(messages, openai.ChatCompletionMessage{
    Role:    openai.ChatMessageRoleUser,
    Content: "请用这个结果继续计算 y = x^2。",
})

```