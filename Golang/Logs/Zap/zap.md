

# new-config
- zap.New(zapcore,options) config包含zapcore和其他options
- zapcore包含level json(encoding(格式) write(写入地方))

## Level
func getLogLevel(s string) zapcore.Level {
	var l zapcore.Level
	if err := l.UnmarshalText([]byte(s)); err != nil {
		return zap.InfoLevel
	}
	return l
}
## Encoder
func getFileEncoder() zapcore.Encoder {
	config := zap.NewProductionEncoderConfig()
	config.EncodeTime = zapcore.ISO8601TimeEncoder
	config.EncodeLevel = zapcore.CapitalLevelEncoder
	return zapcore.NewJSONEncoder(config)
}
## Writer
- 搭配lumberjack实现日志分割
func getLogWriter(f string, s, b, a int, c bool) zapcore.WriteSyncer {
	return zapcore.AddSync(&lumberjack.Logger{
		Filename: f, MaxSize: s, MaxBackups: b, MaxAge: a, Compress: c,
	})
}

# zap集成到gin的日志模板
```go
package logger

var (
	lg          *zap.Logger
	AtomicLevel = zap.NewAtomicLevel()
)

const TraceIDKey = "trace_id"

type LoggerConfig struct {
	Level        string
	Filename     string
	ErrorName    string
	MaxSize      int
	MaxBackups   int
	MaxAge       int
	Compress     bool
	LogInConsole bool
}

// InitLogger 初始化
func InitLogger(cfg *LoggerConfig) {
	AtomicLevel.SetLevel(getLogLevel(cfg.Level))

	// 过滤器：只记录 ERROR 及以上
	errorEnabler := zap.LevelEnablerFunc(func(lvl zapcore.Level) bool {
		return lvl >= zap.ErrorLevel
	})

	var cores []zapcore.Core

	// 全量日志
	allWriter := getLogWriter(cfg.Filename, cfg.MaxSize, cfg.MaxBackups, cfg.MaxAge, cfg.Compress)
	cores = append(cores, zapcore.NewCore(getFileEncoder(), allWriter, AtomicLevel))

	// 错误日志分流
	errWriter := getLogWriter(cfg.ErrorName, cfg.MaxSize, cfg.MaxBackups, cfg.MaxAge, cfg.Compress)
	cores = append(cores, zapcore.NewCore(getFileEncoder(), errWriter, errorEnabler))

	if cfg.LogInConsole {
		cores = append(cores, zapcore.NewCore(getConsoleEncoder(), zapcore.AddSync(os.Stdout), AtomicLevel))
	}

	lg = zap.New(zapcore.NewTee(cores...), zap.AddCaller())
	zap.ReplaceGlobals(lg)
}

// L (Context Logger) 是核心技巧：从 Context 中提取 TraceID 并返回带字段的 Logger
func L(ctx context.Context) *zap.Logger {
	if ctx == nil {
		return lg
	}
	// 兼容 Gin Context 和标准 Context
	var traceID string
	if gCtx, ok := ctx.(*gin.Context); ok {
		traceID = gCtx.GetString(TraceIDKey)
	} else {
		if id, ok := ctx.Value(TraceIDKey).(string); ok {
			traceID = id
		}
	}

	if traceID != "" {
		return lg.With(zap.String(TraceIDKey, traceID))
	}
	return lg
}

// --- 内部辅助函数 ---
func getFileEncoder() zapcore.Encoder {
	config := zap.NewProductionEncoderConfig()
	config.EncodeTime = zapcore.ISO8601TimeEncoder
	config.EncodeLevel = zapcore.CapitalLevelEncoder
	return zapcore.NewJSONEncoder(config)
}

func getConsoleEncoder() zapcore.Encoder {
	config := zap.NewDevelopmentEncoderConfig()
	config.EncodeLevel = zapcore.CapitalColorLevelEncoder
	config.EncodeTime = zapcore.ISO8601TimeEncoder
	return zapcore.NewConsoleEncoder(config)
}

func getLogWriter(f string, s, b, a int, c bool) zapcore.WriteSyncer {
	return zapcore.AddSync(&lumberjack.Logger{
		Filename: f, MaxSize: s, MaxBackups: b, MaxAge: a, Compress: c,
	})
}

func getLogLevel(s string) zapcore.Level {
	var l zapcore.Level
	if err := l.UnmarshalText([]byte(s)); err != nil {
		return zap.InfoLevel
	}
	return l
}

//gin中间件设置,通过context传递信息
func TraceMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		// 1. 尝试从 Header 获取（用于跨服务追踪），没有则生成新的
		traceID := c.GetHeader("X-Trace-ID")
		if traceID == "" {
			traceID = uuid.New().String()
		}

		// 2. 注入到 Context 中
		c.Set(logger.TraceIDKey, traceID)

		// 3. 设置响应头，方便前端/调用方反馈 ID
		c.Header("X-Trace-ID", traceID)

		c.Next()
	}
}

//使用
func main() {
	// 1. 初始化日志
	logger.InitLogger(&logger.LoggerConfig{
		//配合viper使用
	})

	r := gin.Default()

	// 2. 注册 Trace 中间件
	r.Use(middleware.TraceMiddleware())

	r.GET("/ping", func(c *gin.Context) {
		// 3. 使用 logger.L(c) 打印日志
		logger.L(c).Info("收到一个请求", zap.String("user", "test_user"))

		if someError := doSomething(); someError != nil {
			// 这条日志会自动进入 app.log 和 error.log，且都带有同一个 TraceID
			logger.L(c).Error("处理业务逻辑失败", zap.Error(someError))
		}

		c.JSON(http.StatusOK, gin.H{"message": "pong"})
	})

	r.Run(":8080")
}

func doSomething() error {
	return nil // 模拟错误返回
}

```