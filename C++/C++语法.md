[TOC]

# 指针与引用
## 指针(pointer)
- pointer->对象(一块内存区域) 变量x值的pointer就是&x;
- 指针可以->直接访问成员变量,所以不用考虑指针值*pointer的问题,直接使用!
student * p=&x; studeng & p=x;
p->age; p.age;
- 指针一般用智能指针封装确保安全性

## 引用
- 引用是简化版指针,用来简化代码;引用仅用于函数传参和返回;
- 指针是可变指针,引用是不可变指针且不能指向nullptr

## 基本数据类型(值)与&引用
- c++以基本数据类型为主,指针引用仅为了方便传递对象信息;
- c++编译器在传递引用的时候会自动将变量转换成引用;


## 栈内存和堆内存(new)
- 直接声明的是在栈区域,new 是在堆区域需要手动delet对象;
student x("",19);
student * p=new student("xiaoming",19);//new 出来的对象返回的是一个指针(地址);
- 栈区域执行完{}就会销毁注意要在堆区域开辟;

## 智能指针
- 封装的指针用法和指针一样,工程上new 一般使用智能指针来代替智能释放内存提高安全性
- unique_ptr shared_ptr week_ptr
- shared_ptr<student> xm=make_shared<student>(构造函数/拷贝函数*p)  可用.var简化

# 修饰符
## const只读修饰符
一般在参数传递和成员函数中使用const
- bool cmp(const int&i1,const int&i2){};不能修改参数指针指向的值
- const成员函数不能修改成员变量的值
例如比较器重载bool operator()() const{} 
- 迭代器遍历也是const int&i:set
- 多加const 只读安全访问;

## static 静态修饰符
- 工具方法,共享变量
- static修饰的函数对象存在于静态区,外部能访问静态,静态只能访问静态区不能访问外部区;


# 类和对象
## 访问权限
- public 类内外可访问
- protected 类外不可访问可以继承
- private 类外不可访问不可继承
- 类外可访问:public 不可访问:protected private   可继承:public protected  不可继承: private

## 运算符重载
```cpp
class Point {
public:
    int x, y;
    // 构造函数
    Point(){}
    Point(int x_, int y_){
        x=x_;
        y=y_;
    }

    // 重载==
    bool operator==(const Point& other) const {
        return x == other.x && y == other.y;
    }

    // 重载<
    bool operator<(const Point& other) const {
        if (x == other.x) return y < other.y;
        return x < other.x;
    }

    // 你可以继续重载其他运算符（可借助==和<实现）
};

```
- 重载需要双const

- 抽象代数中运算符是f(a,b)->c 的三维函数;
- a+b -> c


```c++
class student {
public:
    string name;
    int age;
    student(string n,int a) {
        name=n;
        age=a;
    }
    student(){}
    void print() {
        cout<<name+" "<<age<<endl;
    }
};
```
## 构造函数()
- 起到初始化的作用,例如有r S  构造函数(r){S=Π*r*r;}
- 构造函数就是()运算符 可以在变量后() 也可以在类后();
- 重载需要写上空构造;

- 栈空间 student xiaoming(n,a)
直接在栈空间申请自动销毁,xiaoming()相当于构造函数student()
stduent xiaoming=student(n,a) 相当于构造了一个对象在把值拷贝到xiaoming上

- 堆空间 student* xiaoming=new student(n,a)
student()构造了一个对象值,new返回这个对象的指针;
需要手动销毁否则内存泄漏;



## 析构函数

## 拷贝函数
- 构造函数形复制
student xm(xiaoming,22);
student xh(xm);



# 比较器
- true 代表优先级正确 false代表优先级错误需要调换;a<b升序,a>b降序;
- 函数型
sort 函数传递具体的对象所以转递函数指针;
```c++
bool cmp(const int&i1,const int&i2){
    return i1<i2;
}
```
- 类型
优先级队列泛型传递比较器所以用重载()的类
```c++
class cmp {
    bool operator()(const int&i1,const int&i2)const{
        return i1<i2;
    }
};
```
传入到泛型中 set<int,cmp>;

# 迭代器
- iterator
有序容器都有迭代器对象,就是个指针
- iterator.begin()指向索引0,iterator.end()指向n
- 迭代器left right用begin和end构造  会遍历left到right-1这个区间
- 对需要进行迭代的容器可以用迭代器简化函数
- fill
std::fill(src.begin() + srcPos, src.begin() + srcPos + len,value);
- copy
std::copy(src.begin() + srcPos, src.begin() + srcPos + len, dest.begin() + destPos);
- insert
arr.insert(arr.begin()+n,value);
- erase
arr.erase(left,right);
- 改查;

# 函数
- 函数的参数拷贝传递
- 一般用引用做参数

# lambda函数
- auto f = [&y](auto x){return x+1;};
- auto f = [capture](auto arg){};
- 防止命名污染,和起名难..


# 数组
- 建议直接使用vector类,vector<int> arr(n,init),指针信息在栈,内存开辟在堆,相当于智能指针自动释放内存
- 矩阵 vector<vector<int>> mat(n,vector<int>(m,0));
## 函数
- (n,init) 初始化,初始n个,init值;
- fill copy增删改查操作用迭代器实现
- .resize(n,init) 重新指定大小扩充用init扩,缩小直接删;
- .push_back(x) .pop_back()
- 


# 字符串
start 和 n居多
- string 
## 函数
- 增 += insert(start,"");
- 删 erase(start,n);
- 改 replace(start,n,"");
- 查 substr(start,n) find("",start);
- 迭代器法详见迭代器,建议使用索引法,数组都是迭代器法,字符串都是索引法
- to_string(int,double,...)
- stoi  stod  stoll...
## 重载运算符
- + "ab"+"cd"=="abcd"


# 哈希表
- set
- unordered_set
- map
- unordered_map

# deque

## queue

## stack

# 优先队列


# 头文件
#include<bits/stdc++.h>


# 基本数据类型
- char int long long (不开longlong见祖宗)
- double float long double
double 15位有效位数
long double 18有效位数
- 一般用double int大了开longlong
- sizeof() 字节数

# IO
```cpp
int main{
    std::ios::sync_with_stdio(false);
    std::cin.tie(0);
}
```
关闭与stdio的同步,关闭cin触发cout刷新


# goto
- 一般跳出嵌套循环
- 跳到标记处
```cpp
for(int i=0;i<100;i++){
    for(int j=0;j<100;j++){
        if(j==3){
            goto loop;
        }
    }
}
loop:
    cout<<"";
    return 0;
```
