# 导论
- cobra眼睛蛇 viper毒蛇
- 底层基于flag包开发的开发命令行接口框架
- 搭配viper(CLIs配置框架)

# 命令结构
- 根命令 子命令 [flags] [args]

# Command结构体


## Hook


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

# pflag
- 每个命令都有一个flags修饰集合
- 将flag变量加入命令的flagset里
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

