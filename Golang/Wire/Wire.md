# wireboot
```go
package main

type A struct {
	astr string
}

func NewA(aa string) *A {
	return &A{astr: aa}
}

type B struct {
	bA   A
	bint int
}

func NewB(a *A, bb int) *B {
	return &B{bA: *a,
		bint: bb,
	}
}
//go:build wireinject
// +build wireinject

package main

import "github.com/google/wire"

func InitB(aValue string, bValue int) (*B, error) {
	wire.Build(
        NewA, 
        NewB)
	return nil, nil
}
// 使用 wire.Struct 为 Config 结构体创建一个 Provider
		// new(config.Config) 表示要构建 config.Config 类型
		// "*" 表示 Wire 应该尝试注入 config.Config 的所有字段 (Port, Env)
		//wire.Struct(new(config.Config), "*"),
		// 当然，你也可以指定特定的字段：
		// wire.Struct(new(config.Config), "Port", "Env"),

// 输入wire命令
```

# type 自定义类型
- wire是通过类型进行依赖注入的所以对于字段冲突可以用type自定义类型
- type port int  type password int

# wireset
将一个包的New函数打包成wireset wire.build直接传set