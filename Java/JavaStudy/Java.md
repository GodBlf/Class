[TOC]
# ReadMe
与java有关的语法  API 题目等;数据结构 算法具体的知识 与之有关的技巧不写入;
# Java Grammar and API
## Grammar
### 格式化输出
自己写个用StringBuilder格式化方法
格式化输出是指在打印数据时，以特定的格式将数据展示出来，通常包括数字的精度控制、宽度控制、对齐方式、填充字符等内容。在 C 语言和 Java 中，格式化输出的功能通过 `printf` 和 `System.out.printf` 来实现。尽管两者的语法略有差异，但它们遵循类似的格式化规则。

###### 1. 基本格式

**格式化字符串的基本结构**：
```
%[flags][width][.precision][length]specifier
```

其中，各个部分的含义如下：
- `%`：格式化输出的标志。
- `[flags]`：可选的标志，用来控制对齐、填充等。
- `[width]`：输出的最小宽度。如果输出的内容小于该宽度，会使用空格（或其他填充字符）填充。
- `[.precision]`：小数点后的位数（对于浮点数），或者最大字符数（对于字符串）。
- `[length]`：控制数据长度，通常用来控制类型（例如 `l` 表示长整型）。
- `specifier`：数据类型的标识符（如 `%d` 表示整数，`%f` 表示浮动点数，`%s` 表示字符串）。

###### 2. 格式说明符

不同的数据类型有不同的格式说明符。在 C 语言和 Java 中，常见的格式说明符包括：

- **整数**：
  - `%d` 或 `%i`：打印十进制整数（`int` 类型）
  - `%o`：打印八进制整数
  - `%x`：打印十六进制整数（小写字母）
  - `%X`：打印十六进制整数（大写字母）
  
- **浮动点数**：
  - `%f`：打印浮动点数（标准浮动点格式）
  - `%e` 或 `%E`：打印科学计数法格式
  - `%g` 或 `%G`：自动选择 `%f` 或 `%e` 格式，取决于数字的大小和精度

- **字符与字符串**：
  - `%c`：打印单个字符
  - `%s`：打印字符串

- **其他**：
  - `%%`：打印 `%` 字符

###### 3. 格式化标志符

格式化字符串还可以包含一系列标志，来控制输出的方式：

- **对齐**：
  - 默认情况下，数字和字符串是右对齐的。如果想要左对齐，可以使用 `-`：
    - `%-10d`：将整数左对齐，并且宽度为 10 个字符。
  
- **填充字符**：
  - 默认使用空格填充输出，但可以通过指定 `0` 来使用 `0` 填充：
    - `%010d`：输出整数时，宽度为 10 位，不足的地方使用 `0` 填充。
  
- **正负号**：
  - `+`：输出时强制显示正号或负号。例如：
    - `%+d`：即使数字是正数，也会显示正号。
  
- **空格**：
  - 在正数前添加空格，负数前显示负号。例如：
    - `% d`：对于正数前会加空格，负数前会加负号。
  
- **精度**：
  - 精度用于控制小数点后面的位数：
    - `%0.2f`：输出浮动点数时，保留两位小数。
    - `%10.2f`：输出浮动点数时，宽度为 10 位，小数点后保留 2 位，前面会填充空格或 `0`。

###### 4. 示例

######## 基本格式化
```c
##include <stdio.h>

int main() {
    int a = 123;
    float b = 3.14159;
    char c = 'A';
    char str[] = "Hello, World!";

    // 整数
    printf("Integer: %d\n", a); // 输出: Integer: 123

    // 浮动点数
    printf("Float: %.2f\n", b); // 输出: Float: 3.14

    // 字符
    printf("Char: %c\n", c);    // 输出: Char: A

    // 字符串
    printf("String: %s\n", str); // 输出: String: Hello, World!
    
    return 0;
}
```

