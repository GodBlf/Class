
# goBoot
```json
{
    "x:=&type{:}"//{}是在内存中生成变量var相当于java中的new 用is赋值方法
}

```
### 赋值格式讨论
- is格式, var is what/var : 7,
```go
tmp:=&user{
    name: "mike",
    age: 10,
}
```
- json格式, 字段是字符串
```json
{
    "name":"mike",
    "age":12
}
```
- yml格式, 极其简化字段和值都不考虑类型
```yml
redis: 
    passwd: 123
    db: 0
```

### dustbin
```json
{
    "x:=newfunc()":":=()", //1
    "x:=&is{:}":":=&{}"//2
    //都表示在内存ram中开辟变量var的意思
}

```
- go中()是函数 函数类型 {}是生成
{}用is格式初始化 : 是 is
- 万能:= go强调变量名称弱化类型后置
:=&struct{} go自动解引用指针推荐传指针
:=newfunc() 因为go的临时内存无法寻址所以函数返回的直接:=不用考虑& 即便()出来是值也没关系传递的时候&取地址就可以;

- 和python一样强大的, i,j=j,i
Go 语言的 := 是 短变量声明，它的规则是：
在同一个作用域中，:= 左边必须至少有一个是新的变量，其它变量可以是已经存在的变量。
对于已经存在的变量，:= 其实是普通的重新赋值。所以err能赋值两次
}另起一行要加, 因为避免;
```go
i, err := f(3)
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println(i)
	i2, err := f(34)
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println(i2)
```
赋值的时候行末尾都要加,
```go
student :=&{
    Name:"asd",
    Age:234,
}
Logger.Info(
    "message",
    zap.String("",""),
    zap.Int64("",54),
)

```

- 简化type struct type interface 里不用加var和func 因为外边已经有type了

- 包一般小写命名
### 字节
golang以字节为底层很多都得转成底层[]byte进行操作
- json.marshal()求结构体字节,[]byte()强转为字节
- sha256.sum([]byte)加密某个字节

# 基础
## 内存
### java
- java全是引用数据类型
- java 直接new
### := &
- go中常用值,仅传递参数和内存大的时候用指针
h *IntHeap 指针声明
*p 指针使用
&p 指针获取
#### 逃逸分析
- go中内存栈和堆开辟内存会被编译器优化所以直接:=生成值
```golang
p := Person{
    Name:"Jane",
    Age:10        //is格式赋值
}
f(&p)  //直接&变量使用指针

```
#### 最佳实践
- x:=&is{:} x:=newfunc()
- //一般用指针直接:= & 不用new因为有逃逸分析
p :=&Person{...}
建议直接p:=&struct{}
因为很多方法 的接受体值满足的可以用指针和值 指针满足的只能用指针
- 结构体一般是值,函数参数和返回一般是结构体指针

### make
- 引用数据类型
go中仅slice map chan 用make生成是引用数据类型
- 在append等扩充slice返回新的slice要用引用的指针
```go
type IntHeap []int
//...
func (h *IntHeap) Push(x any){

}
```
#### 重新赋值
因为slice是引用指向底层数组所以涉及增删改操作的底层会开辟新数组,所以返回新的引用要重新赋值
- append  slices.delete insert replace
- map不需要重新赋值因为开始就开辟了一个很大的数组不需要开辟新数组



## 变量
### boot
- var a int
- var a int = 1
- var a =1 //不推荐因为type很重要
- a:=1
- var(
    a int =1 
    b float=0.1
    )
- conn, err := net.Dial("tcp", "127.0.0.1:8080"); conn1, err := net.Dial("tcp", "127.0.0.1:8080")
- conn, _ := net.Dial("tcp", "127.0.0.1:8080")
- a,b=b,a
### 作用域
1）声明在函数内部，函数栈内局部变量
    2）声明在函数外部，是对当前包可见(包内所有.go文件都可见)的全局值，类似protect
    3）声明在函数外部且首字母大写是所有包可见的全局值,类似public

- 减少变量作用域
```go
if a := 10; a >5 {
    fmt.Println(a)
    return
}
```

### 声明
- 后缀.var方便ide代码补全
- 万能:=
- var i int =1  var i =1  var()
```go
var (
    i=1
    j=1
)
```
### 全局变量
- 在go文件zhong var i int  var()
仅声明不赋值
- 在init函数或者具体函数中初始化

### 匿名变量_下划线
- 用于忽略值
- 多值返回函数 可以 _,y=f(3,4) 忽略第一个返回值
- 迭代器 for _,v := range slice 忽略迭代器索引仅用值

## 函数
- io stack
### 函数类型
- 算子输入变量输出变量 输入值输出值 func f(n int) int {} ; 变量n类型是int;f(n int)是算子输出的变量类型是int;
所以参数有名称返回值不加名称,因为f(n int)本身就是变量
- 多返回值是给error准备的

- go中函数是一个类型
func(int, int) (int, int) or func(a,b int) (x,y int)
函数类型声明定义确保有input和output即可

- Go 编译器判断函数类型时，只关心：
参数的 数量、顺序、类型
返回值的 数量、顺序、类型
参数名和返回值名都不参与类型匹配 
参数只是个占位符,编译器底层会忽略掉形式参数名称参见java jvm
- 代码美学(少写注释)+go强调变量名称 建议所有函数类型和定义都写上参数名称 返回值名称随意因为函数名称就是返回值名称
func print(x int) int{}  func f(a,b int func(x int) int ) int{}

### 函数第一公民

说 **Go 中的函数是第一公民**，是因为它们拥有与其他类型一样的待遇：
- 可以赋值给变量
- 可以作为参数传递给其他函数,从而实现回调函数callback
- 可以从函数返回
- 可以存在数组、map 等数据结构中
- 可以在运行时动态创建（匿名函数）

