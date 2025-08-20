# golang context包详解

## 🧑‍💻 User

讲解golang的context包

---
## 🤖 Assistant

好的，我们来详细讲解一下 **Go语言的 `context` 包**。

---

## 一、`context` 的背景和作用
在并发编程中，我们经常需要在不同的 goroutine 之间传递控制信号，例如：
- 取消某个操作（比如超时、手动中断）。
- 在 API 中统一传递超时/取消信号。
- 在多层函数调用之间传递请求范围的元数据。

在 Go1.7 中，官方引入了 `context` 包，提供了标准的上下文管理机制，常用于：
1. **取消 goroutine**。
2. **设置超时/截止时间**。
3. **跨函数传递请求范围的值**。

---

## 二、`context` 的核心接口
`Context` 是一个接口，它定义了 4 个方法：

```go
type Context interface {
    Deadline() (deadline time.Time, ok bool) // 返回截止时间（如果有）
    Done() <-chan struct{}                  // 返回一个信号 channel，用来取消通知
    Err() error                             // 返回取消的原因
    Value(key interface{}) interface{}      // 获取存储在 context 中的值
}
```

---

## 三、常用的 Context 构造函数
在实际开发中，通常通过以下方式创建 context：

1. **背景 Context**
 - `context.Background()`：常用于主函数、初始化、顶层 Context。
 - `context.TODO()`：暂时不知道用哪种 Context 时使用。

2. **带取消的 Context**
```go
   ctx, cancel := context.WithCancel(parent)
   ```
   - 调用 `cancel()` 或父级 `ctx` 被取消时，子 `ctx.Done()` 会被关闭。

3. **带超时的 Context**
   ```go
   ctx, cancel := context.WithTimeout(parent, 2*time.Second)
   ```
   - 在 2 秒后自动取消。

4. **带截止时间的 Context**
   ```go
   ctx, cancel := context.WithDeadline(parent, time.Now().Add(3*time.Second))
   ```

5. **带值的 Context**
   ```go
   ctx := context.WithValue(parent, "userID", 12345)
   v := ctx.Value("userID") // 获取 12345
   ```
   ⚠️ 注意：不建议用 `context` 存储大对象或者可选参数，它主要用于请求范围相关的信息（比如 trace id、用户信息），而不是业务数据。

---

## 四、使用示例

### 1. 使用 `WithCancel` 手动取消
```go
package main

import (
 "context"
 "fmt"
 "time"
)

func worker(ctx context.Context) {
 for {
 select {
 case <-ctx.Done():
 fmt.Println("worker stopped:", ctx.Err())
 return
 default:
 fmt.Println("working...")
 time.Sleep(500 * time.Millisecond)
 }
 }
}

func main() {
 ctx, cancel := context.WithCancel(context.Background())
 go worker(ctx)

 time.Sleep(2 * time.Second)
 cancel() // 通知 worker 停止
 time.Sleep(1 * time.Second)
}
```

### 2. 使用 `WithTimeout`
```go
ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
defer cancel()

select {
case <-time.After(5*time.Second):
 fmt.Println("finished")
case <-ctx.Done():
 fmt.Println("timeout:", ctx.Err())
}
```

### 3. 使用 `WithValue`
```go
ctx := context.WithValue(context.Background(), "requestID", "abc123")

func handleRequest(ctx context.Context) {
 reqID := ctx.Value("requestID").(string)
 fmt.Println("handling request", reqID)
}
```

---

## 五、最佳实践
1. **总是 `defer cancel()`**
使用 `WithCancel`、`WithTimeout`、`WithDeadline` 时要及时调用 `cancel()`，释放资源。

2. **避免滥用 `context.WithValue`**
只传递与请求范围相关的数据，避免当作参数传递的万能工具。

3. **在函数签名中优先传递 `ctx`**
Go 规范建议将 `ctx` 作为函数的第一个参数，例如：
```go
func Query(ctx context.Context, db *sql.DB, query string) error
```

---

## 六、场景总结
- **服务端 API**：控制请求超时/取消（例如 HTTP Server）。
- **客户端 API**：例如访问数据库、RPC 时传递超时控制。
- **任务调度**：一组 goroutine 在某个条件下统一退出。

---

👉 总结：`context` 是 Go 并发编程里的上下文控制器，用于 **超时控制、取消信号和跨函数的元数据传递**，能够帮助我们写出更健壮的并发代码。

---

要不要我帮你画一张 **`context` 的使用流程图**（从 `Background` → `WithCancel/WithTimeout` → goroutine `Done` 监听）这样更直观？

