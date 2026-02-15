# callback设计
- 回调函数
将函数作为参数传递,注册到框架中,框架触发后自动调用此函数
形象:先注册好函数,等触发后在回来调用这个函数
```go
func NewFunc() gin.HandlerFunc{
    return func(ctx *gin.Context){ //函数生成器设计
        //...
    }
}
gin.Get("/",NewFunc())
//...
gin.Run(":8080")
```


# 中间件
- 本质就是哥函数栈midwear
- 中间件gin.handlerfunc用函数生成器创建

## 使用

```go
func NewMidFunc() gin.HandlerFunc{
    return func(ctx *gin.Context){
        err:=step1(ctx)
        if err!=nil{
            ctx.String(err.Error())
            ctx.Abort()//中止不再调用后边回调函数
            return//记得return
        }
        step2(ctx)
        ctx.Next()//框架调用下一个回调函数
        step3(ctx)//调用完回调函数可以接着执行step3
    }
}

func NewFunc() gin.HandlerFunc{
    return func(ctx *gin.Context){ //函数生成器设计
        //...
    }
}
gin.Get("/",NewMidFunc(),NewFunc())
//...
gin.Run(":8080")

```