# 导论
```json
{
    "flag":"variable",
    "flags":"variable_set",
    "command_function":"Hook" //callback实现
}
```
- cobra眼睛蛇 viper毒蛇
- 底层基于flag包开发的开发命令行接口框架
- 搭配viper(CLIs配置框架)

# 项目结构
```
mycli/
├── cmd/
│   ├── root.go       # 根命令
│   ├── hello.go      # 子命令 hello
│   └── config.go     # 配置初始化
├── configs/
│   └── config.yaml   # 默认配置文件
├── go.mod
└── main/main.go
```

# 命令结构
- 根命令 子命令 [flags] [args]

# Command
-结构体
type Command struct {
    // 命令的名称或用法字符串，通常是用户在命令行中键入的第一个词。
    // 例如：对于 `mycli serve`，Use 就是 "serve"。
    Use string

    // 命令的简短描述，通常用于 `help` 输出的摘要行。
    Short string

    // 命令的详细描述，通常用于 `help` 输出的详细部分。
    Long string

    // 命令的使用示例，用于 `help` 输出，帮助用户理解如何使用。
    Example string

    // ----------------------------------------------------------------------
    // 命令的执行逻辑。
    // RunE 是一个函数，当命令被执行时调用。它接收当前命令实例和非标志参数列表。
    // 返回 error 可以让 Cobra 统一处理错误并打印。
    RunE func(cmd *Command, args []string) error
    // 还有一个 Run 字段，与 RunE 类似，但不返回 error。推荐使用 RunE 以便更好地错误处理。
    // Run func(cmd *Command, args []string)

    // ----------------------------------------------------------------------
    // 参数验证函数。用于验证用户输入的非标志参数 (args)。
    // 例如：cobra.ExactArgs(1) 要求必须且只能有一个非标志参数。
    // Args func(cmd *Command, args []string) error

    // ----------------------------------------------------------------------
    // 钩子函数 (Hooks)。在 RunE/Run 执行前后执行。
    // PersistentPreRunE/PersistentPreRun: 在命令及其所有子命令的 RunE/Run 之前执行。
    // PreRunE/PreRun: 只在当前命令的 RunE/Run 之前执行。
    // PostRunE/PostRun: 只在当前命令的 RunE/Run 之后执行。
    // PersistentPostRunE/PersistentPostRun: 在命令及其所有子命令的 RunE/Run 之后执行。

    // ----------------------------------------------------------------------
    // 标志 (Flags) 管理。
    // PersistentFlags: 持久化标志集。这些标志对当前命令及其所有子命令都有效。
    PersistentFlags *pflag.FlagSet
    // Flags: 本地标志集。这些标志只对当前命令有效。
    Flags *pflag.FlagSet

    // ----------------------------------------------------------------------
    // 子命令。
    // Commands: 当前命令的子命令列表。
    Commands []*Command

    // ----------------------------------------------------------------------
    // 其他高级设置。
    // SilenceUsage bool: 如果为 true，当命令执行错误时，Cobra 不会打印用法信息。
    // SilenceErrors bool: 如果为 true，Cobra 不会打印错误信息（留给调用者自行处理）。
    // Hidden bool: 如果为 true，该命令不会出现在 help 输出中。
    // ValidArgs []string: 用于 shell 自动补全的有效参数列表。
    // DisableFlagsInUseLine bool: 如果为 true，`[flags]` 不会出现在 `Use` 行中。
    // TraverseChildren bool: 如果为 true，即使在子命令执行时，也会解析其父命令的本地标志。
    // FParseErrWhitelist FParseErrWhitelist: 允许忽略某些解析错误。
}


## Hook
- 给定hook run函数,cobra 根据命令自动回调hook函数

### 1. Cobra 的生命周期
每个 `Command` 执行时，大致流程如下：

1. **解析 flag & args**
2. **执行 PersistentPreRun / PreRun**（钩子函数）
3. **执行 Run / RunE**（命令真正逻辑）
4. **执行 PostRun / PersistentPostRun**

#### 核心 Hooks
每个 Hook 都有两个版本：
- **PersistentXXX**：会沿用到子命令；
- **XXX**（非 persistent）：只作用在该命令本身。

---

### 2. Hook 函数详细说明

#### （1）`PersistentPreRun / PersistentPreRunE`
- 在执行命令或子命令之前调用。
- **继承性**：父命令的 `PersistentPreRun(E)` 会在子命令执行前触发。
- 典型用途：初始化全局配置，如日志、数据库连接、Viper 配置读入。

```go
var rootCmd = &cobra.Command{
	Use: "mycli",
	PersistentPreRun: func(cmd *cobra.Command, args []string) {
		fmt.Println("全局初始化：例如加载配置文件...")
	},
}
```

#### （2）`PreRun / PreRunE`
- 在执行命令本身逻辑之前调用（**不影响子命令**）。
- 常用来做参数检查、局部初始化。