######## 精度控制
```c
##include <stdio.h>

int main() {
    float b = 3.14159;
    
    // 保留两位小数
    printf("Float with 2 decimals: %.2f\n", b); // 输出: Float with 2 decimals: 3.14
    
    return 0;
}
```

######## 宽度和对齐
```c
##include <stdio.h>

int main() {
    int a = 123;
    
    // 宽度 10，右对齐（默认）
    printf("Right aligned: [%10d]\n", a); // 输出: Right aligned: [       123]
    
    // 宽度 10，左对齐
    printf("Left aligned: [%-10d]\n", a); // 输出: Left aligned: [123       ]
    
    // 宽度 10，填充 0
    printf("Zero-padded: [%010d]\n", a);  // 输出: Zero-padded: [0000000123]
    
    return 0;
}
```

######## 多个变量
```c
##include <stdio.h>

int main() {
    int a = 42;
    float b = 3.1415;
    char c = 'X';

    // 多个变量
    printf("Integer: %d, Float: %.2f, Char: %c\n", a, b, c); 
    // 输出: Integer: 42, Float: 3.14, Char: X

    return 0;
}
```

###### 5. Java 中的 `System.out.printf`

Java 的 `System.out.printf` 基本遵循与 C 语言相同的规则。区别在于：
- 在 Java 中，浮点数默认为 `double`，如果要输出 `float` 类型需要在数值后加 `f`。
- Java 的 `printf` 方法更严格地要求数据类型与格式符号匹配，否则会抛出异常。

######## Java 示例：
```java
public class Main {
    public static void main(String[] args) {
        int a = 123;
        double b = 3.14159;
        char c = 'A';
        String str = "Hello, World!";

        // 整数
        System.out.printf("Integer: %d\n", a); // 输出: Integer: 123

        // 浮动点数
        System.out.printf("Float: %.2f\n", b); // 输出: Float: 3.14

        // 字符
        System.out.printf("Char: %c\n", c);    // 输出: Char: A

        // 字符串
        System.out.printf("String: %s\n", str); // 输出: String: Hello, World!
    }
}
```

###### 6. 总结

格式化输出是一种强大的工具，可以让你以精确和可控的方式展示数据。无论是在 C 语言还是 Java 中，都可以通过格式化字符串来实现对输出的精细控制。掌握格式化输出的基本语法和技巧，可以让你的程序输出更加清晰、整洁、符合预期。
### 
- java定义需要四段 声明  public static int binarySearch(int[] arr,int x){};   public abstract void move();
- interface 和 抽象方法 接口是子集不同的方法 抽象方法是子集中共有的方法  public abstract void f();
- static 静态修饰符 常用于辅助方法和辅助类 与类中的变量无关联 静态(孤立的);  
如 Arrays.sort(int[]) 静态方法不是类的方法是函数
判断需不需要static 就看需不需要外部实例化对象;
- 函数式接口: Consumer<Integer> comsumer ;consumer.accept()接受参数 **并调用函数**
lambda表达式简化函数  (E args)->{sout(args);}
## API
### Arrays类
- Arrays.sort(int [] arr); 将数组arr 升序排列 
- Arrays.binarySearch(int[] arr,int tg); 
### System类
- System.arraycopy() 是 Java 中一个非常常用的用于数组拷贝的静态方法。它的作用是将源数组中的一部分或全部元素复制到目标数组中的指定位置。这个方法是系统级的，因此执行效率比较高。
public static void arraycopy(Object src, int srcPos, Object dest, int destPos, int length)
参数说明：
src：源数组（从这个数组中复制元素）。
srcPos：源数组的起始位置（从该位置开始复制）。
dest：目标数组（将元素复制到这个数组）。
destPos：目标数组的起始位置（复制到目标数组的哪个位置）。
length：要复制的元素个数。
### StringBuilder类
相较于String来说，处理速度更快，所以处理字符串的时候一般使用StringBuilder，最后再通过toString()方法转为字符串
常见的 add  remove  set  get 方法
```java
// 构建一个值为str的可变字符串【也可传空参数】
StringBuilder(String str)
// 返回索引i位置的字符
charAt(int i)
// 返回此字符串的长度
length()
// 在此字符串追加str【参数为StringBuilder也可以】
append(String str)
// 在index处插入字符数组c【c也可以是单个字符或者其他类型】
insert(int index, char[] c)	
// 将char的子数组【下标offset开始，长度len】追加到此字符串
append(char[] str, int offset, int len)	
// 移除此序列从start到end-1的字符串
delete(int start, int end)	
// 移除指定索引上的字符
deleteCharAt(int index)	
// 将指定索引处的字符替换为ch
setCharAt(int index, char ch)	
// 将此字符串反转
reverse()			
// 返回此字符串从start开始至length-1结束的String
substring(int start)		
// 返回此字符串从start开始至end-1结束的String
substring(int start, int end)	
// 返回此序列中的String表示形式
toString()		

// lastIndexOf有类似用法👇
// 返回子字符串第一次出现的索引
indexOf(String str)		
// 同上，从指定位置查找
indexOf(String str, int fromIndex)
```
### Math 类
- Math.min()  
Math.max 同理



