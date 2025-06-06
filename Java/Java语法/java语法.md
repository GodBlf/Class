[TOC]
# 
- 这个为Java语法的重构版本,在学了c后对底层有了一些了解对java语法进行重构
- 没有的参见c++语法
# 引用(java中的指针)
- java除了int 等基本数据类型都是cpp中的引用类型 student & xm;
- 引用就是指针 pointer->new new出来的是值返回的是地址指针
## 参数传递
- 因为java中都是引用,所以方法的参数 增强for(迭代器) ...等都生成的一个指针副本
- 基本数据类型是值的副本


# 修饰符
## final

## static

# 类和对象
## 访问权限

## 默认值和初始化

## 构造函数

## 拷贝函数

## static

## this


# 匿名内部类

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