换句话说，**在 Go 中，函数是一种特殊的类型（`func`），和其他类型一样，可以被自由操作**。



### 匿名函数
- 参见java的lambda表达式
f=func(a,b int) int{
    return a+b
}

### 编译器内置函数
- len cap append copy delete
- 速度快但是太底层len返回字节数等 常用len append 其他slices maps包有泛型函数

### init函数
- 包导入执行用于初始化

### defer
- 栈
return函数栈返回从下到上依次执行函数体内的defer语句
延迟在return赋值后RETURN前执行,defer 常用于资源释放、panic 恢复
当一个函数中有多个 defer 语句时，它们会被推送到一个栈上，并在函数即将返回时，按照 后进先出 (LIFO) 的顺序执行。
- 立即赋值
defer语句的参数是立即赋值的所以要用,func(){}()包裹

## 类型
为什么要有类型,因为方便编译器给变量分配内存空间,和运算规则;
类型区存放着类型的信息有描述了某个变量的大小,适合的运算符等
类型和 变量总是成对出现的,在项目中设计类型往往比变量重要

### type 运算符
type 类型1 类型2
在ram定义区开辟一个类型1变量他和类型2变量全等
例如 type time int64;  time类型和int64类型全等

### struct结构体
- struct{} 也是一种类型,是一种集合类型
- 经常搭配type运算符使用定义新的类型
```go
type ClientRam struct{
    ...
}
```

```go
type IntHeap []int

func (h IntHeap) Len() int {
	return len(h)
}
func (h IntHeap) Less(a,b int) bool {
	return h[a]<h[b]
}
func (h IntHeap) Swap(i,j int) {
	h[i],h[j]=h[j],h[i]
}
func (h *IntHeap) Push(x any) {
	*h= append(*h, x.(int))
}
func (h *IntHeap) Pop() any {
	old:=*h
	n:= len(old)
	x:=old[n-1]
	*h=old[0:n-1]
	return x
}
```

### 结构体
- variable set is struct
#### 结构体使用
- :=&is{}格式初始化 最佳实践
//一般用指针直接:= & 不用new因为有逃逸分析
p :=&Person{...}
- 直接p:=&struct{}
函数传递参数自动解引用 (dereference)指针
因为很多方法 的接口接受体值满足的可以用指针和值 指针满足的只能用指针

#### is格式讨论
为什么is格式用:为变量初始化 因为=是赋值的意思 :是 is的意思
强调键值关系

#### 4. 访问结构体字段

使用点 `.` 操作符来访问结构体的字段。

```go
p := Person{Name: "Frank", Age: 40}
fmt.Println(p.Name) // Frank
fmt.Println(p.Age)  // 40

p.Age = 41 // 修改字段值
fmt.Println(p.Age) // 41
```

如果结构体变量是一个指针，Go 语言会自动解引用（dereference）它，所以你可以像访问普通结构体一样访问字段。

```go
ptrP := &Person{Name: "Grace"} // ptrP 是一个指向 Person 结构体的指针
fmt.Println(ptrP.Name) // Grace (等同于 (*ptrP).Name)
```

#### 5. 结构体作为函数参数

当结构体作为函数参数传递时，默认是**传值**（pass by value）。这意味着函数会接收结构体的一个副本。如果想让函数修改原始结构体，需要传递结构体的**指针**。

```go
func printPerson(p Person) {
    fmt.Printf("Name: %s, Age: %d\n", p.Name, p.Age)
    // p 是一个副本，修改它不会影响原始结构体
    p.Age = 99
}

func changePersonAge(p *Person, newAge int) {
    // p 是一个指针，修改它会影响原始结构体
    p.Age = newAge
}

func main() {
    person := Person{Name: "Heidi", Age: 28}
    printPerson(person) // Name: Heidi, Age: 28
    fmt.Println("Original age after printPerson:", person.Age) // Original age after printPerson: 28

    changePersonAge(&person, 29)
    fmt.Println("New age after changePersonAge:", person.Age) // New age after changePersonAge: 29
}
```

#### 6. 匿名结构体（Anonymous Struct）

匿名结构体是没有明确名称的结构体类型。它们通常用于一次性使用或作为函数的返回值。

```go
// 定义并初始化一个匿名结构体
data := struct {
    ID   int
    Name string
}{
    ID:   1,
    Name: "Anonymous User",
}

fmt.Println(data.Name) // Anonymous User

// 作为函数返回值
func GetConfig() struct {
    Host string
    Port int
} {
    return struct {
        Host string
        Port int
    }{
        Host: "localhost",
        Port: 8080,
    }
}

config := GetConfig()
fmt.Println(config.Host, config.Port) // localhost 8080
```

#### 7. 匿名字段/嵌入实现继承

Go 语言没有继承的概念，但通过结构体嵌入（也称为组合或匿名字段）可以达到类似的效果。将一个结构体类型直接作为另一个结构体的字段，而不需要指定字段名。被嵌入的结构体的字段和方法会被“提升”到外部结构体，可以直接访问。

```go
type Address struct {
    Street  string
    City    string
    ZipCode string
}

type Employee struct {
    Person    // 嵌入 Person 结构体
    Address   // 嵌入 Address 结构体
    EmployeeID string
    Salary     float64
}

func main() {
    emp := Employee{
        Person: Person{
            Name: "Ivy",
            Age:  30,
        },
        Address: Address{
            Street:  "123 Main St",
            City:    "Anytown",
            ZipCode: "12345",
        },
        EmployeeID: "E001",
        Salary:     50000.0,
    }

    // 直接访问嵌入结构体的字段
    fmt.Println(emp.Name)       // Ivy
    fmt.Println(emp.City)       // Anytown (来自 Address)
    fmt.Println(emp.EmployeeID) // E001

    // 如果字段名冲突，需要通过完整的路径访问
    // 假设 Person 和 Address 都有一个字段叫 'ID'
    // emp.Person.ID 和 emp.Address.ID
}
```

