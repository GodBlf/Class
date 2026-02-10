# generator(生成器)- 工厂
- 对象的创建交给生成器,框架或者工厂,仅提供配置信息
## 变量生成器
- new(&config{})
- 这种是常见的第三方库生成对象的方式,使用new函数
```go
func NewXxxVar(&XxxCfg{})
```


## 函数生成器
- 常用于钩子函数的注册
- 解决的问题:钩子函数通常被框架限制类型所以,通过函数生成器闭包的形式可以传递额外自定义信息
```go
func NewRegexFilterHook(pattern string) gin.HandlerFunc {
    regex, err := regexp.Compile(pattern) // 只编译一次
    if err != nil {
        log.Fatalf("Invalid regex pattern: %s", pattern)
    }
    return func(c *gin.Context) {
        if regex.MatchString(c.Request.URL.Path) {
            // ... do something ...
        }
        c.Next()
    }
}
gin.get("/",NewRegexFilterHook("test"))
```

# callback(回调函数)
- 框架
you call library , framework call you
you call library function,framework call your function

- 回调函数
将函数作为参数传递,注册到框架中,框架触发后自动调用此函数
形象:先注册好函数,等触发后在回来调用这个函数
```go
func NewFunc() gin.HandlerFunc{
    return func(ctx *gin.Context){
        //...
    }
}
gin.Get("/",NewFunc())
//...
gin.Run(":8080")
```


# singleton 单例设计模式
- 设计global全局变量和initialize初始化函数
- 生成器new和init的区别是从无到有 和 对全局变量加信息
## eager init
- 对全局变量立即初始化
## lazy init
- 懒汉初始化,等到使用单例变量才初始化返回这个单例
- 每次使用时假设未进行init,每次都init返回这个全局变量进行使用
- go的 sync.once天然支持,在多协程（Goroutines）并发调用的情况下，sync.Once 保证了初始化逻辑（Do 内部的匿名函数）有且仅执行一次。
```go
var(
    singleton *type
    singleton_once sync.Once{}
)

func InitSingleton() *type{
    //lazy init 懒初始化
    singleton_once.Do(func(){
        //...
        sinleton=...
    })
    return singleton 
}

```


# type-var 
- 变量
变量就是内存ram中的一块区域
var在内存中的大小表示包含什么变量,例如struct{int,string},在内存中很大var包含很多
- 类型
为什么要有类型,因为方便编译器给变量分配内存空间,和运算规则;
类型区存放着类型的信息有描述了某个变量的大小,适合的运算符等
类型和 变量总是成对出现的,在项目中设计类型往往比变量重要
- type运算符
type这个是全等运算符,type Duration int  相当于Duration全等于int,将Duration类型再放到类型区中
类型不能直接使用只能用他们创造新的变量例如 x:=&MyDVar{...},编译器会通过类型的信息给 变量分配空间
## pointer
- 用有向图考虑 pvar-->var![alt text](image-2.png)
- 指针设计模式,不关心内部变量的创建直接传递来指针直接用
- 控制反转:将组件之间依赖关系的创建和管理，以及程序流程的控制权，从应用程序代码本身转移到外部容器或框架。
直接用变量不关心创建,实现解耦
- 依赖注入 (Dependency Injection - DI) 是一种设计模式，它的核心思想是：一个对象（或组件）不应该自行创建它所依赖的其他对象，而应该由外部注入(new函数传递参数)这些依赖。
- new函数参数传递注入到结构体中实现依赖注入,wire框架实现具体的变量生成,符合ioc思想

## 函数的底层也是变量
- 因为函数和理论强相关详见(skills)
- 函数也是个变量 func(int) int 是类型也存放在类型区
func myfunction(x int) int{} 这是func(int) int 类型的一个实例变量
- 函数调用底层是通过函数栈实现,调用函数入栈,return出栈.例如f(g(x)) ->f->g ; g return ->f ; f return ->

## dustbin
### lazy global
- 有的时候注入的变量需要全局一份,可以通过lazy global来实现
- 用lazy global的方式实现优化依赖注入,将变量设置为懒全局变量仅在需要的时候使用,
具体实现方式用new once方式实现

```golang
var(
    ServiceVar *ServiceImpl
    once=&sync.Once{}   //为啥这里需要赋值因为仅声明once *sync.Once 没有具体变量无法调用
)

type ServiceImpl struct{
    Dependency InterfaceOrImpl
    //...
}

func NewServiceImpl(d InterfaceOrImpl){
    once.Do(func(){
        ServiceVar=&Service{
            Dependency:d,
            //,
        }
    })
    return ServiceVar
}

```
- 需要设置为lazy global的就是依赖注入变量,不需要的就是变量包含,依赖注入的直接传参数里交给wire框架,变量包含自己赋值

详见wire

# midwear(中间层)
- 封装具体实现,仅能通过中间层调用实现,实现抽象,扩展,通信,缓冲等

## 接口
- 类型的中间层
abstract抽象中文垃圾翻译,改成摘要,提取一个物体的关键部分方便研究
接口等都是具体struct的抽象
- 给具体的变量实现加一个中间层,这个中间层是函数的集合,调用变量仅能通过接口 
- 简化,从var operator tree角度思考面向接口编程
- type之类的struct interface type []int等都是反应变量的内部情况包含什么,方法就是对应的operator
- interface是一个tree他链接这多个实现的变量,父节点是midwear子节点是具体的实现
- 因为调用具体实现需要通过接口所以生成接口变量的New由配置好的wire框架实现,在wire框架中配置生成接口变量所需的所有实现和接口;

## 函数栈中间件
在原本运行的函数栈之间加入一个函数栈这样访问先访问中间件,return,后return中间件
### 并发控制
![alt text](image.png)
加入并发控制中间件
![alt text](image-1.png)
等待组的并发控制外移分离并发控制和业务逻辑
- 树形结构考虑线程,go func在主线程节点分出一个子线程,子线程root下就是这个func函数,控制外移就是在root和func之间加一个中间控制函数
- 匿名函数+defer实现并发控制外移
- 原本需要go f(wg *sync.WaitGroup){defer wg.done()}
wg仅起到flag标记函数返回没有的标记,所以抽离出来放在原函数和新线程root之间的中间件,
原函数返回的时候正好defer掉wg
- 因为golang支持闭包所以可以不用传wg这个参数
```go
main{
wg := &sync.WaitGroup{}
	wg.Add(1)
	go func() {
		defer wg.Done()
		chatsession.ChatStream(ctx, "讲解算法中的二分答案法")
	}()
	wg.Add(1)
	go func() {
		defer wg.Done()
		chatsession.ChatStreamOut()
	}()
	wg.Wait()

}
```

### gin中间件

## channel <->
- 在两个对象间加入一个管道实现数据的传输通信
- 例如go中的chan实现协程通信
- llm中的stream流

## buffer <-
- 在数据传输过程中加入一个中间临时存放的容器
- 例如在构建对象，io等中间加一个容器提升速度

## filter
- redis rag


# 装饰器
- 将对象包装（wrap）在另一个对象中，这个包装对象在调用原有方法前后添加新的行为，从而增强功能,不改变对象名字
- 根据不修改只增加的原则,我们想增加原来函数功能,可以再包一层函数,不改变原函数功能和名字且通过函数闭包扩展
原函数功能,外部仅能通过这个包装的新中间函数来调用