# Tips

-  add remove set get
任何数据结构都应该提供增删改查的方法
add 末尾加入 中间插入
remove 索引删除 元素删除
set 索引改元素
get 查 元素 查索引
- 空方法 结束可以直接 return 返回;

# 二分查找
数组升序排列;
设置min max两个索引指针 根据mid 和 target比较进行更新 
两个指针相向收缩
因为 两个指针+-1 最后肯定相等  boundary case是max==min 

```java
public static int ef(int [] arr,int tg) {
		int min=0;int max=arr.length-1;
		while(max!=min) {
			int mid = (max+min)/2;
			if(tg==arr[mid]) {
                max=mid;
                min=mid;
			}else if(tg>arr[mid]) {
				min=mid+1;
			}else {
				max=mid-1;
			}
		}
		if(arr[min]==tg) {
			return min;
		}else {
			return -1;
		}
	}
```

输出最左边的目标值leftMost
```java
public static int ef(int [] arr,int tg) {
		int flag;
		int min=0;int max=arr.length-1;
		while(max!=min) {
			int mid = (max+min)/2;
			if(tg==arr[mid]) {
				flag=mid;
				max=mid;   //注意 是闭区间不需要-1;
			}else if(tg>arr[mid]) {
				min=mid+1;
			}else {
				max=mid-1;
			}
		}
		if(arr[min]==tg) {
			return min;
		}else {
			return -1;
		}
	}
```
最右边的类似;

lefMost 可以在未找到tg时候 返回tg的极限值 如{1,2,3,5}找4返回 索引3
```java
public static int ef(int [] arr,int tg) {
		int flag;
		int min=0;int max=arr.length-1;
		while(max!=min) {
			int mid = (max+min)/2;
			if(tg==arr[mid]) {
				flag=mid;
				max=mid;   //注意 是闭区间不需要-1;
			}else if(tg>arr[mid]) {
				min=mid+1;
			}else {
				max=mid-1;
			}
		}
		return min;
	}
```

java.util.Arrays中的 Arrays.binarySearch(数组,值);

## 优化
1. /2优化改为 >>>1 无符号右移运算防止加起来溢出;
2. mid 取值可以用别的测度代替 如连续测度等
# 复杂度
1. 最差执行情况
2. 每句执行时间相同为1;
## 时间复杂度
大O表示法 O(n) logn O(nlogn) n^2...是f(n)的等价无穷大
二分查找为 O(logn)
## 空间复杂度
内存占用大小

# 数组 
N自然数集->数据的映射(和哈希值相反)
## 空间占用
java中的数组是对象:![alt text](image.png)
## 随机访问
索引查找,时间复杂度O(1);
## 动态数组
java的对象都得是8的整数倍
java自带的叫ArrayList<>
java自带的数组是静态的无法add 