#### 8. 结构体标签（Struct Tags）

结构体标签是附加在结构体字段上的字符串元数据。它们通常用于反射（reflection）机制，为编码/解码（如 JSON, XML）、数据库映射等提供额外的信息。

```go
type User struct {
    ID     int    `json:"id" db:"user_id"` // id：用于 JSON 序列化/反序列化；db：用于数据库映射
    Name   string `json:"name"`
    Email  string `json:"email,omitempty"` // omitempty：如果字段是零值，则在 JSON 中忽略
    Status string `json:"-"`               // -：忽略此字段，不进行 JSON 编解码
}

func main() {
    u := User{
        ID:    101,
        Name:  "John Doe",
        Email: "john.doe@example.com",
        Status: "active",
    }

    jsonData, _ := json.Marshal(u)
    fmt.Println(string(jsonData)) // {"id":101,"name":"John Doe","email":"john.doe@example.com"} (Status被忽略)

    u2 := User{
        ID:    102,
        Name:  "Jane Smith",
        Email: "", // Email 是零值
        Status: "inactive",
    }
    jsonData2, _ := json.Marshal(u2)
    fmt.Println(string(jsonData2)) // {"id":102,"name":"Jane Smith"} (Email和Status都被忽略)
}
```

#### 9. 结构体与方法（Methods）

虽然不是结构体本身的属性，但方法是 Go 语言中与结构体紧密结合的概念。你可以为任何类型（包括结构体）定义方法，从而为结构体添加行为。

```go
type Rectangle struct {
    Width  float64
    Height float64
}

// 为 Rectangle 类型定义一个计算面积的方法
// (r Rectangle) 是接收者，表示这个方法属于 Rectangle 类型的值
func (r Rectangle) Area() float64 {
    return r.Width * r.Height
}

// 为 Rectangle 类型定义一个改变尺寸的方法
// (r *Rectangle) 是指针接收者，表示这个方法可以修改原始 Rectangle 结构体
func (r *Rectangle) Scale(factor float64) {
    r.Width *= factor
    r.Height *= factor
}

func main() {
    rect := Rectangle{Width: 10, Height: 5}
    fmt.Printf("Initial Area: %.2f\n", rect.Area()) // Initial Area: 50.00

    rect.Scale(2.0)
    fmt.Printf("Scaled Area: %.2f\n", rect.Area()) // Scaled Area: 200.00 (Width, Height 都翻倍了)
}
```


### any/interface{}
- any是interface{}别名 {}生成一个空接口
- 参见java object

### 接口
type midwear
- 接口嵌入
```go
// Sayer 接口
type Sayer interface {
    say()
}

// Mover 接口
type Mover interface {
    move()
}

// 接口嵌套
type animal interface {
    Sayer
    Mover
}
```
#### 显式实现接口
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

## 泛型
参数化类型
```go
func add[T int | float64](a, b T) T {
	return a + b
}
type Number interface{
	int | float64 | float32	
}
func sub[T Number] (a,b T) T{
	return a - b
}

func main() {
	tmp1 := add[int](1, 2)
	tmp2:=sub[float64](3.3,2.1)
	fmt.Println(tmp1)
	fmt.Println(tmp2)
}
```

## comma ok
- map contains
- 错误处理

## goto
- 和java的循环标签类似
```go
for true{
for true{
    if...
    goto loop
}
}
loop:

```


## 类型转换
Go语言中只有强制类型转换，没有隐式类型转换。该语法只能在两个类型之间支持相互转换的时候使用。

强制类型转换的基本语法如下：  
[]byte(str string)
### any interface{}
- 类型断言
v,ok:=x.(int)
```go
        x = "ms的go教程"
       v, ok := x.(string)
       if ok {
           fmt.Println(v)
       } else {
           fmt.Println("类型断言失败")
       }
```



## 数据结构
- 数据结构类不用方法 用对应包的工具函数操作 例如 slices maps strings 包

### slice
- 通过make创建引用数据类型 make([]int,size,capacity)
- make([]int,2,15) //创建一个长度为2容量15的切片 相当于初始为 [0,0]
#### 底层
![alt text](image.png)
![alt text](image-1.png)
- 切片指针
用一个指针指向切片 切片再指向底层数组
方便切片append生成新的切片指针再指向新切片
```go
func (*h IntHeap) Push(x any) {
    *h=append(*h,x.(int))
}
```
#### 重新赋值
因为slice是引用指向底层数组所以涉及增删改操作的底层会开辟新数组,所以返回新的引用要重新赋值
- append  slices.delete insert replace
- map不需要重新赋值因为开始就开辟了一个很大的数组不需要开辟新数组

#### slices包
- len append
- 增删改查
##### 1. 背景

