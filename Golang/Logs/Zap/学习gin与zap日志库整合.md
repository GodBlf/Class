# 学习gin与zap日志库整合

## 🧑‍💻 User

我在学gin 给我讲解日志zap这个库

---
## 🤖 Assistant

好的，你在学 **Gin**，想要了解 **zap** 这个日志库。下面我给你详细讲解一下。

---

## 一、zap 是什么？
- **zap** 是 Uber 开源的高性能、结构化日志库。
- 相比 Go 标准库的 `log`，`zap` 的特点是：
 1. 性能极高：内部是零分配（zero allocation）、并发安全。
 2. 结构化日志：允许以 **key-value** 的方式输出，方便日志采集和分析。
 3. 可配置性强：提供开发模式（development）、生产模式（production），自定义日志格式、日志等级、输出位置等。

---

## 二、常见日志库对比
- `log`（标准库）：简单，性能普通，无结构化支持。
- `logrus`：曾经很流行，支持 `Fields`（结构化字段），API 使用方便。
- `zap`：性能优于 `logrus`，在高并发、日志量大的生产环境更合适。

---

## 三、zap 的基本使用
zap 提供了两个常用的构造函数：

```go
import (
	"go.uber.org/zap"
)

func main() {
	// 创建一个生产日志记录器（JSON 格式，info 级别以上）
	logger, _ := zap.NewProduction()
	defer logger.Sync() // 刷新缓冲

	// 创建一个开发日志记录器（更适合调试，打印更友好）
	// logger, _ := zap.NewDevelopment()

	// 普通日志
	logger.Info("Hello zap")

	// 带结构化字段的日志
	logger.Info("user login",
		zap.String("username", "alice"),
		zap.Int("age", 20),
	)
}
```

日志输出示例（Production 模式下是 JSON 格式）：
```json
{"level":"info","ts":1700000000.123,"msg":"user login","username":"alice","age":20}
```

---

## 四、在 Gin 中集成 zap
通常我们希望 Gin 框架的请求日志、错误日志都通过 zap 来记录。
可以写一个 Gin 中间件：

```go
package middleware

import (
	"time"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

func ZapLogger(logger *zap.Logger) gin.HandlerFunc {
	return func(c *gin.Context) {
		start := time.Now()
		c.Next()
		latency := time.Since(start)

		// 记录日志
		logger.Info("access log",
			zap.String("method", c.Request.Method),
			zap.String("path", c.Request.URL.Path),
			zap.Int("status", c.Writer.Status()),
			zap.Duration("latency", latency),
			zap.String("clientIP", c.ClientIP()),
		)
	}
}
```

在 `main.go` 里使用：
```go
r := gin.New()
logger, _ := zap.NewProduction()

// 注册 zap logger 中间件
r.Use(middleware.ZapLogger(logger), gin.Recovery())

r.GET("/ping", func(c *gin.Context) {
	c.JSON(200, gin.H{"msg": "pong"})
})

r.Run()
```

---

## 五、进阶配置
### 日志写入文件（每天切割）
可以结合 **lumberjack** 库：
```go
import (
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
	"gopkg.in/natefinch/lumberjack.v2"
)

func InitLogger() *zap.Logger {
	writer := zapcore.AddSync(&lumberjack.Logger{
		Filename:   "./app.log",
		MaxSize:    10,   // MB
		MaxBackups: 5,    // 旧文件个数
		MaxAge:     30,   // 保留天数
		Compress:   true, // 是否压缩
	})

	encoderConfig := zap.NewProductionEncoderConfig()
	encoderConfig.TimeKey = "time"
	encoderConfig.EncodeTime = zapcore.ISO8601TimeEncoder

	core := zapcore.NewCore(
		zapcore.NewJSONEncoder(encoderConfig), // 输出 JSON 格式
		writer,
		zap.InfoLevel,
	)

	return zap.New(core)
}
```

---

## 六、常用技巧
1. `logger.Sugar()` 可以使用「糖」API，更接近 `fmt.Printf`：
```go
sugar := logger.Sugar()
sugar.Infof("user %s logged in", "alice")
```
但性能比 `zap.XXX` 稍差。

2. 在生产中推荐：
 - 用 `zap.NewProduction()` 或自定义配置（结合文件切割）。
 - 使用结构化字段，方便日志系统（如 ELK、Graylog）收集。

---

✅ 总结：
- **zap 是 Go 中性能和功能都很强的日志库**。
- **使用场景**：高并发、高性能、需要结构化日志的 Web 服务（Gin 正适合）。
- **Gin 集成方式**：写一个 `zap` 中间件，替代默认的 Gin 日志。

---

要不要我帮你写一个 **完整的 Gin + zap + 日志切割** 的小项目结构示例，方便你拿来直接跑呢？

---
## 🧑‍💻 User

讲解zap日志的配置

---
## 🤖 Assistant

好的 👍
你是想深入了解 **Zap 日志的配置**，我来带你分层次地梳理一下。Zap 的配置可以分为三类：

---

# 一、常见的配置场景
1. **日志级别**（Debug、Info、Warn、Error、DPanic、Panic、Fatal）
2. **日志编码器**（JSON 或 Console 格式）
3. **时间格式、输出时间精度**
4. **输出目标**（stdout、文件、日志采集系统）
5. **日志切割**（通常配合 lumberjack 使用）
6. **开发 vs 生产环境不同配置**

