# FxBoot
## easy
```go

package main

import (
	"context"
	"fmt"

	"go.uber.org/fx"
)

type A struct {
	b *B
	c *C
}

func NewA(b_ *B, c_ *C) *A {
	fmt.Println("🔧 正在构造 A，依赖 B 和 C...")
	return &A{b: b_, c: c_}
}

type B struct {
	c *C
}

func NewB(c_ *C) *B {
	fmt.Println("🔧 正在构造 B，依赖 C...")
	return &B{c: c_}
}

type C struct {
	d *D
}

func NewC(d_ *D) *C {
	fmt.Println("🔧 正在构造 C，依赖 D...")
	return &C{d: d_}
}

type D struct {
	tmp int
}

func NewD(lc fx.Lifecycle) *D {
	fmt.Println("🔧 正在构造 D，没有依赖...")
	lc.Append(
		fx.Hook{
			OnStart: func(ctx context.Context) error {
				fmt.Println("D 启动了！")
				return nil
			},
			OnStop: func(ctx context.Context) error {
				fmt.Println("D 停止了！")
				return nil
			},
		},
	)
	return &D{tmp: 42}
}

var FxConfig = fx.Options(
	fx.Provide(
		NewA,
		NewB,
		NewC,
		NewD,
	),
	fx.Invoke(func(a *A) {
		fmt.Println("🚀 A 已经被注入并准备就绪！")
	}),
)

func main() {
	di := fx.New(FxConfig)
	di.Run()
}

```

## complex
```go
package main

import (
	"context"
	"errors"
	"fmt"
	"log"
	"net/http"
	"time"

	"go.uber.org/fx"
)

// --- 1. 类型定义 (Domain) ---

// Repo 接口定义
type Repo interface {
	GetID() string
}

type F struct{ ID string }
type E struct{ ID string }

// C 实现 Repo 接口
type C struct{ ID string }
func (c *C) GetID() string { return c.ID }

// D 实现 Repo 接口，并依赖 F
type D struct {
	ID   string
	DepF *F
}
func (d *D) GetID() string { return d.ID }

type B struct {
	RepoC Repo
	DepE  *E
}

type A struct {
	RepoC Repo
	RepoD Repo
}

type Config struct {
	Addr            string
	ShutdownTimeout time.Duration
}

// --- 2. 构造函数 (Constructors) ---

func NewF() *F {
	fmt.Println("🛠️  创建 F")
	return &F{ID: "F-Component"}
}

func NewE() *E {
	fmt.Println("🛠️  创建 E")
	return &E{ID: "E-Component"}
}

// 返回 Repo 接口
func NewC() Repo {
	fmt.Println("🛠️  创建 C (Repo 实现)")
	return &C{ID: "C-Repo-Instance"}
}

// 返回 Repo 接口
func NewD(f *F) Repo {
	fmt.Println("🛠️  创建 D (Repo 实现, 依赖 F)")
	return &D{ID: "D-Repo-Instance", DepF: f}
}

func NewB(c Repo, e *E) *B {
	fmt.Println("🛠️  创建 B")
	return &B{RepoC: c, DepE: e}
}

func NewA(c Repo, d Repo) *A {
	fmt.Println("🛠️  创建 A")
	return &A{RepoC: c, RepoD: d}
}

func NewHTTPServer() *http.Server {
	return &http.Server{Addr: ":8080"}
}

func NewConfig() Config {
	return Config{Addr: ":8080", ShutdownTimeout: 5 * time.Second}
}

// --- 3. 生命周期与模块 ---

func RegisterHooks(lifecycle fx.Lifecycle, cfg Config, server *http.Server, a *A, b *B) {
	lifecycle.Append(fx.Hook{
		OnStart: func(ctx context.Context) error {
			fmt.Println("------------------------------------")
			fmt.Printf("✅ 系统准备就绪！\n")
			fmt.Printf("📊 A 状态: C_ID=%s, D_ID=%s\n", a.RepoC.GetID(), a.RepoD.GetID())
			fmt.Printf("📊 B 状态: C_ID=%s, E_ID=%s\n", b.RepoC.GetID(), b.DepE.ID)
			fmt.Println("------------------------------------")
			return nil
		},
	})
}

// 模块打包：使用 fx.Annotate 代替 fx.In
var BaseModule = fx.Module("base",
	fx.Provide(
		NewF, 
		NewE, 
		NewConfig,
		// 为 C 打上名为 "repo_c" 的标签
		fx.Annotate(NewC, fx.ResultTags(`name:"repo_c"`)),
	),
)

var LogicModule = fx.Module("logic",
	fx.Provide(
		// 为 D 打上名为 "repo_d" 的标签
		fx.Annotate(NewD, fx.ResultTags(`name:"repo_d"`)),

		// 为 NewB 的第一个参数指定注入 "repo_c"
		fx.Annotate(NewB, fx.ParamTags(`name:"repo_c"`, ``)),

		// 为 NewA 的参数分别指定注入 "repo_c" 和 "repo_d"
		fx.Annotate(NewA, fx.ParamTags(`name:"repo_c"`, `name:"repo_d"`)),

		NewHTTPServer,
	),
)

var FxConfig = fx.Options(
	BaseModule,
	LogicModule,
	fx.Invoke(RegisterHooks),
)

func main() {
	fx.New(FxConfig).Run()
}
```