从 **Go 1.21** 开始，Go 标准库新增了 [`slices`](https://pkg.go.dev/slices) 包，它提供了**针对任意切片的常用通用操作函数**。
这些函数基于 Go 1.18 引入的 **泛型（Generics）** 实现，简化了日常对切片的排序、搜索、比较、复制、截断等操作。

在 Go 1.21 及以上版本，你可以直接使用：

```go
import "slices"
```

---

##### 2. 函数列表与讲解

###### 2.1 比较类函数

####### `slices.Equal`
```go
func Equal[S ~[]E, E comparable](s1, s2 S) bool
```
判断两个切片元素和顺序是否相等。
**要求元素类型 `E` 必须是可比较的 (`comparable`)**。

**示例：**
```go
package main

import (
    "fmt"
    "slices"
)

func main() {
    a := []int{1, 2, 3}
    b := []int{1, 2, 3}
    fmt.Println(slices.Equal(a, b)) // true
}
```

---

####### `slices.EqualFunc`
```go
func EqualFunc[S1 ~[]E1, S2 ~[]E2, E1, E2 any](s1 S1, s2 S2, eq func(E1, E2) bool) bool
```
使用自定义比较函数判断两个切片是否相等（元素可以是不同类型）。

**示例：**
```go
people1 := []string{"Alice", "Bob"}
people2 := []string{"ALICE", "BOB"}
eq := func(a, b string) bool {
    return strings.EqualFold(a, b)
}
fmt.Println(slices.EqualFunc(people1, people2, eq)) // true
```

---

###### 2.2 排序类函数

####### `slices.Sort`
```go
func Sort[E constraints.Ordered](x []E)
```
原地排序，元素必须是有序类型（数字、字符串等）。

```go
nums := []int{3, 1, 2}
slices.Sort(nums)
fmt.Println(nums) // [1 2 3]
```

---

####### `slices.SortFunc`
```go
func SortFunc[E any](x []E, cmp func(a, b E) int)
```
使用自定义比较函数排序，`cmp` 返回：
- 负值：a < b
- 0：a == b
- 正值：a > b

```go
people := []string{"Bob", "Alice", "Tom"}
slices.SortFunc(people, func(a, b string) int {
    return strings.Compare(a, b)
})
```

---

####### `slices.SortStableFunc`
稳定排序，比较方式同上，但稳定地保持相等元素原有顺序。

```go
slices.SortStableFunc(data, cmp)
```

---

###### 2.3 搜索类函数

####### `slices.BinarySearch`
```go
func BinarySearch[E constraints.Ordered](x []E, target E) (index int, found bool)
```
二分查找（切片必须已排序）。

```go
nums := []int{1, 3, 5, 7}
idx, found := slices.BinarySearch(nums, 5)
// idx = 2, found = true
```

---

####### `slices.BinarySearchFunc`
```go
func BinarySearchFunc[E any, T any](x []E, target T, cmp func(E, T) int) (int, bool)
```
自定义比较函数进行二分查找。

---

####### `slices.Index`
```go
func Index[E comparable](s []E, v E) int
```
返回切片中第一次出现 `v` 的索引，不存在返回 `-1`。

---

####### `slices.IndexFunc`
```go
func IndexFunc[E any](s []E, f func(E) bool) int
```
返回满足条件的第一个元素的索引。

---

####### `slices.LastIndex`
```go
func LastIndex[E comparable](s []E, v E) int
```
返回切片中最后一次出现 `v` 的索引。

---

####### `slices.LastIndexFunc`
```go
func LastIndexFunc[E any](s []E, f func(E) bool) int
```
返回最后一个满足条件的索引。

---

###### 2.4 修改操作

####### `slices.Clone`
```go
func Clone[S ~[]E, E any](s S) S
```
返回切片的副本。

---

####### `slices.Concat`
```go
func Concat[S ~[]E, E any](slices ...S) S
```
拼接多个切片，返回新的切片。

---

####### `slices.Insert`
```go
func Insert[S ~[]E, E any](s S, i int, v ...E) S
```
在索引 `i` 处插入元素，返回新的切片。

---

####### `slices.Delete`
```go
func Delete[S ~[]E, E any](s S, i, j int) S
```
删除索引范围 `[i, j)` 内的元素。

---

####### `slices.Replace`
```go
func Replace[S ~[]E, E any](s S, i, j int, v ...E) S
```
替换 `[i, j)` 区间的元素为 `v`。

---

####### `slices.Clip`
```go
func Clip[S ~[]E, E any](s S) S
```
将切片的容量缩小到长度（释放多余底层数组空间）。

---

###### 2.5 条件判断类操作

####### `slices.Contains`
检查切片是否包含某值。

####### `slices.ContainsFunc`
检查切片中是否存在满足条件的元素。

---

###### 2.6 其他

（可能随 Go 版本增加更多方法）

---

##### 3. 小结对比

以前我们操作切片往往需要引入第三方库（如 `golang.org/x/exp/slices`），或手写一些基本的搜索、排序、比较函数。
**Go 1.21 的内置 `slices` 包** 把这些高频操作纳入标准库，让代码简洁、可靠并且类型安全。

---

###### 注意事项：
1. **排序/二分查找前必须保证已有序**（或使用对应的 Sort 进行排序）。
2. 大部分函数都会返回新的切片引用，需要用返回值覆盖原切片变量，否则修改无效。
3. `Delete`、`Insert` 等会重新分配底层数组，可能影响性能；大量数据情况下应关注内存拷贝成本。
4. 如果是 Go 1.18~1.20，可以使用 `golang.org/x/exp/slices`，API 基本一致。

---


### map
- 引用数据类型用make make(map[string]int,capacity)
- comma ok 来判断是否有某个键
```go
func main() {
    scoreMap := make(map[string]int)
    scoreMap["张三"] = 90
    scoreMap["小明"] = 100
    // 如果key存在ok为true,v为对应的值；不存在ok为false,v为值类型的零值
    v, ok := scoreMap["张三"]
    if ok {
        fmt.Println(v)
    } else {
        fmt.Println("查无此人")
    }
}
```

#### maps
- delete len

| 函数        | 作用                         | 备注 |
|-------------|------------------------------|------|
| `Clear`     | 清空 map                      | 原地修改 |
| `Clone`     | 浅拷贝                        | 返回新 map |
| `Copy`      | 从 src 复制到 dst             | 覆盖重复键 |
| `DeleteFunc`| 自定义筛选删除                | 修改原 map | 参见java的removeif 因为迭代器批量删除会有并发问题所以要用匿名函数删
| `Equal`     | 按值比较两个 map              | 键值都可比较 |
| `EqualFunc` | 自定义值比较                  | 支持不可比较值 |
| `Keys`      | 获取所有键切片                | 顺序随机 |
| `Values`    | 获取所有值切片                | 顺序随机 |

- 参见cpp 值得contains函数需要遍历查询

#### set
- s:=make(map[int]any)
用any 空接口代替值

#### 并发安全的map
- sync.Map
```go
    safemap := &sync.Map{}
	safemap.Store("key1", "value1")
	safemap.Store("key2", "value2")
	value, ok := safemap.Load("key1")
	if ok {
		println(value.(string))
	}
	safemap.Range(func(key, value any) bool {
		println(key.(string), value.(string))
		return true
	})
	safemap.Delete("key1")
```

### range迭代器
- for i,v:=range map/slice{}
i索引v值 可用_忽略值

### sort接口
- 参见 java的类比较方法和Comparable<>{}接口(lambda表达式简化)
- 鸭子类型实现Len()int Less()bool Swap()函数
```go
func (h IntHeap) Len() int           { return len(h) }
func (h IntHeap) Less(i, j int) bool { return h[i] < h[j] } //true在左边 false在右边
func (h IntHeap) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }
```
实现元素实现sort接口才可以用slices.sort排序否则用slices.sortfunc


### cmp函数
- slices.sortfunc
- func(a,b T) int  -1a在左边 1a在右边 0相等 注意和sort接口的Less()bool不同
```go
arr := make([]int, 34)
	slices.SortFunc(arr, func(a, b int) int {
		return a - b  //参见java -1在左边 1在右边 0相等
	})
```

#### dustbin
- ~~sort.slice 因为之前没有泛型性能不高所用用slices.sort替代~~
```go
arr := make([]int, 2034)
    //匿名函数参数是索引因为go之前没有泛型
	sort.Slice(arr, func(i, j int) bool {
		return arr[i] > arr[j]
	})
```

### heap
- 参见java PriorityQueue
鸭子类型实现sort接口和heap接口
type IntHeap []int 
点实现接口找heap包下的interface就能自动生成需要实现的方法
```go
package main

import (
    "container/heap"
    "fmt"
)

type IntHeap []int

func (h IntHeap) Len() int           { return len(h) }
//参数一般都是索引因为go之前没泛型
func (h IntHeap) Less(i, j int) bool { return h[i] < h[j] } 
func (h IntHeap) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }

func (h *IntHeap) Push(x any) {
    *h = append(*h, x.(int))
}

func (h *IntHeap) Pop() any {
    old := *h
    n := len(old)
    x := old[n-1]
    *h = old[0 : n-1]
    return x
}
func (h IntHeap) Peek() any{
	return h[0]
}

func main() {
    h := &IntHeap{2, 1, 5} 
    //为什么可以传指针,因为鸭子类型这个指针也满足接口那么它就是接口卧槽!!!!
    heap.Init(h)  //指针接受因为接口中push pop用的指针 
    
    heap.Push(h, 3)
    fmt.Println(heap.Pop(h)) // 输出 1
}

```

### list
- 双端队列参见java linkedlist

### string
- []索引 有中文转换为[]rune
- len(str)	返回字节长度
- +或fmt.Sprintf	复杂拼接字符串建议用strings.Builder
- strings.Split	分割
- strings.Contains	判断是否包含
- strings.HasPrefix,strings.HasSuffix	前缀/后缀判断
- strings.Index(),strings.LastIndex()	子串出现的位置
- strings.ToLower(s) 转小写
strings.ToUpper(s) 转大写
cases.Title()（更推荐，来自 golang.org/x/text/cases）
- strings.Replace(str,old,new,n)
- strings.Join(a[]string, sep string)	join操作
好的，我们来讲讲 **Go语言（Golang）中字符串常用的函数** 以及用法。
在 Go 中，**字符串** 是不可变的 UTF-8 编码字节序列，常用的字符串函数主要来自标准库的两个包：

- [`strings`](https://pkg.go.dev/strings) —— 针对字符串的常用操作函数
- [`strconv`](https://pkg.go.dev/strconv) —— 字符串与其它类型的转换
- 另外还有一些内置函数，例如 `len()`，以及 `[]byte` 转换等

---

#### 1. 内置函数

##### `len(s)`
- 返回字符串的 **字节数**（不是字符数）
```go
package main

import "fmt"

func main() {
    str := "Hello, 世界"
    fmt.Println(len(str)) // 13，因为中文占3个字节
}
```

> 如果想获取字符（rune）数量，需要：
```go
fmt.Println(len([]rune(str))) // 9
```

---

#### 2. `strings` 包常用函数

需要先导入：
```go
import "strings"
```

##### 2.1 基本查询
- `strings.Contains(s, substr)`
  判断 `s` 是否包含子串 `substr`
```go
strings.Contains("hello", "he") // true
```

- `strings.HasPrefix(s, prefix)`
  是否以 `prefix` 开头
```go
strings.HasPrefix("golang", "go") // true
```

- `strings.HasSuffix(s, suffix)`
  是否以 `suffix` 结尾
```go
strings.HasSuffix("picture.jpg", ".jpg") // true
```

- `strings.Index(s, substr)`
  返回子串第一次出现的位置，找不到返回 `-1`
```go
strings.Index("golang", "lan") // 2
```
- `strings.LastIndex(s, substr)`
  返回子串最后一次出现的位置

---

##### 2.2 字符串大小写
- `strings.ToLower(s)` 转小写
- `strings.ToUpper(s)` 转大写
- `strings.Title(s)` 单词首字母大写（已废弃，不推荐）
- `cases.Title()`（更推荐，来自 `golang.org/x/text/cases`）

---

##### 2.3 替换与重复
- `strings.Replace(s, old, new, n)`
  将 s 中前 n 个 old 替换为 new，`n = -1` 表示全部替换
```go
strings.Replace("oink oink oink", "oink", "moo", -1)
// "moo moo moo"
```

- `strings.Repeat(s, count)`
  返回将 s 重复 `count` 次的新串
```go
strings.Repeat("na", 3) // "nanana"
```

---

##### 2.4 分割与拼接
- `strings.Split(s, sep)`
  按 sep 分割字符串，返回切片
```go
strings.Split("a,b,c", ",") // []string{"a","b","c"}
```

- `strings.Join(a []string, sep string)`
  用 sep 拼接字符串切片
```go
arr := []string{"go", "lang"}
strings.Join(arr, "-") // "go-lang"
```

- `strings.Fields(s)`
  按空白字符（空格、换行等）分隔
```go
strings.Fields("foo bar\tbaz\n") // []string{"foo", "bar", "baz"}
```

---

##### 2.5 修剪
- `strings.Trim(s, cutset)`
  去掉 s 首尾的 `cutset` 中的任意字符
```go
strings.Trim(" !!!Hello!!! ", " !") // "Hello"
```

- `strings.TrimSpace(s)`
  去掉首尾空白字符（空格、\t、\n等）

- `strings.TrimPrefix(s, prefix)`
- `strings.TrimSuffix(s, suffix)`
  去掉指定前缀/后缀（如果有）

---

#### 3. `strconv` 包（字符串与数值转换）

导入：
```go
import "strconv"
```

##### 3.1 数字转字符串
```go
strconv.Itoa(123) // "123"
strconv.FormatFloat(3.14159, 'f', 2, 64) // "3.14"
```

##### 3.2 字符串转数字
```go
n, _ := strconv.Atoi("123") // n = 123
f, _ := strconv.ParseFloat("3.14", 64) // f = 3.14
b, _ := strconv.ParseBool("true")      // b = true
```

---

#### 4. Rune 与 UTF-8 相关
Go 字符串是字节序列，如果含有中文等多字节字符，要按 **rune（Unicode code point）** 处理：

```go
import "unicode/utf8"

s := "世界"
fmt.Println(len(s))                    // 6 字节
fmt.Println(utf8.RuneCountInString(s)) // 2 rune
```

---

#### 5. 小结
常用的字符串处理函数主要在：

- **内置函数:** `len()`
- **strings 包:** Contains、HasPrefix、HasSuffix、Index/LastIndex、ToUpper/ToLower、Replace、Repeat、Split、Join、Fields、Trim/TrimSpace
- **strconv 包:** 字符串与数字/布尔的转换
- **unicode/utf8 包:** 多字节字符长度计算等

---

#### 底层
- string底层是一个[]byte 可转换为[]rune
- rune类型是int32储存unicode字符 英文1字节 中文3-4字节
- 操作字符串可以将string强制类型转换为[]byte() 如果要处理中文用[]rune()转换 然后用slice的函数去操作
- len返回字节长度所以可以转换为[]rune再len 推荐用utf8.RuneCountInString(str)


#### strconv
##### 3.1 数字转字符串
```go
strconv.Itoa(123) // "123"
strconv.FormatFloat(3.14159, 'f', 2, 64) // "3.14"
```

##### 3.2 字符串转数字
```go
n, _ := strconv.Atoi("123") // n = 123
f, _ := strconv.ParseFloat("3.14", 64) // f = 3.14
b, _ := strconv.ParseBool("true")
```

#### strings.Builder
- 参见java的StringBuilder
- 用于字符串拼接
- 常用方法WriteString String WriteByte WriteRune Write([]Byte)
#### bytes.buffer
- 缓冲区也可以实现strings.builder的功能,且常用



### big包
- 参见java的BigInteger

#### big.Int
- 内存大用指针接受
- big.newint() .setstring(str)

#### 运算
z:=big.newint(0) z:=&big.Int{} 
z.Add(x,y) z=x+y 内存直接覆盖到z性能更优


# 高级

## go并发编程

### goroutine
- tree
- go func : 在主线程节点下给这个函数栈分配一个子节点线程
树形结构考虑线程,go func在主线程节点分出一个子线程,子线程root下就是这个func函数

### 并发控制
##### waitgroup
- 函数栈中间层实现并发控制
- 树形结构考虑线程,go func在主线程节点分出一个子线程,子线程root下就是这个func函数,控制外移就是在root和func之间加一个中间控制函数
- 匿名函数+defer实现并发控制外移(midwear 函数栈中间层设计)
```函数栈
root->root->
↓
midwear defer 
↓         ↑
child

```
```go
main{
wg := &sync.WaitGroup{}
	wg.Add(1)
	go func() {
		defer wg.Done() //闭包实现defer能够访问到wg变量
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
记得wg.add一定要在主线程加,最后要wg.wait

### 锁
- 多个协程同时共享一块内存会引发竞态问题
- 优先使用原子操作>读写锁>互斥锁
#### 互斥锁
- 竞态问题
互斥锁是一种常用的控制共享资源访问的方法，它能够保证同时只有一个goroutine可以访问共享资源。Go语言中使用sync包的Mutex类型来实现互斥锁。 
```go
var (
	x int
	lock *sync.Mutex = &sync.Mutex{}
)

func add() {
	for i := 0; i < 5000; i++ {
		lock.Lock()
		x++
		lock.Unlock()
	}
}
func main() {
	wg := &sync.WaitGroup{}
	wg.Add(2)
	go func() {
		defer wg.Done()
		add()
	}()

	go func() {
		defer wg.Done()
		add()
	}()
	wg.Wait()
	fmt.Println(x)
}
```


#### 读写锁
- 读并不会引发问题 读写 写写需要加锁
- 适用于读多写少场景,提升性能
```go
var (
	x      int
	lock   *sync.Mutex   = &sync.Mutex{}
	rwlock *sync.RWMutex = &sync.RWMutex{}
)

func write() {
	// lock.Lock()   // 加互斥锁
	rwlock.Lock() // 加写锁
	x = x + 1
	time.Sleep(10 * time.Millisecond) // 假设读操作耗时10毫秒
	rwlock.Unlock()                   // 解写锁
	// lock.Unlock()                     // 解互斥锁
}

func read() {
	// lock.Lock()                  // 加互斥锁
	rwlock.RLock()               // 加读锁
	time.Sleep(time.Millisecond) // 假设读操作耗时1毫秒
	rwlock.RUnlock()             // 解读锁
	// lock.Unlock()                // 解互斥锁
}

func main() {
	wg := &sync.WaitGroup{}
	start := time.Now()
	wg.Add(1010)
	for i := 0; i < 10; i++ {
		go func() {
			defer wg.Done()
			write()
		}()
	}

	for i := 0; i < 1000; i++ {
		go func() {
			defer wg.Done()
			read()
		}()
	}

	wg.Wait()
	end := time.Now()
	fmt.Println(end.Sub(start))
}
```

#### 原子操作
- 对于基本数据类型提供的线程安全函数

### channel
- midwear
- 协程通信,make(chan int,16)
- <- chan int  chan int <-
- error传递到通道里,实现错误返回,另一个线程函数检测到<-chan元素包含错误就直接break return
- close(chan) 关闭通道
- 判断通道是否关闭
comma ok 和 for range 迭代一个channel
- 循环取值
```go
func main() {
    ch1 := make(chan int)
    ch2 := make(chan int)
    // 开启goroutine将0~100的数发送到ch1中
    go func() {
        for i := 0; i < 100; i++ {
            ch1 <- i
        }
        close(ch1)
    }()
    // 开启goroutine从ch1中接收值，并将该值的平方发送到ch2中
    go func() {
        for {
            i, ok := <-ch1 // 通道关闭后再取值ok=false
            if !ok {
                break
            }
            ch2 <- i * i
        }
        close(ch2)
    }()
    // 在主goroutine中从ch2中接收值打印
    for i := range ch2 { // 通道关闭后会退出for range循环
        fmt.Println(i)
    }
}
```

#### 单向通道
- 防御性编程常用于函数参数,强制通道的方向
```go
// 生产者：只负责写 (chan<-)
func produce(out chan<- int) {
    for i := 0; i < 10; i++ {
        out <- i
    }
    close(out) // 发送方负责关闭
}

// 消费者：只负责读 (<-chan)
func consume(in <-chan int) {
    for n := range in {
        fmt.Println("接收到:", n)
    }
}

func main() {
    ch := make(chan int) // 声明时是双向的
    go produce(ch)       // 隐式转换为 chan<-
    consume(ch)          // 隐式转换为 <-chan
}
```

### select
- ifelse变体 vars_hubs
- 阻塞协程只到通道有货或者都无执行default
```go
select{
    case tmp:=<-ch1:
        //...
    case tmp:=<-ch2:
        //...
    case <-ch3:
        //...
    default:
        //通道皆无货执行
}
```

#### select-default 判满判空
- select 就是ifelse 天然实现判断
- 判满
```go
// 判断管道有没有存满
func main() {
   // 创建管道
   output1 := make(chan string, 10)
   // 子协程写数据
   go write(output1)
   // 取数据
   for s := range output1 {
      fmt.Println("res:", s)
      time.Sleep(time.Second)
   }
}

func write(ch chan string) {
   for {
      select {
      // 写数据
      case ch <- "hello":
         fmt.Println("write hello")
      default:
         fmt.Println("channel full")
      }
      time.Sleep(time.Millisecond * 500)
   }
}
```

- 判空类似
```go
select{
    case tmp:=<-ch:
        //...
    default:
        //...
}
```

## context
- context变量继承关系通过函数栈确定
- context变量包含 父context 和一个键值对 key any - value any
#### 传递信息
- 当函数调用链条过长context可以通过key-value和继承关系传递参数
- gin中间件可以通过塞入gin.context key-value信息传递http信息
```go
//实现context继承
func step1(ctx context.Context) context.Context {
	ctx1 := context.WithValue(ctx, "key1", "value1")
	return ctx1
}
func step2(ctx context.Context) context.Context {
	ctx2 := context.WithValue(ctx, "key2", "value2")
	return ctx2
}

func main() {
	ctx := context.Background()
	ctx_child := step1(ctx)
	ctx_child_child := step2(ctx_child)
	fmt.Println(ctx_child.Value("key1"))
	fmt.Println(ctx_child_child.Value("key1"))//value函数可以查找到父context变量的key-value值
	fmt.Println(ctx_child_child.Value("key2"))
}

```

#### 协程取消
- 通过select 管道实现协程取消
- 
##### timeout

```go
{
    go task1

    go task2

    go task3

    select{
        case: <-context.Done()
            logger.Error("time out",
            zap.Err(errors.NewError("time out")))
            return 
        case: <-ch1

        case: <-ch2

        case: <-ch3
    }
}
```
```go
func timeout(ctx context.Context) {
	select {
	    case <-ctx.Done():
		    fmt.Println("超时了")
	}
}

func main() {
	ctx0 := context.Background()
	ctx, cancel := context.WithTimeout(ctx0, time.Millisecond*10)//继承自空context
	defer cancel()
	go timeout(ctx)
	time.Sleep(time.Second)
}

```
- 如果继承的父context也有timeout时间和withtimeout()参数中时间少的继承


```go
func handler(w http.ResponseWriter, r *http.Request) {
    // 创建一个 2 秒的超时 Context
    这些语句时间约等于0s
    ctx, cancel := context.WithTimeout(r.Context(), 2*time.Second)
    defer cancel()

    resultCh := make(chan string, 1)

    //主要耗时任务开另一个协程运行
    go func() {
        // 模拟耗时操作（比如访问数据库/外部服务）
        time.Sleep(3 * time.Second)
        resultCh <- "done"
    }()
    //
    select {
    case res := <-resultCh:
        fmt.Fprintln(w, "result:", res)
    case <-ctx.Done():
        http.Error(w, "request timeout", http.StatusGatewayTimeout)
    }
}

```

#### cancel
```go
func quxiao(ctx context.Context) {
	select {
	case <-ctx.Done():
		fmt.Println("取消了")
		return
	}
}

func main() {
	ctx0 := context.Background()
	ctx, cancel := context.WithCancel(ctx0)
	defer cancel()
	go quxiao(ctx)
	cancel()
}
```

## 反射
- reflect包,反射主要用于解析变量类型和值 type-var

### 动态更新
```go
var (
	_all_user_field = util.GetGormFields(User{})
)
db.Select(_all_user_field)
func GetGormFields(stc any) []string {
    //解析stc结构体中字段的类型并返回[]string切片
	typ := reflect.TypeOf(stc)
	// 如果传的是指针类型，先解析指针获取基础类型
	if typ.Kind() == reflect.Ptr {
		typ = typ.Elem()
	}

	if typ.Kind() == reflect.Struct {
		columns := make([]string, 0, typ.NumField())
		for i := 0; i < typ.NumField(); i++ {
			fieldType := typ.Field(i)
			// 只关注可导出成员 (Public fields)
			if fieldType.IsExported() {
				// 如果 tag 标记为 "-", 则不做 ORM 映射的字段跳过
				if fieldType.Tag.Get("gorm") == "-" {
					continue
				}

				// 默认逻辑：如果没有 gorm Tag，则把驼峰命名转为蛇形命名
				name := Camel2Snake(fieldType.Name)

				// 如果存在 gorm Tag，尝试解析出其中的 column 定义
				if len(fieldType.Tag.Get("gorm")) > 0 {
					content := fieldType.Tag.Get("gorm")
					if strings.HasPrefix(content, "column:") {
						content = content[7:]
						pos := strings.Index(content, ";")
						if pos > 0 {
							name = content[0:pos]
						} else if pos < 0 {
							name = content
						}
					}
				}
				columns = append(columns, name)
			}
		}
		return columns
	} else {
		// 如果 stc 不是结构体则返回空切片
		return nil
	}
}
```

# libs

## error
- 接口
type error interface{
    Error() string
}

- errors.new("**") 简单生成error 这个类型是errorstring
- fmt.Errorf("%w",var) 包装上级error生成error
函数,核心作用,类似操作 (传统)
errors.Is,检查错误链中是否包含特定实例,err == target
errors.As,检查错误链中是否包含特定类型并转换,"target, ok := err.(*Type)"
errors.Unwrap,获得被包装的下一层错误,无直接对应
errors.Join,将多个错误合并为一个,无直接对应
```go
//errors.Is
    var ErrDatabase = errors.New("db error")
    err := fmt.Errorf("extra context: %w", ErrDatabase)
    if errors.Is(err, ErrDatabase) {
        fmt.Println("这是数据库错误")
    }

//errors.As
type QueryError struct {
    SQL string
}
func (e *QueryError) Error() string { return "query fail" }

var qErr *QueryError
if errors.As(err, &qErr) { //注意这里是二级指针,因为*queryError满足error接口
    // 如果匹配成功，qErr 会被自动赋值
    fmt.Println("SQL 语句是:", qErr.SQL)
}
```

### 链式调用error问题
- 因为链式调用方法返回变量本身,Go 的哲学是 if err != nil，但如果在链式调用的每一层都写 if err，链条就断了。
- 所以不返回error,都会有一个Err()函数返回当前链条的error信息
- 常见与数据库操作中例如gorm,go-redis
- err:=x.step1(one).step2(two).Err()

## panic
- 不可预料的致命异常 而error是业务逻辑一部分,例如数据库启动等基础设施报错直接panic,业务增删改查error
- **panic就是return;recover是接受panic的返回值**,所以recover要在defer里这点和java一样,没有recover之前一直return
```go
func main() {         
    defer func() {                 
        if error:=recover();error!=nil{   
            fmt.Println("出现了panic,使用reover获取信息:",error)   
        }         
    }()         
    fmt.Println("11111111111")        
    panic("出现panic")         
    fmt.Println("22222222222") 
 }
// terminal: 1111111111111 \n 出现了panic,使用reover获取信息: 出现panic
```

- panic传递
```go
a->b(defer recover)->c->d(panic) : panic捕获后接着运行a函数
```

- defer中有panic 会丢失掉原先的panic
```go
func test() {
    defer func() {
        // defer panic 会打印
        fmt.Println(recover())
    }()

    defer func() {
        panic("defer panic")
    }()

    panic("test panic")
}
//defer panic
```

## bytes
- []byte字节数组是golang数据传递的base

## io
### Reader接口
- 此接口包含 Read([]byte) 函数可将reader变量信息读到字节数组中

### Writer接口
- 此接口包含 Write([]byte) 函数可以将字节数组写入writer变量

## bufio
- 对writer/reader 进行包装相当于加了层buffer midware
buffer := &bytes.Buffer{}
	writer := bufio.NewWriter(buffer)
	reader := bufio.NewReader(buffer)
包装完用法和writer/reader变量相同

## templateBoot
tmpl := "你是{{.name}}"
	parse, err := template.New("my_template").Parse(tmpl)
	if err != nil {
		panic(err)
	}
	//buffer字节缓冲区相当于strings.builder容器
	bf := &bytes.Buffer{}
	parse.Execute(bf, map[string]any{
		"name": "大学老师",
	})
	fmt.Println(bf.String())
//字符串先解析(离散化)成模板,然后再再buffer中根据map拼接字符串存到buffer里