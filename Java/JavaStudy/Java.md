[TOC]
# ReadMe
与java有关的语法  API 题目等;数据结构 算法具体的知识 与之有关的技巧不写入;
# Java Grammar and API
## Grammar
### 引用数据类型本质是指针
所以 拷贝ArrayList等引用数据类型
得 Object<E> o1 =new Object<E>();
Object<E> o2 =new Object<E>(o1);  构造方法中填入要拷贝的对象
eg.  ArrayList<Integer> arr=new ArrayList<>();
ArrayList<Integer> arr1=new ArrayList<>(arr);
因为指针所以  让arr1=arr仅是让指针指向同一个不是copy;
### 格式化输出
Node \Class\Java\JavaStudy\格式化输出.txt
### static
Node \Class\Java\JavaStudy\static内部类.md
- static 静态修饰符 常用于辅助方法和辅助类 与类中的变量无关联 静态(孤立的);  
如 Arrays.sort(int[]) 静态方法不是类的方法是函数
判断需不需要static 就看需不需要外部实例化对象;
###
- java定义需要四段 声明  public static int binarySearch(int[] arr,int x){};   public abstract void move();
- interface 和 抽象方法 接口是子集不同的方法 抽象方法是子集中共有的方法  public abstract void f();
- 函数式接口: Consumer<Integer> comsumer ;consumer.accept()接受参数 **并调用函数**
lambda表达式简化函数  (E args)->{sout(args);}
- getClass() 获得对象的类int等基本数据类型可以(Object)强制类型转换然后.getClass获得其对应包装类的类型
'9'-'0'是int 类型;
- 
### 作用域
在 Java 中，如果一个变量、方法或类没有显式声明 `public`、`protected` 或 `private`，那么它的默认作用范围是 **包级私有（package-private）**，也称为 **默认访问权限（default access modifier）**。

#### 作用范围划分：
##### 1. **类的作用范围**
   - **类的默认权限**：如果一个类没有显式声明 `public` 或 `private`，那么它是 **包级私有** 的，即 **仅限于同一个包（package）中的类可以访问**。
   - **例子**：
     ```java
     class MyClass {  // 没有 public，作用范围是 package-private
         void sayHello() {
             System.out.println("Hello");
         }
     }
     ```
   - 只有 **相同包中的类** 可以访问 `MyClass`，但其他包的类无法访问它。

##### 2. **变量的作用范围**
   - **实例变量、类变量（成员变量）**
     - 没有显式声明 `public`、`protected` 或 `private` 的变量默认为 **包级私有（package-private）**。
     - 只有 **相同包中的类** 才能访问这些变量，其他包的类无法访问。
   - **示例**：
     ```java
     class Test {
         int x = 10;  // package-private 变量，仅当前包内可访问
     }
     ```

##### 3. **方法的作用范围**
   - **方法的默认权限**
     - 如果方法未声明 `public`、`protected` 或 `private`，则它的访问权限也是 **包级私有**。
     - 仅 **同一包内的类** 可以调用该方法，包外的类无法访问。
   - **示例**：
     ```java
     class Test {
         void display() {  // package-private 方法，仅当前包内可访问
             System.out.println("Hello, World!");
         }
     }
     ```

#### **总结：默认访问权限（package-private）的特点**
| 访问修饰符 | 本类 | 同包类 | 子类 | 其他包 |
|-----------|------|--------|------|--------|
| `public`  | ✅  | ✅  | ✅  | ✅  |
| `protected` | ✅ | ✅ | ✅（即使不在同包中，也可以通过继承访问） | ❌ |
| （默认，不写） | ✅ | ✅ | ❌ | ❌ |
| `private` | ✅ | ❌ | ❌ | ❌ |

##### **package-private（默认权限）适用场景**
- 适用于 **不希望类、变量、方法被外部包访问，但允许在同一个包内使用** 的情况。
- 常用于 **工具类、内部实现逻辑、封装的一部分**，防止不必要的访问。

---

