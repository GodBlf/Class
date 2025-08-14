#
- 简化type struct type interface 里不用加var和func 因为外边已经有type了
- 万能:=

# math_refactor
```json
{
    "set":"math", //具体参见/Class/Math/集合论
    "variable":"one of set",
    "state":"variables'value" ,//一组变量具体取值的集合
    "function":{
        "math":"input and output",//数学函数映射定义 参数是变量的副本 stack in math
        "stack":"operate and return when args'state"//底层函数栈,返回函数栈有值

    }

    //记忆:variable->state   function->math and stack->input output operate
}
```
```json
{
    "set":"",
    "variable and function set":"class",
    "function set":"interface",
    "variable set":"struct"
}
```

# 语言设计哲学
- Less can be more
gofmt .go

# 变量
## 作用域
1）声明在函数内部，函数栈内局部变量
    2）声明在函数外部，是对当前包可见(包内所有.go文件都可见)的全局值，类似protect
    3）声明在函数外部且首字母大写是所有包可见的全局值,类似public

## 声明
- 后缀.var方便ide代码补全
- 万能:=
- var i int =1  var i =1  i:=1
```go
var (
    i=1
    j=1
)
```

## 匿名变量_下划线
- 用于忽略值
- 多值返回函数 可以 _,y=f(3,4) 忽略第一个返回值
- 迭代器 for _,v := range slice 忽略迭代器索引仅用值

# 函数


## 函数第一公民


### 一、什么是“第一公民”？
在编程语言领域，“第一公民（First-class citizen）”这个术语的意思是：
> 某个实体（比如函数、对象等）在语言中可以像其他变量一样使用 —— 可以赋值给变量、作为参数传递、作为返回值返回等等。

也就是说，如果一个元素（如函数）在语言中满足以下条件，就可以认为它是**第一公民**：
1. **可以赋值给变量**
2. **可以作为函数参数传递**
3. **可以作为函数返回值返回**
4. **可以存储到数据结构中**
5. **可以在运行时创建**

---

### 二、Golang 中的函数是“第一公民”的表现


#### 1. **函数可以赋值给变量**
```go
package main

import "fmt"

func add(a, b int) int {
    return a + b
}

func main() {
    f := add // 将函数赋值给变量
    fmt.Println(f(3, 4)) // 7
}
```

#### 2. **函数可以作为参数传递**
```go
package main

import "fmt"

func compute(a, b int, op func(int, int) int) int {
    return op(a, b)
}

func add(x, y int) int {
    return x + y
}

func main() {
    result := compute(3, 4, add)
    fmt.Println(result) // 7
}
```

#### 3. **函数可以作为返回值返回**
```go
package main

import "fmt"

func adder() func(int) int {
    sum := 0
    return func(x int) int {
        sum += x
        return sum
    }
}

func main() {
    posSum := adder()
    fmt.Println(posSum(1)) // 1
    fmt.Println(posSum(2)) // 3
}
```
#### 3.5 **函数可以多返回值**
```go
func f(a, b int) (x, y int) {
	x, y = b, a
	return 
}
func ff(a, b int) (int, int) {
	return b, a
}

func main() {
	a, _ := f(3, 4) //用不到的用_占位
	i1, i2 := ff(4, 4)
	fmt.Printf("%d %d %d", a, i1, i2)
}
```

上述例子中，`adder` 返回了一个匿名函数（闭包），并且这个函数引用了外部的 `sum` 变量，这也是 Golang 支持**闭包**的体现。

#### 4. **函数可以存储在数据结构中**
```go
package main

import "fmt"

func main() {
    ops := []func(int, int) int{
        func(a, b int) int { return a + b },
        func(a, b int) int { return a - b },
    }

    fmt.Println(ops[0](3, 4)) // 7
    fmt.Println(ops[1](3, 4)) // -1
}
```

#### 5. **可以在运行时定义新的函数（匿名函数）**
```go
package main

import "fmt"

func main() {
    f := func(name string) {
        fmt.Printf("Hello, %s\n", name)
    }
    f("Go") // Hello, Go
}
```

---

### 三、为什么这很重要？
- **灵活性**：函数作为值可以动态组合、传递，实现更通用的代码。
- **高阶函数**：支持函数式编程的一些特性（虽然 Go 并不是纯函数式语言）。
- **闭包**：函数内部可以捕获并访问外部变量，实现状态保持。
- **回调机制**：用函数作为参数来实现事件驱动、策略模式等。

---

### 四、小结
说 **Go 中的函数是第一公民**，是因为它们拥有与其他类型一样的待遇：
- 可以赋值给变量
- 可以作为参数传递给其他函数
- 可以从函数返回
- 可以存在数组、map 等数据结构中
- 可以在运行时动态创建（匿名函数）

换句话说，**在 Go 中，函数是一种特殊的类型（`func`），和其他类型一样，可以被自由操作**。

---

✅ 如果你想，我还可以帮你画一个**Go 函数作为第一公民特性的思维导图**，能更清楚地看到所有特性之间的关系。你要我画吗？

