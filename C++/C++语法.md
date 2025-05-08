[TOC]

# 指针与引用
- pointer->对象(一块内存区域) 变量x的pointer就是&x;
- 指针是可变指针,引用是不可变指针且不能指向nullptr
引用是简化版指针,用来简化代码;
可以用引用重构指针来简化代码
```c++
    set<int,cmp> *set_=new set<int, cmp>;
    set<int,cmp>& set=*set_;
```

- 指针可以->直接访问成员变量,所以不用考虑指针值*pointer的问题,直接使用!
student * p=&x; studeng & p=x;
p->age; p.age;

## 基本数据类型(值)与&引用
- c++以基本数据类型为主,指针引用仅为了方便传递对象信息;
- c++编译器在传递引用的时候会自动将变量转换成引用;


## 栈内存和堆内存(new)
- 直接声明的是在栈区域,new 是在堆区域需要手动delet对象;
student x("",19);
student * p=new student("xiaoming",19);//new 出来的对象返回的是一个指针(地址);
- 栈区域执行完{}就会销毁注意要在堆区域开辟;

# const只读修饰符
- bool cmp(const int&i1,const int&i2){};
- const成员函数不能修改成员变量的值
例如比较器重载bool operator()() const{} 
- 迭代器遍历也是const int&i:set
- 多加const 只读安全访问;

# 类和对象
```c++
class student {
public:
    string name;
    int age;
    student(string n,int a) {
        name=n;
        age=a;
    }
    void print() {
        cout<<name+" "<<age<<endl;
    }
};
```

## 对象的复制
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


# 数组
- 建议直接使用vector类,vector<int> arr(n),指针信息在栈,内存开辟在堆
- 

# 字符串
start 和 n居多
- string 
- 增 += insert(start,"");
- 删 erase(start,n);
- 改 replace(start,n,"");
- 查 substr(start,n) find("",start);

# 哈希表
- set
- unordered_set
- 

# deque

## queue

## stack

# 优先队列


# 头文件
#include<bits/stdc++.h>