#### **示例代码**
```java
package mypackage;

class DefaultClass { // 作用范围：mypackage 内部可访问
    int value = 100; // package-private 变量
    void show() { // package-private 方法
        System.out.println("Value: " + value);
    }
}
```

```java
package mypackage;

public class Main {
    public static void main(String[] args) {
        DefaultClass obj = new DefaultClass(); // 可以访问
        obj.show(); // 允许访问
        System.out.println(obj.value); // 允许访问
    }
}
```

```java
package otherpackage; // 不同包

import mypackage.DefaultClass;

public class Other {
    public static void main(String[] args) {
        // DefaultClass obj = new DefaultClass(); // ❌ 编译错误，无法访问
        // obj.show(); // ❌ 编译错误
    }
}
```
**在 `otherpackage` 中，`DefaultClass` 是不可见的，无法实例化或调用方法。**

---

#### **结论**
如果在 Java 中不声明 `public`、`protected` 或 `private`：
1. **类的作用范围**：包级私有（只能在同一个包内访问）。
2. **变量的作用范围**：包级私有（同包内的类可以访问）。
3. **方法的作用范围**：包级私有（同包内的类可以调用）。

这样可以控制类的访问权限，使其在 **同一包内可见，包外不可见**，从而提高封装性。
## API
### Arrays类
- Arrays.sort(int [] arr); 将数组arr 升序排列 
- Arrays.binarySearch(int[] arr,int tg); 
### Collections
##### Collections.sort
Collections.sort(Collectiong arr , new Comparator(){@Override public int compare(Object o1,Object o2){}});
重写比较方法 参数为arr中的相邻两元素 1 是交换 -1是不交换;

### BigInteger
用eclipse自带的现场学
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
## 环形数组
tail指针是sentry哨兵指针
![alt text](image-6.png)
# 栈 
top指针是sentry指针;
# 堆
找父节点 (i-1)>>1 
找子节点 2i+1 2i+2
最后一个非叶节点 size/2-1;
# 二叉树 

# 哈希表
数据的哈希值到N的映射
## 哈希值

```java
public class HashTable{


}
```


# 图
概念 vertex edge 度 入度 出度 权 路径 连通图
- 图的表示 :
1. 邻接矩阵
   A B C D
A  0 1 1 0
B  1 0 0 1
C  1 0 0 1
D  0 1 1 0
2. 邻接表
A->B ->C
B ->A ->D
C->A ->D
D->B ->C
## java类
```java
//图节点
public class Vertex {
		public String name;
		public ArrayList<Edge> edges=new ArrayList<Edge>
		();//边集合
		public boolean visited=false;
		public Vertex() {}

		public Vertex(String name) {
			super();
			this.name = name;
		}
		
		
}
//图的边
public class Edge {	
		public int weight;
		public Vertex Linked; //指向那个节点
		
		public Edge() {}

		public Edge(int weight, Vertex linked) {
			super();
			this.weight = weight;
			Linked = linked;
		}
		
		
		

}
```
## dfs
```java
public static void dfs(Vertex v) {
    // boundary case：如果传入的顶点为 null 或者已经访问过，则直接返回
    if (v == null || v.visited) {
        return;
    }
    
    // 标记当前顶点为已访问
    v.visited = true;
    System.out.println(v.name);
    
    // 遍历所有相邻的顶点，并递归调用dfs
    for (int i = 0; i < v.edges.size(); i++) {						//和全排列的决策树,快速排序的左右部分类似  多分支用for循环每个循环以i为基准看作单分支进行递归编写
        dfs(v.edges.get(i).linked);
    }
}
//dfs算法
    public static void dfs(ArrayList<Vertex> dfsArr,Vertex v){
        if(v==null || v.visited==true){
            return ;
        }

        dfsArr.add(v);								// 考虑是否需要回溯通过if逻辑判断
        v.visited=true;								//这里 else严格限制 仅是没被遍历到的add进数组所以不用回溯;
        for(Edge e:v.arr){
            dfs(dfsArr,e.linked);
        }

    }

```


