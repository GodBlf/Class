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

# 命令结构
- 根命令 子命令 [flags] [args]

# Command结构体

## Hooks
- 给出命令的钩子函数,cobra匹配输入的命令自动回调钩子函数


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

