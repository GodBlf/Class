# viperBoot
```go
package config
func CreateConfig(file string) *viper.Viper {
	config := viper.New()
	configPath := global.ProjectRootPath + "config/"//项目根目录获取
	config.AddConfigPath(configPath)
	config.SetConfigName(file)
	config.SetConfigType("yaml")
	configFile := configPath + file + ".yaml"
	err := config.ReadInConfig()
	if err != nil {
		cerror := &viper.ConfigFileNotFoundError{}
		errors.As(err, &cerror)
		if cerror != nil {
			panic("配置文件未找到: " + configFile)
		} else {
			panic("读取配置文件失败: " + err.Error())
		}
	}
	return config
}
```

# 项目根目录单例设置
- 引用一个包初始化顺序是const var init(),且初始化是单例的,再次引用不再执行初始化
```go
package global
var (
	ProjectRootPath string = getoncurrentPath() + "/../"//用这个变量
)

func getoncurrentPath() string {
	_, file, _, _ := runtime.Caller(0) //返回第0级(偏移量为0)调用堆栈信息
	return path.Dir(file)              //返回路径的目录部分
}
```