---

# 二、Zap 内置的配置方式

Zap 内置有两种便捷构造方式：
- `zap.NewDevelopment()`：适合本地调试，打印的日志比较“花哨”，颜色高亮。
- `zap.NewProduction()`：适合线上生产环境，输出 JSON 格式，日志级别 `Info` 以上。

如果需要个性化配置，就需要用 `zap.Config` 或 `zapcore` 自定义。

---

# 三、使用 `zap.Config` 配置日志
Zap 提供了一个 `Config` 结构体，非常方便：

```go
import (
	"go.uber.org/zap"
)

func main() {
	cfg := zap.Config{
		Level:       zap.NewAtomicLevelAt(zap.InfoLevel), // 日志等级
		Development: false,                              // 开发模式？false表示生产
		Sampling: &zap.SamplingConfig{                   // 日志采样（可选，减少输出量）
			Initial:    100,
			Thereafter: 100,
		},
		Encoding: "json", // 输出格式：json 或 console

		EncoderConfig: zap.NewProductionEncoderConfig(), // 编码配置（可以自定义）
		OutputPaths:   []string{"stdout", "./app.log"},  // 输出到控制台和文件
		ErrorOutputPaths: []string{"stderr"},            // 错误日志输出
	}

	// 修改时间和级别的编码方式
	cfg.EncoderConfig.TimeKey = "time"
	cfg.EncoderConfig.EncodeTime = zap.ISO8601TimeEncoder
	cfg.EncoderConfig.LevelKey = "level"
	cfg.EncoderConfig.EncodeLevel = zap.CapitalLevelEncoder

	// 构建 logger
	logger, _ := cfg.Build()
	defer logger.Sync()

	logger.Info("应用启动",
		zap.String("env", "production"),
		zap.Int("version", 1),
	)
}
```

输出示例（JSON 格式）：
```json
{"level":"INFO","time":"2024-07-25T15:30:05.123+0800","msg":"应用启动","env":"production","version":1}
```

---

# 四、使用 `zapcore` 自定义配置
如果要做更细致的配置（比如写文件、切割、控制台格式不同），就要用 `zapcore`。

```go
import (
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
	"gopkg.in/natefinch/lumberjack.v2"
)

// 初始化Zap Logger
func InitLogger() *zap.Logger {
	// 配置日志切割
	lumberJackLogger := &lumberjack.Logger{
		Filename:   "./app.log", // 日志文件路径
		MaxSize:    10,          // 单个日志文件最大 10 MB
		MaxBackups: 5,           // 最多保留 5 个旧文件
		MaxAge:     30,          // 最多保留 30 天
		Compress:   true,        // 是否压缩归档
	}

	// 输出目标（文件 + 控制台）
	fileWriter := zapcore.AddSync(lumberJackLogger)
	consoleWriter := zapcore.AddSync(zapcore.Lock(zapcore.AddSync(zapcore.AddSync(zapcore.AddSync(stdout)))))

	// 日志编码配置
	encoderConfig := zap.NewProductionEncoderConfig()
	encoderConfig.TimeKey = "time"
	encoderConfig.EncodeTime = zapcore.ISO8601TimeEncoder
	encoderConfig.LevelKey = "level"
	encoderConfig.EncodeLevel = zapcore.CapitalColorLevelEncoder // 有颜色

	// core: encoder + writer + level
	core := zapcore.NewTee(
		zapcore.NewCore(zapcore.NewJSONEncoder(encoderConfig), fileWriter, zap.InfoLevel),   // 文件JSON日志
		zapcore.NewCore(zapcore.NewConsoleEncoder(encoderConfig), consoleWriter, zap.DebugLevel), // 控制台打印
	)

	return zap.New(core, zap.AddCaller(), zap.AddStacktrace(zap.ErrorLevel))
}
```

这样，你的日志就会：
- **控制台输出 彩色 console 格式**（Debug 级别以上）
- **文件输出 JSON 格式**（Info 级别以上）
- **文件支持自动切割、归档**

---

# 五、日志级别配置
Zap 的日志级别有：
- `Debug`（最低、最详细）
- `Info`
- `Warn`
- `Error`
- `DPanic`
- `Panic`
- `Fatal`（程序会退出）

使用 `zap.NewAtomicLevelAt(level)` 可以动态设置日志等级。

如果要在运行时动态调整（比如通过接口修改），可以用：
```go
atom := zap.NewAtomicLevel()
atom.SetLevel(zap.DebugLevel)
```

---

# 六、推荐的配置模式
- **开发环境**
 - console 格式
 - level = Debug
 - 输出到控制台
- **生产环境**
 - json 格式
 - level = Info 或 Warn
 - 输出到文件（+ lumberjack 分割）

---

✅ 总结：
Zap 配置一般分三层：
1. 简单模式：`zap.NewDevelopment()` / `zap.NewProduction()`
2. 灵活模式：`zap.Config`
3. 高级模式：`zapcore`（完全自定义：日志编码、输出位置、多目标、多级别写入等）

---

要不要我帮你写一个 **开发/生产可切换的 zap 配置示例**，比如通过配置文件（YAML/JSON）来加载？这样就能随环境自动切换日志格式和输出方式。