```go
var helloCmd = &cobra.Command{
	Use: "hello",
	PreRun: func(cmd *cobra.Command, args []string) {
		fmt.Println("这是 hello 子命令的前置动作")
	},
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("执行 hello 逻辑")
	},
}
```

#### （3）`Run / RunE`
- 核心逻辑函数。
- `RunE` 版本会返回 `error`，更适合需要处理错误的场景。

```go
RunE: func(cmd *cobra.Command, args []string) error {
	if len(args) == 0 {
		return fmt.Errorf("必须提供参数")
	}
	fmt.Println("业务逻辑执行中...", args)
	return nil
},
```

#### （4）`PostRun / PostRunE`
- 在命令执行（Run/RunE）之后执行。
- 用于清理资源、打印收尾信息。

```go
PostRun: func(cmd *cobra.Command, args []string) {
	fmt.Println("这是命令结束后的收尾动作")
},
```

#### （5）`PersistentPostRun / PersistentPostRunE`
- 和 `PersistentPreRun` 相对应，执行完成后调用，**会冒泡到父命令**。
- 一般用于收尾/资源释放，比如关闭数据库、保存日志。

---

### 3. Hooks 调用顺序

执行子命令时的调用顺序大致是：

```text
父命令 PersistentPreRun(E)
当前命令 PersistentPreRun(E)
当前命令 PreRun(E)
当前命令 Run(E)
当前命令 PostRun(E)
当前命令 PersistentPostRun(E)
父命令 PersistentPostRun(E)
```

---

### 4. 示例

```go
package main

import (
	"fmt"
	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use: "app",
	PersistentPreRun: func(cmd *cobra.Command, args []string) {
		fmt.Println("root PersistentPreRun")
	},
	PersistentPostRun: func(cmd *cobra.Command, args []string) {
		fmt.Println("root PersistentPostRun")
	},
}

var helloCmd = &cobra.Command{
	Use: "hello",
	PreRun: func(cmd *cobra.Command, args []string) {
		fmt.Println("hello PreRun")
	},
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("hello Run")
	},
	PostRun: func(cmd *cobra.Command, args []string) {
		fmt.Println("hello PostRun")
	},
	PersistentPostRun: func(cmd *cobra.Command, args []string) {
		fmt.Println("hello PersistentPostRun")
	},
}

func main() {
	rootCmd.AddCommand(helloCmd)
	rootCmd.Execute()
}
```

执行 `app hello` 的输出顺序：
```
root PersistentPreRun
hello PreRun
hello Run
hello PostRun
hello PersistentPostRun
root PersistentPostRun
```

---

✅ **总结：**
- `PersistentPreRun/PreRun` → 逻辑执行前
- `Run/RunE` → 业务核心
- `PostRun/PersistentPostRun` → 收尾清理
- `Persistent*` 会从父命令继承并在子命令生效；普通 `*` 只在当前命令生效。

---

要不要我给你画一个 **调用流程图**，把这些 Hooks 的执行顺序可视化，方便记忆？


# flag(pflag包)
- user在命令行输入flag和对应的参数就是给flag变量赋值
- 每个命令都有一个flags修饰集合将flag变量加入命令的flagset里
```go
var Region string
//rootCmd.Flags()生成root命令的flag集合
rootCmd.Flags().StringVarP(&Region, "region", "r", "", "AWS region (required)")
//必选标志标记此标志必选
rootCmd.MarkFlagRequired("region")
```

## 持久flag persistent
- 如果一个标志是持久的，则意味着该标志将可用于它所分配的命令以及该命令下的所有子命令。
- rootCmd.PersistentFlags()生成root命令的持久flag集合

## 必选标志
```go
var Region string
//rootCmd.Flags()生成root命令的flag集合
rootCmd.Flags().StringVarP(&Region, "region", "r", "", "AWS region (required)")
//必选标志标记此标志必选
rootCmd.MarkFlagRequired("region")


```

## viper管理
- viper就是管理配置文件crud的
- 可以将flag交给viper和配置文件管理
```go
var serveCmd = &cobra.Command{
	Use:   "serve",
	Short: "启动服务",
	Run: func(cmd *cobra.Command, args []string) {
		port := viper.GetInt("port")
		host := viper.GetString("host")
		fmt.Printf("启动服务: http://%s:%d\n", host, port)
	},
}

var port int=0
var host string=""
serveCmd.Flags().IntVarP(&port,"port", "p",8080, "监听端口")
	serveCmd.Flags().StringVarP(&host,"host","h", "127.0.0.1", "绑定的host")
	// 将 flag 绑定到 viper
    //lookup()查找flag
	viper.BindPFlag("app.port", serveCmd.Flags().Lookup("port"))
	viper.BindPFlag("app.host", serveCmd.Flags().Lookup("host"))

```

