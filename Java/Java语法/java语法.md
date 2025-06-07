[TOC]
# 
- 这个为Java语法的重构版本,在学了c后对底层有了一些了解对java语法进行重构
- 没有的参见c++语法
# 引用(java中的指针)
- java除了int 等基本数据类型都是cpp中的引用类型 student & xm;
- 引用就是指针 pointer->new new出来的是值返回的是地址指针
## 参数传递
- 因为java中都是引用,所以方法的参数 增强for(迭代器) ...等都生成的一个指针副本
- 基本数据类型参数是值的副本


# 修饰符
## final

## static

# 类和对象
```java
public class Student{
    //默认值
    public int age=0;
    public String name="xiaoming";
    //空构造要加上
    public Student(){}
    //初始化
    public Student(int age,String name){
        this.age=age;
        this.name=name;
    }
}

```


## 默认值和初始化

## 构造函数
- () [] 是本体
## 拷贝函数

##

## static
**参见c++语法的static**
- 工具方法,共享变量
- 属于类本身,内存只有一份,不推荐用对象访问建议用类进行访问
- 静态区,外部可以访问静态区,静态区只能访问静态区
静态方法不能使用this因为this自指对象,对象不在静态区

### 应用
- 共享变量
一份内存共享
```java
public Student(int age, String name) {
        this.age = age;
        this.name = name;
        Student.count++;
    }
```
- 工具方法

- 工具类
设计一些static的方法和变量存在一个工具类里方便当作工具箱
构造方法设计为private 逼格


## 封装(javabean)
```java
public class Student {
    private int age=0;
    private String name;

    public Student(int age, String name) {
        this.age = age;
        this.name = name;
    }
    //提供有参和无参构造方法
    public Student(){}

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        if(age<0){
            System.out.println("error");
            return;
        }
        this.age = age;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}

```

## this
- this自指对象(类)本身

## 访问权限
- public : 全局可访问
- protected : 包级权限 包内可访问子孙类可访问
- default : 包级权限 子孙类不可访问
- private : 仅类内可访问
## 继承


### super
- 就近原则重名优先近的
- 和this类似 指向父类

# 匿名内部类

# 循环标签
- 标签
```java
loop1:for(int i=0;i<100;i++){
    loop2:for(int j=0;j<100;j++){
        if(j==50){
            break loop2;or continue loop1;        
        }

    }
}

```
- 一般直接return就行
# 比较器

# 字符串
- 用StringBuilder
## 方法
- 增 append insert
- 删 delete 
- 改 replace
- 查 indexof charat substring

## 转换
- Integer.parseInt() Integer.valueOf() int 和 Integer
- String.valueOf() ""+int

# Set
## HashSet<>

## TreeSet


# Map
- map.entrySet() 将map转成元素是map.Entry<>的set就能for迭代了