函数式接口: Consumer<Integer> comsumer ;consumer.accept()接受参数 **并调用函数**
lambda表达式简化函数  (E args)->{sout(args);}

System.arraycopy() 是 Java 中一个非常常用的用于数组拷贝的静态方法。它的作用是将源数组中的一部分或全部元素复制到目标数组中的指定位置。这个方法是系统级的，因此执行效率比较高。
public static void arraycopy(Object src, int srcPos, Object dest, int destPos, int length)
参数说明：
src：源数组（从这个数组中复制元素）。
srcPos：源数组的起始位置（从该位置开始复制）。
dest：目标数组（将元素复制到这个数组）。
destPos：目标数组的起始位置（复制到目标数组的哪个位置）。
length：要复制的元素个数。

```java
//框架
public class DynamicArray{
	public int capacity=8;
	public int size;
	int[] arr=new int[capacity];

}
```

``` java
public class DynamicArray{
	private int size=0;  //控制数组实际大小
	private int capacity=8;  //动态扩容
	private int[] array=new int [capacity];

//add 实现
// 末尾插入
	public void addLast(int element){
		checkAndGrow();
		size++;
		array[size]=element;
	}

// 索引插入
	public void add(int index,int element){
		size++;
		if(index>0 && index <size){
		System.arraycopy(array,index,array,index+1,size-index);//size-index 中将index看成前一个元素的右一位个数考虑
		array[index]=element;}
		}else{
   		System.out.println("ERROR");
		}
	array[index]=element;  //合并addList();
}

// 查 get
public int get(int index) {
        return array[index];
    }

// 遍历函数式接口
public void foreach(Consumer<Integer> consumer) {
        for (int i = 0; i < size; i++) {
            // 提供 array[i]
            // 返回 void
            consumer.accept(array[i]);
        }
    }
	
// 迭代器遍历没学懂是java面向对象的内容

// remove 实现
public int remove(int index){
	int removed =array[index];
	System.arraycopy(array,index+1,array,index,size-index-1);
	size--;
	return removed;
}

// set 实现
public int set(int index ,int x){
	array[index]=x;
}

// 扩容
public void checkAndGrow(){
	if(size==capacity){
		capacity+=capacity/2; //java一般扩容1.5倍
	int [] newArray =new int[capacity];
	System.newarraycopy(array,0,newArray,0,size);
	array=newArray;
}}



	


```


## 二维数组
int[][] array=new int[n][m];
矩阵  array[i][j]  i是↓ j是→