# 字符串
## 输入
next系列和scanf 一样无法处理空格 按照流进行处理;
常用BufferedReader输入
```java
BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
			StringBuilder sb=new StringBuilder();
			String line ;
			while(true) {
				line =reader.readLine();
				if (line==null) {
					break;
				}
				sb.append(line);
			}
```
## String
""+3 == "3"  善用字符串的+运算符;  ((char)42)+""+1  思考 ((char)42)+1+""的区别
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





# 算法思想
- Divide and Conquer 
- Dynamic Programming
- Greedy
- Backtracking
- Search
- 枚举
- 
# 模拟
# 模拟题目
## P1042
```java
import java.util.*;
import java.math.*;
import java.lang.*;
import java.io.*;
public class Main {
	    //主方法
		public static void main(String[] args) throws IOException {
			BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
			StringBuilder sb=new StringBuilder();
			String line ;
			while(true) {
				line =reader.readLine();
				if (line==null) {
					break;
				}
				sb.append(line);
			}
			
			ArrayList<Integer> arr=new ArrayList<Integer>();
			for(int i=0;i<sb.length();i++) {
				if(sb.charAt(i)=='E') {
					break;
				}
				if(sb.charAt(i)!='W' && sb.charAt(i)!='L') {
					continue;
				}
				if(sb.charAt(i)=='W') {
					arr.add(1);
				}else {
					arr.add(0);
				}
				
			}
			int w=0;int l=0;
			for(int i=0;i<arr.size();i++) {
				if(arr.get(i)==1) {
					w++;
				}else {                                                    //注意这的boundary case 逻辑关系再w++之后;
					l++;
				}
				if(Math.max(w, l)>=11 && Math.abs(w-l)>=2) {
					System.out.println(w+":"+l);
					w=0;l=0;
				}
				
				
			}
			System.out.println(w+":"+l);
			System.out.println("");
			for(int i=0;i<arr.size();i++) {
					if(arr.get(i)==1) {
					w++;
				}else {
					l++;
				}
				if(Math.max(w, l)>=21 && Math.abs(w-l)>=2) {
					System.out.println(w+":"+l);
					w=0;l=0;
				}
			
				
			}
			System.out.println(w+":"+l);
			return;
		}}
```




# 排序
## 计数排序
构造n的数组 数组下标就是计数;然后按照计数将数组下标展开;
![alt text](image-2.png)
```c
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<math.h>
int main(){
	int n=0,m=0,arr[1001]={0};
	scanf("%d %d",&n,&m);
	int temp=0;
	for(int i=0;i<m;i++){
		scanf("%d",&temp);
		arr[temp]++;
	}
	for(int i=1;i<=n;i++){
		for(int j=0;j<arr[i];j++){
			printf("%d ",i);
		}
	}
	
}
```
## 简单比较排序
### 选择排序(数组顺序排序)
按照索引每次选择最小的
![alt text](image-3.png)
### 冒泡排序

