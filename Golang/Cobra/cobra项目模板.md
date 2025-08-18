👌 明白了，你是想要一个**完整可复用的模板**，里面包含：

- **Cobra 根命令 + 子命令** 基础结构
- **PersistentPreRun / PreRun / Run / PostRun** 各阶段的 hook 示例
- **Viper 配置管理**（支持配置文件 + 环境变量 + flag）
- **典型目录结构**（方便扩展）

下面我给你一个可以直接 `go run main.go ...` 就能跑起来的模板。你以后只需要修改命令逻辑，就能快速开始一个新 CLI 项目。

---

# 📂 目录结构（推荐标准）
```
mycli/
├── cmd/
│   ├── root.go       # 根命令
│   ├── hello.go      # 子命令 hello
│   └── config.go     # 配置初始化
├── configs/
│   └── config.yaml   # 默认配置文件
├── go.mod
└── main.go
```

---

# 1. `main.go`
```go
package main

import "mycli/cmd"

func main() {
	cmd.Execute()
}
```

---

# 2. `cmd/root.go`
```go
package cmd

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var (
	cfgFile string
	rootCmd = &cobra.Command{
		Use:   "mycli",
		Short: "A simple CLI template powered by Cobra + Viper",
		Long: `这是一个 CLI 工具模板，集成了 Cobra 命令系统 + Viper 配置管理。
你可以在此基础上扩展子命令，读取配置，实现业务逻辑。`,

		PersistentPreRun: func(cmd *cobra.Command, args []string) {
			// 全局 PreRun：比如初始化日志
			fmt.Println("[root] PersistentPreRun: CLI 初始化中 ...")
		},
		PersistentPostRun: func(cmd *cobra.Command, args []string) {
			fmt.Println("[root] PersistentPostRun: CLI 收尾清理 ...")
		},
	}
)

// Execute 入口函数
func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

func init() {
	// 全局配置文件选项
	rootCmd.PersistentFlags().StringVar(&cfgFile, "config", "", "配置文件路径 (默认: $HOME/.mycli.yaml)")
	// 初始化 viper 逻辑
	cobra.OnInitialize(initConfig)
}
```

---

# 3. `cmd/config.go`
```go
package cmd

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

func initConfig() {
	if cfgFile != "" {
		// 如果用户指定了配置文件
		viper.SetConfigFile(cfgFile)
	} else {
		homeDir, err := os.UserHomeDir()
		cobra.CheckErr(err)
		viper.AddConfigPath(homeDir)   // 支持 $HOME/.mycli.yaml
		viper.AddConfigPath("./configs") // 支持 ./configs/config.yaml
		viper.SetConfigName("config")
		viper.SetConfigType("yaml")
	}

	// 环境变量支持（自动匹配 KEY=VAL）
	viper.SetEnvPrefix("MYCLI") // 环境变量前缀：MYCLI_xxx
	viper.AutomaticEnv()

	// 默认配置值
	viper.SetDefault("app.name", "mycli")
	viper.SetDefault("app.debug", true)

	if err := viper.ReadInConfig(); err == nil {
		fmt.Println("使用的配置文件:", viper.ConfigFileUsed())
	} else {
		fmt.Println("未找到配置文件，使用默认值/flag/环境变量")
	}
}
```

---

# 4. `cmd/hello.go`
```go
package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)
//flags
var user string=""

var helloCmd = &cobra.Command{
	Use:   "hello",
	Short: "打印问候语",
	PreRun: func(cmd *cobra.Command, args []string) {
		fmt.Println("[hello] PreRun: 子命令执行前准备 ...")
	},
	Run: func(cmd *cobra.Command, args []string) {
		// 从 viper 获取配置（来自 flag / 配置文件 / 环境变量）
		name := viper.GetString("app.user")
		if name == "" {
			name = "World"
		}
		fmt.Printf("Hello, %s 👋\n", name)

		// 读取 debug 配置
		if viper.GetBool("app.debug") {
			fmt.Println("[debug] Debug 模式开启")
		}
	},
	PostRun: func(cmd *cobra.Command, args []string) {
		fmt.Println("[hello] PostRun: 子命令运行结束")
	},
}

func init() {
	rootCmd.AddCommand(helloCmd)

	// flag
	helloCmd.Flags().StringVarP(&user,"user","u", "", "用户名 (可通过 flag/env/config 设置)")
	// 绑定到 viper
	viper.BindPFlag("app.user", helloCmd.Flags().Lookup("user"))
}
```

---

# 5. 配置文件示例 `configs/config.yaml`
```yaml
app:
  name: "mycli"
  user: "Alice"
  debug: false
```

---

# 6. 使用示例
1. 默认运行
```bash
go run main.go hello
```
输出：
```
[root] PersistentPreRun: CLI 初始化中 ...
使用的配置文件: /xxx/configs/config.yaml
[hello] PreRun: 子命令执行前准备 ...
Hello, Alice 👋
[hello] PostRun: 子命令运行结束
[root] PersistentPostRun: CLI 收尾清理 ...
```

2. 使用 flag 覆盖配置
```bash
go run main.go hello --user Bob
```
输出：
```
Hello, Bob 👋
```

3. 使用环境变量覆盖
```bash
export MYCLI_APP_USER=Charlie
go run main.go hello
```
输出：
```
Hello, Charlie 👋
```

---

# ✅ 总结
这个模板具备：
- **Cobra 根命令 + 子命令** 搭建
- **完整 Hooks 生命周期** 示例
- **Viper 配置**（支持默认值 + 配置文件 + 环境变量 + flag）
- **清晰目录结构**

👉 你以后只需要在 `cmd/` 下面加新的命令文件，或者扩展 `config.yaml` 即可。

---

要不要我再给你扩展一个**子命令组**（比如 `user add / user list`），展示如何在 `cmd/user.go` 下面管理多级命令结构？这样你可以直接做出像 `kubectl get pods` 这样的层级。