# 链表
3(head)->2->1->0->null
单向链表 最后指向null;null<-双向链表->null;循环节点 头尾相连
哨兵节点:null不存数据
注意 boundary case 有头尾 和空指针;
## 性能
随机访问:ingdex查找O(n)
插入删除: 单向头O(1) 尾O(n)  双向头就是尾  中间=查找时间+O(1)
## 代码实现
```java
//框架
public class Node{
	public int value;
	public Node next;
	Node(){};
	Node(int value,Node next){
		this.value=value;
		this.next=next;
	}
}
public class SinglyLinkedList{
	public Node head;
}

}
```
```java
public class SinglyLinkedList{ //用地址(指针)的想法去看待类和对象
	private Node head=null; // 头节点

	private	static class Node{  //内部类
		public int value; // 节点值
		public Node next;// 下一个节点的指针

		public Node(int value,Node next){//构造方法
			this.value =value;
			this.next=next;
		}public Node(){} //空参构造
	}

//add 实现
//头部添加
	public void addFirst(int value){
		if(head==null){
			head=new Node(value,null); // 由null指针从右往左加入head节点;
		}else{
		head=new Node(value,head);}
	}
//尾部添加
	private Node findLast(){
		if(head==null){
			return null;
		}else{
			Node p;
			while(p.next!=null){
				p=p.next;
			}
			return p;
		}
	public void addLast(int value){
		Node last=findLast();
		if(last=null){
			addFirst(value);
		}
		last.next=new Node(value,null);
	}

}

//中间插入
public void add(int index,int x){
	int i=0;Node p=head;
	while(!(p==null || index==0 || i==index-1)){
		p=p.next;
		i++
	}
		if(index==0){
		addFirst(x);
		return;
		}
	   if(p==null){
		sout("error");
		return ;
	}
	temp=new(x,p.next);
	p.next=temp;
}
//get 实现
public Node get(int index){
	int i=0;
	Node p=head;
	while(i!=index){
		p=p.next;
		i++
	}
	return p;
}
// 遍历
	public void loop1(Consumer<Node> consumer){
		Node p  =head;
		while(p!=null){     //函数式接口
			consumer.accept(p);  //accept接受参数并调用;
			p=p.next;
		}
	}
	
// remove 实现
public class SinglyLinkedList {
    // ...
	public void remove(int index) {
        if (index == 0) {
            if (this.head != null) {
                this.head = this.head.next;
                return;
            } else {
                throw illegalIndex(index);
            }
        }
        Node prev = findNode(index - 1);
        Node curr;
        if (prev != null && (curr = prev.next) != null) {
            prev.next = curr.next;
        } else {
            throw illegalIndex(index);
        }
    }
}





}
```
### 单向链表(带哨兵)指的是让一个与数据无关的哨兵当头指针
哨兵->null  基础链表
牛魔的这个head不与数据有关多好艹
```java
public class Node{
	public int value;
	public Node next;

	Node(){}
	Node(int value,Node next){
		this.value=value;
		this.next=next;
	}
}
public class HeadSinglyLinkedList{
	Node head=new Node(int 703,null);

	public void add(int index,int element){

	}
	public void add(int element){
		head.next=new(element,null);
	}
}
```
### 双向链表(带哨兵head)
head <--> tail  基础双向链表

```java
public Node get(int index){
	int i=-1;Node p=head;   // head and tail 哨兵是-1索引
	while(!(i==index || p==tail)){
		i++;p=p.next;
	}
	if(i==index){
		return p;
	}
	if(p==null){
		return null;
	}
}

```