# callback 回调函数
- 将类型对应的New变量生成函数注册到框架中,通过回调函数(参数传递函数)方式实现
- 生命周期管理用到了钩子回调函数
## lifecyle hook callback 生命周期钩子回调函数
- 对有状态(有数据)的组件注册启动和关闭的钩子回调函数,类似于defer栈顺序清理.close
- onstart顺序是依赖排序顺序,onstop是逆依赖排序顺序便于清理关闭
- 例如数据库,router,...
func NewServer(lc fx.Lifecycle) *http.Server {
    srv := &http.Server{Addr: ":8080"}

    lc.Append(fx.Hook{
        OnStart: func(ctx context.Context) error {
            fmt.Println("Starting HTTP server...")
            go srv.ListenAndServe()
            return nil
        },
        OnStop: func(ctx context.Context) error {
            fmt.Println("Stopping HTTP server...")
            return srv.Shutdown(ctx)
        },
    })

    return srv
}

# new-config
- new(config)变量生成器
- config包含provide(回调函数提供器),module模块,invoke触发器,...
## Option类型
- 统一配置类型便于嵌套组合,provide() invoke() module( ) Options() 返回的都是option类型,便于组合
- 例如provide注册的new函数组合成module,最后统一打包成option
var FxConfig = fx.Options(
	BaseModule,
	LogicModule,
	// 使用 RegisterHooks 触发启动
	fx.Invoke(RegisterHooks),
)


## Provide
- 将类型对应的New变量生成函数注册到框架中,通过回调函数(参数传递函数)方式实现
fx.Provide(NewF, NewE, NewC, NewConfig)

### Module
- 将Provide()返回的option组合便于阅读代码,测试
var BaseModule = fx.Module("base",
	fx.Provide(NewF, NewE, NewC, NewConfig),
)
var LogicModule = fx.Module("logic",
	fx.Provide(NewD, NewB, NewA, NewHTTPServer),
)

## Invoke
- 触发依赖注入,框架拓扑排序完依赖是lazy的需要触发,通过传参依赖树最底部的类型,触发依赖注入
fx.Invoke(func(a *A,b *B) { //触发a,b依赖注入
            fmt.Println("🚀 系统已就绪")
        }),




## Annotate/接口绑定实现
fx.Provide(
		NewA,
		fx.Annotate(NewC, fx.ResultTags(`name:"repo_c"`)),
		fx.Annotate(NewB, fx.ParamTags(`name:"repo_c"`, ``)),
	)

# workflows
- fx.new(config) fx先构建依赖DAG图,进行依赖排序
- 按照依赖排序顺序执行new函数,遇到lifecycle就把钩子函数注册到框架中不执行
- app.run(),执行onstart里注册的钩子函数,按照依赖排序的顺序
- 程序stop后,按照依赖排序逆顺序(栈返回顺序类似defer)运行onstop里的函数进行关闭清理等