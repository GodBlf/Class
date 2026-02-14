# claude code
https://doc.instcopilot-api.com/
1. node.js npm下载
2. 你的错误信息说明 PowerShell 阻止了脚本运行，这是因为 Windows 的 **执行策略** 默认禁止本地或未签名的脚本运行。这不是 npm 的问题，而是 PowerShell 的安全设置。

### 解决方案

#### 方法1：临时允许当前会话执行脚本（推荐）
在当前 PowerShell 会话中运行以下命令：

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

然后再运行你的 npm 命令：

```powershell
npm install -g @anthropic-ai/claude-code
```

#### 方法2：永久更改本地用户的执行策略
如果你经常需要运行此类命令，可以提升权限（以管理员身份运行 PowerShell），然后输入：

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

**注意安全风险！** 这会让本地脚本可以运行，下载的（远程）脚本需要签名。

#### 方法3：直接用 `cmd` 或者 Git Bash 运行
你也可以在 **命令提示符（cmd.exe）** 或 **Git Bash** 里运行 npm 命令，这样不会受 PowerShell 执行策略影响。

---

### 参考资料

- [about_Execution_Policies - PowerShell Docs](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_execution_policies)

---
再 npm install -g @anthropic-ai/claude-code

3. 配置位置
Mac: ~/.claude/settings.json 或 .claude/settings.json
Windows: %USERPROFILE%\.claude\settings.json
Linux: ~/.claude/settings.json
settings.json
复制配置
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "令牌key",
    "ANTHROPIC_BASE_URL": "https://***.com"
  }
}

1. claude 启动


# gemini cli
- npm
npm install -g @google/gemini-cli
- config
%userprofile%/.gemini 下的.env 和 settings.json

```json
{
  "ide": {
    "enabled": true
  },
  "security": {
    "auth": {
      "selectedType": "gemini-api-key"
    }
  }
}
```
```.env
GOOGLE_GEMINI_BASE_URL=https://.../gemini
GEMINI_API_KEY=sk-...
GEMINI_MODEL=gemini-3-pro-preview
```


# codex
## 配置
- 配置文件位置%userprofile%/.codex 的 auth.json config.toml
- 修改配置文件和环境变量可以使用第三方api
```config.toml

model_provider = "IkunCoding"
model = "gpt-5.3-codex"
model_reasoning_effort = "xhigh"

web_search = "live"
network_access = "enabled"

disable_response_storage = true
approval_policy = "untrusted"
sandbox_mode = "danger-full-access"
model_verbosity = "high"
collaboration_mode = true
model_supports_reasoning_summaries = true

[model_providers.IkunCoding]
name = "ikun"
base_url = "https://newapi.sorai.me/v1"
wire_api = "responses"
requires_openai_auth = true

[features]
shell_snapshot_tool = true
powershell_utf8 = true 
shell_snapshot = true
collaboration_modes = true
steer = false
unified_exec = false



```
```json
{
  "OPENAI_API_KEY": "粘贴为CodeX专用分组令牌key"
}
```

## node.js
npm下载
npm install -g @openai/codex

## 历史对话记录


## 命令
- ! 命令行语句
- @文件 常和 ctrl+j(回车) 搭配使用
- ctrl + g 打开外部编辑器
- shift tab 默认模式/plan 模式切换 ; 需要配置collaboration_modes = true
  
- /new cc的/clear 清空上下文
- /agent 切换subagent

### 对话历史记录相关
- /resume 打开近期的对话 /fork 分叉一个近期对话
- 对话历史记录存在%userprofile%/.codex/sessions(存储详细)  和 %userprofile%/.codex/history.jsonl(存储概要)中
- 终端丢失codex可以通过codex resume <SESSION_ID>,手动恢复对话 e.g. codex resume 019c511e-98fe-7ad1-9f90-ec45173b6cb0
- codex fork <session_id> 可以分叉一个对话

### 上下文相关
- /compact "压缩策略"
- ctrl+t 预览上下文记录(ctrl+o是cc的)
- esc esc回滚 搭配git回滚


## ask->plan->edit mode
- codex将ask和edit功能合为一体了

# 外部编辑器配置
- 方便编辑提示词
- 快捷键 ctrl+g
```md
使用 Ctrl+G 打开外部编辑器 （Claude：就这？）
windows 用户先设置编辑器 (举例使用记事本)

- bash
echo 'export EDITOR=notepad' >> ~/.bashrc
source ~/.bashrc

- powershell
创建配置文件（如果已存在则不会覆盖）
if (!(Test-Path $PROFILE)) { New-Item -Type File -Path $PROFILE -Force }

打开配置文件

notepad $PROFILE

添加配置

$env:EDITOR="notepad"

重启 powershell
```

# 项目结构
my-project/
├── .agents/             # 存放核心逻辑（不常直接阅读）gemini-cli是.gemini/
│   ├── skills/          # 各种技能定义
│   └── agents/          # subagents
├── AGENTS.md            # Agent 系统的全局说明（Codex 的导航地图） gemini-cli 是 GEMINI.md
├── README.md            # 项目通用说明
└── src/                 # 业务代码

# AGENTS.md/GEMINI.md/CLAUDE.md
- 是给llm-cli看的项目说明书,开发手册

# skills
my-tool/                   # skill包/
├── SKILL.md               # SKILL.md (Required: instructions + metadata / 必需：说明 + 元数据)
├── scripts/               # 脚本/ (Optional: executable code / 可选：可执行代码)
├── references/            # 参考/ (Optional: documentation / 可选：文档)
├── assets/                # 资产/ (Optional: templates, resources / 可选：模板、资源)
└── agents/                # 代理人/
    └── openai.yaml        # (Optional: appearance and dependencies / 可选：外观和依赖项)

  
- skill包名小写,SKILL.md文件大写,包结构和golang的包结构类似
- SKILL.md文件元数据要包含name字段(值和包名一致),description字段
- 例如 .agents/skills/pdf/SKILL.md
```md
---
name: "pdf"
description: "Use when tasks involve reading, creating, or reviewing PDF files where rendering and layout matter; prefer visual checks by rendering pages (Poppler) and use Python tools such as `reportlab`, `pdfplumber`, and `pypdf` for generation and extraction."
---

# PDF Skill

## When to use

## Workflow

## ...

## Final checks

```

# subagent
- 不污染主进程上下文的隔离的子进程llm cli
- 创建和skill类似 路径 /.agents/agents/subagent1.md 元数据包含name,description字段
- /agent 切换subagent命令

# ask->plan->edit mode
- 软件开发流程
分析项目->架构->代码实现
## plan mode
- plan mode很重要,用于新增重构等
- llm交互询问,会给出实施方案,达成共识后再进入edit mode

# workflows
- 构建项目AGENTS.md .agent/  .agents/skills  
- ask->plan->edit