### 环形链表
head->...->head  单向 
head<->...<->head 双向
# 链表题目
## tips
- 防止空指针,例如p3.val p3如果为null则空指针 所以要 p3!=null p.next!=null
- 多指针控制
- 设置哨兵头节点防止error
## 反转链表
- 构造新链表,以此遍历去出旧链表中的元素add进新链表
- 构造新的head->null 遍历旧链表 将每个元素依次add进去
## 删除指定元素
``` java
class Solution {
    public ListNode removeElements(ListNode head, int val) {
        // 创建辅助头节点，指向原链表的头节点
        ListNode h = new ListNode(666, head);
        ListNode p = h;

        // 遍历链表
        while (p.next != null) { // 确保 p.next 不为 null
            if (p.next.val == val) {
                // 如果找到值为 val 的节点，跳过它
                p.next = p.next.next;
            } else {
                // 否则移动到下一个节点
                p = p.next;
            }
        }

        // 返回辅助头节点的 next，作为新的链表头
        return h.next;
    }
}

```
## 删除倒数索引元素
双指针方法
```java
class Solution {
    public ListNode removeNthFromEnd(ListNode head, int n) {
        ListNode h=new ListNode(22,head);
        ListNode p1=h;ListNode p2 =h;
        for(int i=0;i<n;i++){
            p2=p2.next;
        }
        while(!(p2.next==null)){
            p1=p1.next;
            p2=p2.next;
        }
        p1.next=p1.next.next;
        return h.next;
    }
}
```
## 链表去重
```java
class Solution {
    public ListNode deleteDuplicates(ListNode head) {
        // 创建辅助头节点，指向原链表头
        ListNode h = new ListNode(-1, head);
        ListNode p1 = h;

        // 遍历链表
        while (p1.next != null && p1.next.next != null) {
            ListNode p2 = p1.next;       // 当前节点
            ListNode p3 = p2.next;      // 下一个节点

            // 如果当前节点和下一个节点的值相等
            if (p2.val == p3.val) {
                // 找到所有重复的节点
                while (p3.next != null && p3.next.val == p2.val) {
                    p3 = p3.next;
                }
                // 跳过重复的节点
                p1.next = p3.next;
            } else {
                // 如果没有重复，移动指针
                p1 = p1.next;
            }
        }

        // 返回去除重复节点后的链表
        return h.next;
    }
}

```
# 递归
## 反向打印
## 二分查找
```java
public static int binarySearch(int[] arr,int tg,int min,int max){
	min=0;max=arr.length-1;
	// boundary case
	if(min==max){
		return min;
	}

	int mid=(max+min)/2;
	if(tg>arr[mid]){
		return binarySearch(arr,tg,mid+1,max);
	}else if(tg<arr[mid]){
		return binarySearch(arr,tg,min,mid-1);
	}else{
		return binarySearch(arr,tg,min,mid);
	}
}
```
## 冒泡排序
```java
public static void boubbleSort(int[] arr,int n) { //n is update args
	// boundary case
			if(n==1) {
				return;
			}
			int flag=0;
			for(int i=0;i<n-1;i++) {
				if(arr[i]>arr[i+1]) {
					int temp=arr[i];
					arr[i]=arr[i+1];
					arr[i+1]=temp;
					flag=1;
				}
			}
			if(flag==0) {
				return;
			}
			
			boubbleSort(arr,n-1);
		}
```
## 插入排序
```java

```

## 斐波那契递归
```java
	//斐波那契递归
		public static int fabo(int n,int[] memo) {
			if(memo[n]!=-1) {
				return memo[n];
			}
			int x=fabo(n-1,memo);
			int y=fabo(n-2,memo);
			memo[n]=x+y;
			return x+y;
		}
```

## 
# 队列 

# 栈 
 
# 堆

# 二叉树 

# 哈希表
数据的哈希值到N的映射
## 哈希值

```java
public class HashTable{


}
```


# 排序


# 图
概念 vertex edge 度 入度 出度 权 路径 连通图


# 字符串
## String
""+3 == "3"  善用字符串的+运算符;
## StringBuilder
# 字符串题目
## 高精度加法 洛谷P1601
```java
import java.util.Scanner;

public class HighPrecisionAdditionString {

    /**
     * 字符串形式的大数加法
     * @param num1 数字字符串1
     * @param num2 数字字符串2
     * @return 两个大数相加的结果
     */
    public static String add(String num1, String num2) {
        // 创建 StringBuilder 用于存储结果（反向存储）
        StringBuilder result = new StringBuilder();

        int i = num1.length() - 1;
        int j = num2.length() - 1;
        int carry = 0;  // 进位

        // 当两个数字还有未处理的位数或仍然存在进位时，继续计算
        while (!(i<0 && j<0 && carry==0)) {// boundary case 仔细思考这个边界条件  或者改为while(!(i<0 && j<0)) if(carry==1) {sb.append(carry+"")};后边再判断boundary case
			
            int digit1 = i >= 0 ? num1.charAt(i) - '0' : 0;  // 如果没数字则认为是 0
            int digit2 = j >= 0 ? num2.charAt(j) - '0' : 0;  // 如果没数字则认为是 0

            int sum = digit1 + digit2 + carry;
            result.append(sum % 10);  // 取个位，添加到结果中
            carry = sum / 10;         // 计算进位值

            // 移动指针
            i--;
            j--;
        }

        // 由于结果是反向存储的，所以需要反转后返回
        return result.reverse().toString();
    }

}
```

