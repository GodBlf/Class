## 显式实现接口
```go
type router interface {
    Route(path string)
}

type engine struct{}

// 如果 engine 没有实现 Route 方法，下面这行在编译时就会报错：
// cannot use &engine{} (value of type *engine) as router value in variable declaration: 
// *engine does not implement router (missing method Route)
var _ router = &engine{} 

func (e *engine) Route(path string) {
    fmt.Println("Routing to:", path)
}
```