### 插入排序
记住插入排序元素怎么移动的
```java
int [] arr= {4,3,2,1};
			for(int i=1;i<4;i++) {
				int flag=arr[i];int j=i-1;
				while(true) {
					if(j<0 || arr[j]<=flag) {
						break;
					}
					arr[j+1]=arr[j];
					j--;
				}
				arr[j+1]=flag;
				
			}

```
## 快速排序
[Node \Class\Java\JavaStudy\Java 快速排序及优化策略.md](https://github.com/GodBlf/Class/blob/main/Java/JavaStudy/Java%20%E5%BF%AB%E9%80%9F%E6%8E%92%E5%BA%8F%E5%8F%8A%E4%BC%98%E5%8C%96%E7%AD%96%E7%95%A5.md)

双指针进行分治
```java
int i=0;
for(int j=0;j<right-1;j++){
	if(arr[j]<pivot){
		int temp=arr[i];
		arr[i]=arr[j];
		arr[j]=temp;
		i++               //i指针是pivot 左边都是<pivot的
	}
}
int temp=arr[i];
arr[i]=pivot;
arr[right]=temp;//   最后再把pivot换到i处;


```

## Arrays.sort  和  Collections.sort
Arrays.sort(arrays , new Comparator<Student>(){@Override public int compare(Student s1,Student s2){}})  对数组排序
Collectiongs(list, new Comparator<Student>(){@Override public int compare(Student s1,Student s2){}}) 	对动态数组排序
Node  \Class\Java\JavaStudy\生日排序算法实现.md


# 枚举
- 枚举经典题目数正方形还是长方形 按照边长枚举 每次枚举  是上边滑动到底和下边滑动到底的乘积;
```java
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        // 注意：题目给的是棋盘的行数和列数，即单元格数。
        // 若输入为 n, m，则棋盘有 n 行 m 列，对应的横线数为 n+1，竖线数为 m+1。
        int a = sc.nextInt();
        int b = sc.nextInt();
        sc.close();
        int n = a + 1; // 横线数
        int m = b + 1; // 竖线数

        long squareCount = 0;    // 正方形总数
        long nonSquareCount = 0; // 长方形（非正方形）的总数

        // 枚举横向距离 d（行差）和竖向距离 w（列差）
        for (int d = 1; d < n; d++) {
            for (int w = 1; w < m; w++) {
                long count = (long)(n - d) * (m - w);
                if (d == w) {
                    squareCount += count;
                } else {
                    nonSquareCount += count;
                }
            }
        }
        System.out.println(squareCount + " " + nonSquareCount);
    }
}

```
## 子集枚举
![alt text](image-7.png)
用2进制表示n个元素的集合中元素存在状态 从0000 到 1111 共有2^n个元素  1<<n;
第i个元素元素可表示为  1<<i  
交集 : &
并集: |
补集: ((1<<n)-1) ^ 
包含: (|)&&(&)
判断第j位是否有元素 i&(1<<j)!=0;
## 排列枚举
递归生成决策树
```java

public static void dfs(String str,ArrayList<Integer> arr) {
    	if(arr.size()==0) {
    		System.out.println(str);
    	}
    	
    	for(int i=0;i<arr.size();i++) {
    		int temp=arr.get(i);
    		ArrayList<Integer> newArr=new ArrayList<Integer>(arr);
    		newArr.remove(i);
    		dfs(str+temp,newArr);    // 用副本的方式实现回溯
    		
    	}
    	
    }
//更能表达递归回溯的是
public static void dfs(String str,ArrayList<Integer> arr) {
    	if(arr.size()==0) {
    		System.out.println(str);
    	}
    	
    	for(int i=0;i<arr.size();i++) {
    		int temp=arr.get(i);
    		arr.remove(i);
    		
    		str=str+temp;
    		dfs(str,arr);
    		// 因为子问题的状态是指针 要保持子问题的状态一致所以要回溯
			
			//回溯到原来的状态,为什么可以;因为把递归里的 dfs() 看作 {{{{{return}}}}}  在最外层remov(i) 再 add(i) 相当于每个栈归时都能-1+1 回到原来状态;
     		StringBuilder sb=new StringBuilder(str);
    		sb.deleteCharAt(sb.length()-1);
    		str=sb.toString();    
    		arr.add(i,temp);
    	}
    	
    }

```



# 递归
## 递归树
## 多路递归构造和memo优化
```java

import java.util.Arrays;

public class Main1 {

    public static void main(String[] args) {
        int n=4;
        int[] cache=new int[n+1] ;
        Arrays.fill(cache,-1);
        cache[0] =1;cache[1]=1;
        System.out.println(f(n,cache));
    }
    public static int  f(int n,int[] cache){
        if(cache[n] != -1){                   			//如果节点在数组里已经记录则它是叶子节点
            return cache[n];
        }
        int x=f(n-1,cache);
        int y=f(n-2,cache);
        cache[n]=x+y;
        return cache[n];								// 仅代表返回时候携带的值 对递归树无额外贡献;

    }

}


```

# 数论
## 进制转换 
小技巧 将二进制拆分成4个一组不够的补零    1111 1111  就是十六进制的FF
例如 2 -> 8;
- to 10 从0开始遍历 sum=sum*original + temp  而不是从个位开始遍历,
![alt text](image-4.png)
也可以按照公式进行遍历
- 10 to  先判断0  然后再用while if 不断mod boundary case是x==0;
```java
public class Main {
	    //主方法
	public static void main(String[] args) {
			Scanner sc=new Scanner(System.in);
			//主方法开始
			
			//构造映射列表
			char [] list = new char[16];
			for(int i=0;i<10;i++) {
				list[i]=(char)('0'+i);
			}
			for(int i=10;i<16;i++) {
				list[i]=(char)('A'+i-10);
			}
			int original =sc.nextInt();
			String x=sc.next();
			int tg=sc.nextInt();
			System.out.println(ten2Tg(original2Ten(x, original),tg,list));
			
			//主方法结束
		}
	public static int original2Ten(String x, int original) {
	    if (x.equals("0")) { 																	//注意// 字符串比较需要用 equals
	        return 0;
	    }

	    int sum = 0;
	    for (int i = 0; i < x.length(); i++) { 												// 注意从零开始遍历才是正确转换到10进制
	        char c = x.charAt(i);
	        int temp;

	        if (c >= '0' && c <= '9') {
	            temp = c - '0'; // 处理 0-9
	        } else if (c >= 'A' && c <= 'Z') {
	            temp = c - 'A' + 10; // 处理 A-Z
	        } else if (c >= 'a' && c <= 'z') {
	            temp = c - 'a' + 10; // 处理 a-z（可选，看需求）
	        } else {
	            throw new IllegalArgumentException("Invalid character in number: " + c);
	        }

	        if (temp >= original) { // 确保字符值在合法进制范围内
	            throw new IllegalArgumentException("Digit out of range for base " + original + ": " + c);
	        }

	        sum = sum * original + temp; // 累加计算
	    }
	    return sum;
	}


		
		
		//十进制转换目标进制;
		public static String ten2Tg(int x,int tg,char[] list) {
			
			StringBuilder sb=new StringBuilder();
			if(x==0) {																						//注意判断边界条件0;
				return "0";
			}
			while(true) {
				if(x==0) {
					break;
				}
				sb.append(list[x%tg]+"");
				x=x/tg;
			}
			return sb.reverse().toString();
		}
```
### 小数进制转换
![alt text](image-5.png)

## 2进制讨论(补码)
计算机擅长加法  所以 0-000 是0开头的0代表正号
1-111是-1 开头的1代表负号 然后考虑计算机擅长加法所以 1111+1=0000 所以1111是-1
然后1000->1111,0000,-> 0111  排列起来就是所有能表示的 +-2^3 这些数;

## 位运算
& | ^ ~  <<  >>  >>>
&: 相当于乘法  1&0=0 1&1=1 0&0=0;
|: 相当于加法  1|0=1 1|1=10(1) 0|0=0;
所以例如取出某二进制数的后16位  n&0xFFFF
### 应用
- <<n  二进制表示右移n位;相当于乘了2^n;
- >>n  二进制表示左移n位,相当于整除了2^n;
-a=(~ a+1)
检查奇偶性：使用 a & 1 来检查一个整数是否为奇数（如果结果为 1，则为奇数）。
交换两个数：可以通过 XOR 运算交换两个数的值，例如：
java
Copy code
int a = 5, b = 3;
a = a ^ b;
b = a ^ b;
a = a ^ b;
计算最大公约数：使用位运算可以高效地计算两个数的最大公约数。
位运算的性能很高，因为它们直接操作硬件级别的二进制位，不需要复杂的计算。
## 整除
(a+b+c)%d=(((a+b)%d)+c)%d  *乘法类似