---
## 🧑‍💻 User

项目中一般如何设置context实现timeout取消子协程的

---
## 🤖 Assistant

好问题 👍。在实际项目中，尤其是 Web 服务或任务调度类的 Go 项目中，**一般会通过 `context.WithTimeout` 或 `context.WithDeadline` 来实现超时控制，并通知子 goroutine 停止工作**。下面我结合常见的项目场景给你讲解一下。

---

## 一、基本思路
1. 在 **入口函数/请求调用点** 创建一个带超时的 `context`。
2. 把这个 `ctx` 传递下去，所有子 goroutine 都基于这个 `ctx` 运行。
3. 子 goroutine 内部通过 `select` 监听 `<-ctx.Done()`，一旦超时或取消，主动退出。
4. 使用 `defer cancel()` 保证超时控制相关的资源被及时释放。

---

## 二、项目中的常见模式

### 1. HTTP Handler 中的超时控制
以 Web 服务为例，请求的生命周期可以作为 Context 生命周期：

```go
func handler(w http.ResponseWriter, r *http.Request) {
    // 创建一个 2 秒的超时 Context
    ctx, cancel := context.WithTimeout(r.Context(), 2*time.Second)
    defer cancel()

    resultCh := make(chan string, 1)

    go func() {
        // 模拟耗时操作（比如访问数据库/外部服务）
        time.Sleep(3 * time.Second)
        resultCh <- "done"
    }()

    select {
    case res := <-resultCh:
        fmt.Fprintln(w, "result:", res)
    case <-ctx.Done():
        http.Error(w, "request timeout", http.StatusGatewayTimeout)
    }
}
```

🔑 在这种场景下，超时就会立刻返回给用户，避免请求无限挂起。

---

### 2. 服务调用链中的传递
如果你在服务 A 调用服务 B，再调用数据库 C，需要保证超时限制在整个调用链中保持一致，只要在入口创建一个 Context 并传下去：

```go
func (s *Service) GetUser(ctx context.Context, id int) (User, error) {
    ctx, cancel := context.WithTimeout(ctx, 1*time.Second)
    defer cancel()

    // 数据库查询也用这个 ctx
    return s.repo.FindUser(ctx, id)
}
```

在 repo 层的 `FindUser` 接口中也要用 `ctx`，比如 `db.QueryContext(ctx, ...)`，这样数据库驱动会在超时后自动停止执行。

---

### 3. 多个子协程并发执行
常见模式是同时起多个 goroutine，任意一个超时或完成都可以控制协程退出：

```go
func main() {
    ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
    defer cancel()

    var wg sync.WaitGroup
    for i := 0; i < 3; i++ {
        wg.Add(1)
        go func(id int) {
            defer wg.Done()
            for {
                select {
                case <-ctx.Done():
                    fmt.Println("worker", id, "stopped:", ctx.Err())
                    return
                default:
                    fmt.Println("worker", id, "working...")
                    time.Sleep(500 * time.Millisecond)
                }
            }
        }(i)
    }

    wg.Wait()
}
```

🔑 这样，只要 `ctx` 超时或取消，所有子协程都会在 `ctx.Done()` 处收到信号并退出。

---

## 三、最佳实践建议

1. **及时调用 `defer cancel()`**，释放定时器等内部资源。
2. 在 **最上层设置超时**，然后将 `ctx` 一路传递。避免在函数深处重新随意设置新的超时，可能会相互冲突。
3. 子协程里要写 `select { case <-ctx.Done(): return }`，不要忽略。
4. **避免无限等待**，所有耗时的 I/O、DB、RPC 操作优先使用支持 `Context` 的调用（如 `http.NewRequestWithContext`, `db.QueryContext`, `grpc.DialContext`）。
5. 通常服务的超时时间要略小于上游超时时间，防止雪崩效应。例如：
 - API 请求超时：`5s`
 - DB 查询子操作：`3s`
 - 缓存读取：`1s`

---

✅ 总结：
在项目中，通常会：
- **在请求入口或任务入口处创建带超时的 Context**。
- **将 Context 下传到所有子逻辑**。
- **子 goroutine 中监听 `<-ctx.Done()` 实现取消**。

---

要不要我帮你写一个 **完整的 HTTP 服务 demo**，演示「请求超时 → 同时取消子 goroutine（DB 查询、缓存查询） → 返回超时错误给客户端」的完整流程？这样你能看到真实项目里的用法。