# 内存
## java
- java全是引用数据类型
- java 直接new
## :=
- go中常用值,仅传递参数等用指针
h *IntHeap 指针声明
*p 指针使用
&p 指针获取
- go中内存栈和堆开辟内存会被编译器优化所以直接:=生成值
```golang
p := Person{
    Name:"Jane",
    Age:10        //json格式赋值
}
f(&p)  //直接&变量使用指针

//一般用指针直接:= & 不用new因为有逃逸分析
p :=&Person{...}
```
## make
- 引用数据类型
go中仅slice map chan 用make生成是引用数据类型
- 在append等扩充slice返回新的slice要用引用的指针
```go
type IntHeap []int
//...
func (h *IntHeap) Push(x any){

}
```

# comma ok
- map contains
- 错误处理

# 类型转换
Go语言中只有强制类型转换，没有隐式类型转换。该语法只能在两个类型之间支持相互转换的时候使用。

强制类型转换的基本语法如下：  
[]byte(str string)
## any interface{}
- 参见java的Object


### 类型断言
- x.(int)

# 数据结构
## slice

## map

### maps

### set

## range迭代器

## sort接口
- 参见 java的类比较方法和Comparable<>{}接口(lambda表达式简化)
- 鸭子类型实现Len()int Less()bool Swap()函数
```go
func (h IntHeap) Len() int           { return len(h) }
func (h IntHeap) Less(i, j int) bool { return h[i] < h[j] } //true在左边 false在右边
func (h IntHeap) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }
```
实现元素实现sort接口才可以用slices.sort排序否则用slices.sortfunc


## cmp函数
- slices.sortfunc
- func(a,b T) int  -1a在左边 1a在右边 0相等 注意和sort接口的Less()bool不同
```go
arr := make([]int, 34)
	slices.SortFunc(arr, func(a, b int) int {
		return a - b  //参见java -1在左边 1在右边 0相等
	})
```

### dustbin
- ~~sort.slice 因为之前没有泛型性能不高所用用slices.sort替代~~
```go
arr := make([]int, 2034)
    //匿名函数参数是索引因为go之前没有泛型
	sort.Slice(arr, func(i, j int) bool {
		return arr[i] > arr[j]
	})
```

## heap
- 参见java PriorityQueue
鸭子类型实现sort接口和heap接口
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

## lis


## string
- []索引 有中文转换为[]rune
- len(str)	返回字节长度
- +或fmt.Sprintf	拼接字符串建议用strings.Builder
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

### 1. 内置函数

#### `len(s)`
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

### 2. `strings` 包常用函数

需要先导入：
```go
import "strings"
```

#### 2.1 基本查询
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

#### 2.2 字符串大小写
- `strings.ToLower(s)` 转小写
- `strings.ToUpper(s)` 转大写
- `strings.Title(s)` 单词首字母大写（已废弃，不推荐）
- `cases.Title()`（更推荐，来自 `golang.org/x/text/cases`）

---

#### 2.3 替换与重复
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

#### 2.4 分割与拼接
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

#### 2.5 修剪
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

### 3. `strconv` 包（字符串与数值转换）

导入：
```go
import "strconv"
```

#### 3.1 数字转字符串
```go
strconv.Itoa(123) // "123"
strconv.FormatFloat(3.14159, 'f', 2, 64) // "3.14"
```

#### 3.2 字符串转数字
```go
n, _ := strconv.Atoi("123") // n = 123
f, _ := strconv.ParseFloat("3.14", 64) // f = 3.14
b, _ := strconv.ParseBool("true")      // b = true
```

---

### 4. Rune 与 UTF-8 相关
Go 字符串是字节序列，如果含有中文等多字节字符，要按 **rune（Unicode code point）** 处理：

```go
import "unicode/utf8"

s := "世界"
fmt.Println(len(s))                    // 6 字节
fmt.Println(utf8.RuneCountInString(s)) // 2 rune
```

---

### 5. 小结
常用的字符串处理函数主要在：

- **内置函数:** `len()`
- **strings 包:** Contains、HasPrefix、HasSuffix、Index/LastIndex、ToUpper/ToLower、Replace、Repeat、Split、Join、Fields、Trim/TrimSpace
- **strconv 包:** 字符串与数字/布尔的转换
- **unicode/utf8 包:** 多字节字符长度计算等

---

### 底层
- string底层是一个[]byte 可转换为[]rune
- rune类型是int32储存unicode字符 英文1字节 中文3-4字节
- 操作字符串可以将string强制类型转换为[]byte() 如果要处理中文用[]rune()转换 然后用slice的函数去操作
- len返回字节长度所以可以转换为[]rune再len 推荐用utf8.RuneCountInString(str)


### strconv
#### 3.1 数字转字符串
```go
strconv.Itoa(123) // "123"
strconv.FormatFloat(3.14159, 'f', 2, 64) // "3.14"
```

#### 3.2 字符串转数字
```go
n, _ := strconv.Atoi("123") // n = 123
f, _ := strconv.ParseFloat("3.14", 64) // f = 3.14
b, _ := strconv.ParseBool("true")
```
### strings.Builder
- 参见java的StringBuilder
- 用于字符串拼接
- 常用方法WriteString String WriteByte WriteRune Write([]Byte)



