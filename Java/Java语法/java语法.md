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



## 访问权限
- public : 全局可访问
- protected : 包级权限 包内可访问子孙类可访问
- default : 包级权限 子孙类不可访问
- private : 仅类内可访问

一般都是public private

## this
- this自指对象(类)本身
- 
## 继承
- 子类将父类all都继承,相当于多个类组合构造一个对象,访问权限规范子类
```java
public class Sun extends Father{
    private String skill;
    public Sun(){}
    public Sun(int age,String name,String skill){
        super(age,name);
        this.skill=skill;
    }
    public void test(){
        int i = super.get();
        System.out.println(i);
    }

}
public class Father {
    private int age=0;
    private String name;
    public Father(){}
    public Father(int age, String name) {
        this.age = age;
        this.name = name;
    }
    public int get(){
        return this.age;
    }

}
```



### 方法重载
```java
public class Student{
    public int age;
    public String name;
    public String school;
    public Student(){}
    public Student(int age,String name){
        this(age,name,"...");
    }
    public Student(int age,String name ,String school){
        ...;
    }

```

### super
- 就近原则重名优先近的
- 和this类似 指向父类
- super() 父类构造方法 子类构造方法先调父类构造方法因为 方法区加载了父类和子类两个类

## 多态
- 子类给父类打补丁
### 一、什么是多态

**多态**（Polymorphism）是指同一个行为在不同对象上有不同表现形式（即同一个方法调用，表现出不同的执行效果）。

**简单理解**：同一个方法名，不同的实现。

---

### 二、多态的体现

Java中的多态主要体现在以下两个方面：

1. **方法的重写（Override）**
   子类重写父类的方法，调用方法时，实际执行的是子类的实现。

2. **对象的多态性（父类引用指向子类对象）**
   父类类型的变量可以引用子类类型的对象。

---

### 三、多态的实现条件

要实现多态，需要满足以下三个条件：

1. **继承关系**（有父子类关系）
2. **方法重写**（子类重写父类方法）
3. **父类引用指向子类对象**

---

### 四、代码示例

#### 1. 类定义

```java
class Animal {
    public void eat() {
        System.out.println("动物在吃东西");
    }
}

class Dog extends Animal {
    @Override
    public void eat() {
        System.out.println("狗在吃骨头");
    }
}

class Cat extends Animal {
    @Override
    public void eat() {
        System.out.println("猫在吃鱼");
    }
}
```

#### 2. 多态使用

```java
public class Demo {
    public static void main(String[] args) {
        Animal a1 = new Dog(); // 父类引用指向子类对象
        Animal a2 = new Cat();

        a1.eat(); // 输出：狗在吃骨头
        a2.eat(); // 输出：猫在吃鱼
    }
}
```
**说明**：虽然`a1`和`a2`的类型是`Animal`，但实际调用的是各自子类的`eat()`方法。

---

### 五、多态的好处

1. **提高代码的可扩展性和可维护性**
   新增子类时，不需要修改调用者代码，只需新增实现即可。

2. **使程序有更好的灵活性和可扩展性**
   统一接口，便于管理和维护。

---

### 六、多态的注意事项

1. **只能调用父类中声明的方法，不能调用子类特有方法（除非强制类型转换）**
   ```java
   Animal a = new Dog();
   a.eat(); // 可以
   a.lookHome(); // 编译错误！Dog特有的方法
   ```
2. **成员变量不具备多态性（编译和运行都看左边类型）**。
3. **方法调用具有多态性（编译看左边，运行看右边）**。

---

### 七、多态中的类型转换
- intanceof 判断
有时候需要将父类引用强制转换为子类类型，以访问子类特有的方法：

```java
Animal a = new Dog();
if (a instanceof Dog) {
    Dog d = (Dog) a;
    d.lookHome(); // 调用Dog特有的方法
}
```

---

### 八、面试常考：多态的绑定

- **编译时绑定**：方法调用时，编译器看左边引用类型（父类有没有这个方法）
- **运行时绑定**：实际执行时，看右边对象的真实类型（执行子类重写的方法）

---

### 九、总结

- 多态的核心是**父类引用指向子类对象**，调用方法时表现为**动态绑定**。
- 多态让代码更加灵活、可扩展。
- 多态只适用于方法，不适用于成员变量。

---

#### **一句话总结：**

> **多态就是同一个引用类型，指向不同的子类对象，调用同一方法时，表现出不同的行为。**

---



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


