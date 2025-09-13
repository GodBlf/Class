[TOC]

# json格式导论
- 每一部分开头写一个json来作为导论
- "重要内容":"辅助记忆的内容"//注释
- 辅助记忆的内容可以是符号 英文单词 或者自己造的专有名词例如Skills里的很多内容
(自己造专有名词/skills里的>符号>英文单词)注释可以随便修饰
- 目的就是轻量化记忆起到导论的作用总结重点,可以有的没有,不可以有的坚决没有
- mermaid 辅助记忆
- 模板:直接copy
## skills导论设计参考
- 参考自数学的ZFC公理体系集合论
- 通过集合可以构造出代数分析体系
- skills对应集合论公理定理 json对应如何组合公理定理方便记忆

# 理论这一块
## 时间复杂度
- 常数时间O(1)
和数据量无关,固定时间的操纵,PS:常数时间和数据量无关但也可能非常大大于O(n^2)等
数组,hashset...
- 无穷大量(无穷小量)
数据量N 操作次数为f(N) O(f(N)) 
例如 O(N^2)=2N^2+N+3;
- 非随机行为用最差情况估计
随机行为用期望情况,因为最差情况非常差
- 调和级数
1+1/2+...+1/n 用1/x的积分计算为ln(n) 所以为O(logN)




## 数据结构
- 所有数据结构底层都是连续结构(数组),跳转结构(指针链表)拼出来的
- 底层(连续,跳转)->理论(线性表,哈希表,树,图)

# 对数器
```json


```
- 单元测试
- 和暴力解对拍
- 打表找规律

# io优化
## 一般string int读入
```java
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        PrintWriter out=new PrintWriter(new OutputStreamWriter(System.out));
        StreamTokenizer st=new StreamTokenizer(reader);
//st首指针在-1
while (st.nextToken() != StreamTokenizer.TT_EOF) { // 文件没有结束就继续 EOF=-1
			// n，二维数组的行
			int n = (int) st.nval;
			st.nextToken();
			// m，二维数组的列
			int m = (int) st.nval;
			out.println(maxSumSubmatrix(mat, n, m));
		}
```
## 读一行
```java
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        PrintWriter out=new PrintWriter(new OutputStreamWriter(System.out));
        StringTokenizer st=new StringTokenizer("");
        st=new StringTokenizer(reader.readLine());
```

## 全局静态空间
```java
public class Code03_StaticSpace {

	// 题目给定的行的最大数据量
	public static int MAXN = 201;

	// 题目给定的列的最大数据量
	public static int MAXM = 201;

	// 申请这么大的矩阵空间，一定够用了
	// 静态的空间，不停复用
	public static int[][] mat = new int[MAXN][MAXM];

	// 需要的所有辅助空间也提前生成
	// 静态的空间，不停复用
	public static int[] arr = new int[MAXM];

	// 当前测试数据行的数量是n
	// 当前测试数据列的数量是m
	// 这两个变量可以把代码运行的边界规定下来
	public static int n, m;

	public static void main(String[] args) throws IOException {
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		StreamTokenizer in = new StreamTokenizer(br);
		PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
		while (in.nextToken() != StreamTokenizer.TT_EOF) {
			n = (int) in.nval;
			in.nextToken();
			m = (int) in.nval;
			for (int i = 0; i < n; i++) {
				for (int j = 0; j < m; j++) {
					in.nextToken();
					mat[i][j] = (int) in.nval;
				}
			}
			out.println(maxSumSubmatrix());
		}
		out.flush();
		br.close();
		out.close();
	}

	// 求子矩阵的最大累加和，后面的课会讲
	public static int maxSumSubmatrix() {
		int max = Integer.MIN_VALUE;
		for (int i = 0; i < n; i++) {
			// 因为之前的过程可能用过辅助数组
			// 为了让之前结果不干扰到这次运行，需要自己清空辅助数组需要用到的部分
			Arrays.fill(arr, 0, m, 0);
			for (int j = i; j < n; j++) {
				for (int k = 0; k < m; k++) {
					arr[k] += mat[j][k];
				}
				max = Math.max(max, maxSumSubarray());
			}
		}
		return max;
	}

	// 求子数组的最大累加和，后面的课会讲
	public static int maxSumSubarray() {
		int max = Integer.MIN_VALUE;
		int cur = 0;
		for (int i = 0; i < m; i++) {
			cur += arr[i];
			max = Math.max(max, cur);
			cur = cur < 0 ? 0 : cur;
		}
		return max;
	}

}

```


# 二分
```json 
{   
    "红蓝区域法":null,
    "单调区间":null,
    "红蓝边界":null,
    "划分指针":"partition_pointer"// in Skills
}
```
- 时间复杂度:log(N) 
log(2^32)=32 所以二分非常快

## 红蓝区域法
- BV1d54y1q7k7
### 单调区间
区间满足单调性,区间中x∈red左侧都∈red,x∈blue右侧都∈blue;                  
### 红蓝边界
设置边界,将区间划分为red,blue两个区间
### 划分指针
- red指针初始在-1,blue指针初始在n,red指针左侧是red区域,blue指针右侧是blue区域;
- 取中间值x,若x∈red,red指针扩充到x,若x∈blue...;直到red+1==blue结束循环

![alt text](image.png)![alt text](image-3.png)![alt text](image-2.png)

## 二分峰值
```json
{
    "数组离散函数":"discrete_function",
    "导函数介值定理":null,//达布定理Darboux's theorem
    "划分指针":"partition_pointer"//特殊的划分(l,r)必有峰值
}
```
- [二分峰值leetcode](https://leetcode.cn/problems/find-peak-element/)
- 数组就是离散的函数;导函数介值定理;导数相乘<0 中间必有极值点
- 划分指针划分按必有峰值划分,可理解为l左侧必没有r右侧必没有
```java
class Solution {
    public int findPeakElement(int[] arr) {
        int n = arr.length;
        //特判
        if (arr.length == 1) {
            return 0;
        }
        if (arr[0] > arr[1]) {
            return 0;
        }
        if (arr[n - 1] > arr[n - 2]) {
            return n - 1;
        }
        //划分闭区间指针 (l,r)区间必有峰值可理解为l左侧必没有r右侧必没有
        int l=0;int r=n-1;int m=0;int ans=0;
        while(l+1!=r){
            m=(l+r)>>1;
            //左导数<0所以(l,m)必有极值点r扩充到m
            if(arr[m]<arr[m-1]){
                r=m;
            }else if(arr[m+1]>arr[m]){  //右导数>0所以(m,r)必有极值点l扩充的m
                l=m;
            }else{
                ans=m;
                break;
            }
        }
        return ans;
    }
}
```

## 二分答案
- 单调区间
1）估计 最终答案可能的范围 是什么，可以定的粗略，反正二分不了几次
2）分析 问题的答案 和 给定条件 之间的 单调性，大部分时候只需要用到 自然智慧
- 二分边界
3）建立一个f函数，当答案固定的情况下，判断 给定的条件是否达标
- 划分指针
4）在 最终答案可能的范围上不断二分搜索，每次用judge函数判断，直到二分结束，找到最合适的答案
### 习题
#### [爱吃香蕉的珂珂leetcode](https://leetcode.cn/problems/koko-eating-bananas/)
- 单调区间
速度区间 (0,piles.max]
- 二分边界
在h时间内不能吃完 | 在h时间内能吃完
- 向上取整 a+b-1/b
```java
class Solution {
    public int minEatingSpeed(int[] piles, int h) {
        int max=0;
        for (int i = 0; i < piles.length; i++) {
            max=Math.max(max,piles[i]);
        }
        int l=0;int r=max+1;
        while(l+1!=r){
            int m=(l+r)>>1;
            if(panduan(m,h,piles)){
                r=m;
            }else{
                l=m;
            }
        }
        return r;
    }
    //判断能不能吃完
    static boolean panduan(int v,int h,int[] piles){
        long ansh=0;
        for (int i = 0; i < piles.length; i++) {
            //数论微小量1向上取整
            ansh+=(piles[i]+v-1)/v;
            if(ansh>h){
                return false;
            }
        }
        return true;
    }
}
```

#### [画匠问题leetcode](https://leetcode.cn/problems/split-array-largest-sum/)
- flag nobacktracking_pointer
- 单调区间
[0,nums.sum],从0到累加和
- 二分区间
能分>k个区间 | 能分<=k个区间
```java
class Solution {
    public int splitArray(int[] nums, int k) {
            int right=0;int left=-1;int m=0;
            for(int i=0;i<nums.length;i++){
                right+=nums[i];
            }
            right++;
            while(left+1!=right){
                m=(left+right)>>1;
                if(judge(nums,k,m)){
                    right=m;
                }else{
                    left=m;
                }
            }
            return right;
    }
    public static boolean judge(int[]nums,int k,int val){
        //指针模拟状态遍历,那么指到哪里就立即更新他的状态
        //初始已经有一个油桶了
        //flag
        int partition=1;
        int sum=0;
        for(int i=0;i<nums.length;i++){
            //单值大于val直接不用分了
            if(nums[i]>val) return false;
            sum+=nums[i];
            //大于就重开一个油桶
            if(sum>val){
                partition++;
                sum=nums[i];
                continue;
            }
        }
        return partition<=k;
    }
}
```

#### [机器人跳跃nowcoder](https://www.nowcoder.com/practice/7037a3d57bbd4336856b8e16a9cafd71)
- 溢出剪枝 prune
```java
public class Main{
    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        PrintWriter out=new PrintWriter(new OutputStreamWriter(System.out));
        StringTokenizer st=new StringTokenizer("");
        //
        int n=0;
        n=Integer.parseInt(reader.readLine());
        st=new StringTokenizer(reader.readLine());
        int max=0;int[] arr=new int[n+1];
        arr[0]=0;
        for(int i=1;i<n+1;i++){
            arr[i]=Integer.parseInt(st.nextToken());
            max=Math.max(arr[i],max);
        }
        int left=-1;int right=max+1;int m=0;
        while(left+1!=right){
            m=(left+right)>>1;
            if(judge(arr,max,m)){
                right=m;
            }else{
                left=m;
            }
        }
        out.println(right);

        //
        out.close();
        reader.close();
    }
    public static boolean judge(int[] arr,int max,int e){
        for(int i=1;i<arr.length;i++){
            if(e>arr[i]){
                e+=e-arr[i];
            }else{
                e-=arr[i]-e;
            }
            if(e<0) return false;
            //找个例子会发现增加的值是2等比数列会溢出所以剪枝超过max必然能过
            if(e>=max) return true;
        }
        return true;
    }
}
```

#### []()


---

# =================================================================== 1

# 基础数据结构
- 所有数据结构底层都是连续结构(数组),跳转结构(指针链表)拼出来的
- 底层(连续,跳转)->理论(线性表,哈希表,树,图)
- 基础数据结构以0初始索引
- 高级数据结构以1初始索引
- 根据ordinal_cardinal,树的深度是root延申的数量,高度是叶子节点眼神到root的数量

# 线性表
- ArrayList slice 记得能remove

# 链表
```json
{
    "链表构造模型":"sentry memo_pointer container.new_container",//memo_pointer记忆尾节点
    "指针技巧":"memo_pointer no-backtracking_pointer",
    "快慢指针":"no-backtracking_pointer"
}
```
## 函数参数
- 函数参数是将变量拷贝副本传递到函数,指针也是变量,指针副本指向同一块内存区域
## 链表模型
![alt text](image-4.png)
- sentry节点
设置哨兵节点指向链表头节点方便插入 newNode.next=sentry.next;sentry.next=newNode;

- memo指针
指向链表的尾节点实现正序插入,记忆尾节点,也是memo指针的一种

- no-backtracking指针
## 习题
### [链表反转leetcode](https://leetcode.cn/problems/reverse-linked-list/)
```java
class Solution {
    public ListNode reverseList(ListNode head) {
        if(head==null){
            return null;
        }
        //设置两个哨兵节点
        ListNode sentryHead=new ListNode();
        sentryHead.next=head;
        ListNode sentryAns=new ListNode();
        sentryAns.next=null;
        //设置memo指针
        ListNode p=head;
        while(p!=null){
            p=p.next;
            sentryHead.next.next=sentryAns.next;
            sentryAns.next=sentryHead.next;
            sentryHead.next=p;
        }
        return sentryAns.next;
    }
}
```

### [链表分组反转](https://leetcode.cn/problems/reverse-nodes-in-k-group/)
```json
{   
    "链表模型容器":"sentry memo_pointer flag",//用一个flag变量标记memo指向容器的最后一个元素方便sentry转移
    "很多个指针":"memo_pointer"
}
```
```java
public class Solution {
    public ListNode reverseKGroup(ListNode head, int k) {
        ListNode sentry = new ListNode(666);
        ListNode ans=sentry;
        ListNode prev=sentry;
        ListNode p=head;
        ListNode pmemo=head;
        ListNode p1=head;
        loop:
        while(true){
            for(int i=1;i<=k;i++){
                if(p1==null){
                    break loop;
                }
                p1=p1.next;
            }
            int flag=1;
            while (p!=p1){
                pmemo=p.next;
                p.next=sentry.next;
                sentry.next=p;
                p=pmemo;
                //flag标记代表第一次操作的状态
                //state filter 第一次操作时执行并状态改变
                if(flag==1){
                    prev=sentry.next;
                    //状态改变不再是第一次
                    flag=2;
                }

            }
            sentry=prev;
        }
        prev.next=p;
        return ans.next;

    }
}
```

### [合并有序链表leetcode](https://leetcode.cn/problems/merge-two-sorted-lists/)
好想的newContainer方法优化为在原链表模拟newContainer;
- 构造一个新的链表容器然后将节点逐一比较插入
- nobacktracking_pointer memo_pointer
```java
public static ListNode mergeTwoLists(ListNode head1, ListNode head2) {
			if (head1 == null || head2 == null) {
				return head1 == null ? head2 : head1;
			}
            ListNode head=null;
            //两个不回退指针
            ListNode cur1=null;
            ListNode cur2=null;
            if(head1.val<=head2.val){
                head=head1;
                cur1=head.next;
                cur2=head2;
            }else{
                head=head2;
                cur1=head.next;
                cur2=head1;
            }
            //设置pre 记忆指针memo
			ListNode pre = head;
			while (cur1 != null && cur2 != null) {
				if (cur1.val <= cur2.val) {
					pre.next = cur1;
					cur1 = cur1.next;
				} else {
					pre.next = cur2;
					cur2 = cur2.next;
				}
				pre = pre.next;
			}
			if(cur1!=null){
				pre.next=cur1;
			}
			if(cur2!=null){
				pre.next=cur2;
			}
			return head;
		}
```

### [链表相加leetcode](https://leetcode.cn/problems/add-two-numbers)
```java
class Solution {
    public ListNode addTwoNumbers(ListNode l1, ListNode l2) {
        int carry=0;int tmp=0;
        ListNode sentry=new ListNode();
        sentry.next=null;
        ListNode pre=new ListNode();
        pre=sentry;
        ListNode p1=l1;
        ListNode p2=l2;
        while(p1!=null || p2!=null){
            if (p1!=null && p2!=null) {
                tmp=p1.val+p2.val+carry;
                carry=tmp/10;
                tmp=tmp%10;
                pre.next=new ListNode(tmp);
                pre=pre.next;
                p1=p1.next;
                p2=p2.next;
            }
            else if(p1==null && p2!=null){
                tmp=0+p2.val+carry;
                carry=tmp/10;
                tmp=tmp%10;
                pre.next=new ListNode(tmp);
                pre=pre.next;
                p2=p2.next;
            }
            else if(p2==null && p1!=null){
                tmp=p1.val+0+carry;
                carry=tmp/10;
                tmp=tmp%10;
                pre.next=new ListNode(tmp);
                pre=pre.next;
                p1=p1.next;
            }
            //也可以改成state_filter形式 if()...continue

        }
        if(carry!=0){
            pre.next=new ListNode(carry);
            pre=pre.next;
        }
        pre.next=null;
        return sentry.next;

    }
}
```

### [划分链表leetcode](https://leetcode.cn/problems/partition-list/)
- sentry_node memo_pointer new_container
```java
class Solution {
    public ListNode partition(ListNode head, int x) {
        ListNode xiaoSentry = new ListNode(300);
        ListNode daSentry = new ListNode(300);
        //设置两个记忆指针记忆两个新链表的尾节点
        ListNode xiaoPre=xiaoSentry;
        ListNode daPre=daSentry;
        ListNode p=head;
        //记忆指针记忆p的下一个位置
        ListNode memo=head;
        while(p!=null){
            memo=p.next;
            if(p.val<x){
                xiaoPre.next=p;
                xiaoPre=p;
                p.next=null;
            }else{
                daPre.next=p;
                daPre=p;
                p.next=null;
            }
            p=memo;
        }
        if(xiaoSentry.next==null){
            return daSentry.next;
        }
        if(daSentry.next==null){
            return xiaoSentry.next;
        }
        xiaoPre.next=daSentry.next;
        return xiaoSentry.next;
    }
}
```

### [复制随机指针链表](https://leetcode.cn/problems/copy-list-with-random-pointer/)
- memo指针,container在原结构构建容器
- 把新节点和旧节点串起来,起到容器的作用,然后再遍历构造新节点的random最后再用memo指针分离开新旧节点
```java
class Solution {
    public Node copyRandomList(Node head) {
        if(head==null) return null;
        Node sentry=head;
        Node p=head;
        Node prev=head;
        //新旧节点串起来 1,1',2,2',3,3',...,null
        while(p!=null){
            prev=p.next;
            Node tmp = new Node(p.val);
            tmp.next=prev;
            p.next=tmp;
            p=prev;
        }
        //构建新节点random信息
        p=sentry;
        while(p!=null){
            //注意boundary可能为null
            if(p.random==null){
                p.next.random=null;
            }else{
                p.next.random=p.random.next;
            }
            p=p.next.next;
        }
        Node sentry1=sentry.next;
        p=sentry;Node memo;
        //分离新旧节点
        while(p.next.next!=null){
            prev=p.next.next;
            memo=p.next;
            memo.next=prev.next;
            p.next=prev;
            p=prev;
        }
        p.next=null;
        return sentry1;


    }
}
```

### [链表中点](https://leetcode.cn/problems/middle-of-the-linked-list/)
- 快慢指针简简单单的
```java
class Solution {
    public ListNode middleNode(ListNode head) {
        ListNode f=head;
        ListNode s=head;
        if(f.next==null) return f;
        if(f.next.next==null) return f.next;
        while(true){
            s=s.next;
            f=f.next.next;
            if(f.next==null) return s;
            if(f.next.next==null) return s.next;
        }
    }
}
```

### [判断链表是不是回文](https://leetcode.cn/problems/palindrome-linked-list/)
- 快慢指针寻找中点然后,将右部分反转左右对比;
- 用额外空间的是将节点值存入数组然后不回退双指针遍历即可简简单单的
```json
{
    "寻找中点":"fast-slow_pointer",
    "反转右部分":"container"//链表模型
}
```
```java

 class Solution {
     public boolean isPalindrome(ListNode head) {
        ListNode s=head;
        ListNode f=head;
        while(f.next!=null && f.next.next!=null){
            s=s.next;
            f=f.next.next;
        }
        ListNode sentry=new ListNode(666);
        ListNode p=s.next;
        ListNode prev=p;
        while(p!=null){
            prev=p.next;
            p.next=sentry.next;
            sentry.next=p;
            p=prev;
        }
        p=sentry.next;
        while(p!=null){
            if(p.val!=head.val){
                return false;
            }
            p=p.next;
            head=head.next;
        }
        return true;

     }
 }
```

### [链表排序](https://leetcode.cn/problems/sort-list)
- 好麻烦目前除了作甚的有递归做法
```java
class Solution {
    public ListNode sortList(ListNode head) {
        return sortList(head, null);
    }

    public ListNode sortList(ListNode head, ListNode tail) {
        if (head == null) {
            return head;
        }
        if (head.next == tail) {
            head.next = null;
            return head;
        }
        ListNode slow = head, fast = head;
        while (fast != tail) {
            slow = slow.next;
            fast = fast.next;
            if (fast != tail) {
                fast = fast.next;
            }
        }
        ListNode mid = slow;
        ListNode list1 = sortList(head, mid);
        ListNode list2 = sortList(mid, tail);
        ListNode sorted = merge(list1, list2);
        return sorted;
    }

    public ListNode merge(ListNode head1, ListNode head2) {
        ListNode dummyHead = new ListNode(0);
        ListNode temp = dummyHead, temp1 = head1, temp2 = head2;
        while (temp1 != null && temp2 != null) {
            if (temp1.val <= temp2.val) {
                temp.next = temp1;
                temp1 = temp1.next;
            } else {
                temp.next = temp2;
                temp2 = temp2.next;
            }
            temp = temp.next;
        }
        if (temp1 != null) {
            temp.next = temp1;
        } else if (temp2 != null) {
            temp.next = temp2;
        }
        return dummyHead.next;
    }
}

作者：力扣官方题解
链接：https://leetcode.cn/problems/sort-list/solutions/492301/pai-xu-lian-biao-by-leetcode-solution/
来源：力扣（LeetCode）
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
```

### [删除倒数第n个节点leetcode](https://leetcode.cn/problems/remove-nth-node-from-end-of-list/)
```json
{
    "距离快慢指针":"fast-slow_pointer"
}
```
- 快慢指针 no-backtracking_pointer 设置不回退指针的距离差
```java
class Solution {
    public ListNode removeNthFromEnd(ListNode head, int n) {
        ListNode sentry = new ListNode(666);
        sentry.next=head;
        ListNode pRight=head;
        ListNode pLeft=head;
        ListNode memo=sentry;
        //构造距离差
        for(int i=0;i<n;i++){
            pRight=pRight.next;
        }
        while(pRight!=null){
            pRight=pRight.next;
            pLeft=pLeft.next;
            memo=memo.next;
        }
        memo.next=pLeft.next;
        return sentry.next;
    }
}
```

### [判断链表相交](https://leetcode.cn/problems/intersection-of-two-linked-lists/)
```json
{
    "距离快慢指针":"fast-slow_pointer"
}
```
- 先得出两链表长度,长的前进使得两个指针在同一起点
```java
public class Solution {
    public ListNode getIntersectionNode(ListNode headA, ListNode headB) {
        ListNode a=headA;
        ListNode b=headB;
        int cnta=0;
        int cntb=0;
        while(a!=null){
            cnta++;
            a=a.next;
        }
        while (b!=null){
            cntb++;
            b=b.next;
        }
        a=headA;
        b=headB;
        if(cnta<=cntb){
            int tmp=cntb-cnta;
            for (int i = 0; i < tmp; i++) {
                b=b.next;
            }
        }else{
            int tmp=cnta-cntb;
            for (int i = 0; i < tmp; i++) {
                a=a.next;
            }
        }
        while(true){
            if(a==b) return a;
            a=a.next;
            b=b.next;
        }
    }
}
```

### [查找链表环起点](https://leetcode.cn/problems/linked-list-cycle-ii/)
```json
{
    "距离快慢指针":"fast-slow_pointer"
}
```
- head是起点 f速度是2 s速度是1,相交停止,再从头速度都是1 相交就是ans

```java

public class Solution {
    public ListNode detectCycle(ListNode head) {
        ListNode s=head;
        ListNode f=head;
        if(head==null) return null;
        while(true){
            if(f.next==null || f.next.next==null) return null;
            f=f.next.next;
            s=s.next;
            if(f==s){
                break;
            }
        }
        s=head;
        while(s!=f){
            f=f.next;
            s=s.next;
        }
        return s;
    }
}
```

# 队列和栈

## 习题
### [LRU缓存模拟](https://leetcode.cn/problems/lru-cache/)
```json
{
    "双向链表队列+哈希表":"container"
}
```
- 双向链表队列+哈希表
- 用双向链表做队列方便O(1)复杂度找到container中的元素并remove,正常队列只能头部和尾部
```java
class LRUCache {
    class DoubleNode {
        public int key;
        public int val;
        public DoubleNode last;
        public DoubleNode next;

        public DoubleNode(int k, int v) {
            key = k;
            val = v;
        }
        public DoubleNode(){}
    }
    DoubleNode sentryHead=new DoubleNode();
    DoubleNode sentryTail=new DoubleNode();
    int len=0;
    int cap;
    HashMap<Integer,DoubleNode> map=new HashMap<>();
    public LRUCache(int capacity) {
        cap=capacity;
        sentryHead.next=sentryTail;
        sentryTail.last=sentryHead;
    }
    public  void offer(DoubleNode d){
        DoubleNode tmp = sentryTail.last;
        d.next=sentryTail;
        sentryTail.last=d;
        d.last=tmp;
        tmp.next=d;
        map.put(d.key,d);
    }
    public  void poll(){
        DoubleNode remove=sentryHead.next;
        DoubleNode tmp = sentryHead.next.next;
        sentryHead.next=tmp;
        tmp.last=sentryHead;
        map.remove(remove.key);
    }
    public void read(DoubleNode d){
        DoubleNode last = d.last;
        DoubleNode next = d.next;
        last.next=next;
        next.last=last;
        DoubleNode tmp = sentryTail.last;
        d.next=sentryTail;
        sentryTail.last=d;
        d.last=tmp;
        tmp.next=d;
    }

    public int get(int key) {
        if(map.containsKey(key)==false) return -1;
        read(map.get(key));
        return map.get(key).val;
    }

    public void put(int key, int value) {
        DoubleNode doubleNode = new DoubleNode(key, value);
        //这里注意boundary,如果已经存在要弹出再offer最后return
        if(map.containsKey(key)){
            DoubleNode d = map.get(key);
            DoubleNode last = d.last;
            DoubleNode next = d.next;
            last.next=next;
            next.last=last;
            offer(doubleNode);
            map.put(key,doubleNode);
            return;
        }
        if(len<cap){
            offer(doubleNode);
            len++;
        }else{
            poll();
            offer(doubleNode);
        }
    }
}

```

### [栈模拟队列leetcode](https://leetcode.cn/problems/implement-queue-using-stacks/)
- 两个栈循环
```java

class MyQueue {
    ArrayDeque<Integer> in=new ArrayDeque<>();
    ArrayDeque<Integer> out=new ArrayDeque<>();
    public MyQueue() {

    }
    //将in栈元素全部倒入out栈
    public void dao(){
        while(true){
            if(in.isEmpty()){
                break;
            }
            Integer pop = in.pop();
            out.push(pop);
        }
    }

    public void push(int x) {
        in.push(x);
    }

    public int pop() {
        if(out.isEmpty()){
            dao();
        }
        return out.pop();
    }

    public int peek() {
        if(out.isEmpty()){
            dao();
        }
        return out.peek();
    }

    public boolean empty() {
        if(in.isEmpty() && out.isEmpty()) return true;
        return false;
    }
}

```

### [队列模拟栈leetcode](https://leetcode.cn/problems/implement-stack-using-queues/)
- 一个队列循环
```java
	class MyStack {

		Queue<Integer> queue;

		public MyStack() {
			queue = new LinkedList<Integer>();
		}

		// O(n)
		public void push(int x) {
			int n = queue.size();
			queue.offer(x);
            //记录前边几个元素循环加入末尾
			for (int i = 0; i < n; i++) {
				queue.offer(queue.poll());
			}
		}

		public int pop() {
			return queue.poll();
		}

		public int top() {
			return queue.peek();
		}

		public boolean empty() {
			return queue.isEmpty();
		}

	}
```

### [最小栈leetcode](https://leetcode.cn/problems/min-stack/)
```json
{
    "记忆栈":"memo_pointers pointers_container"//最小栈的每个元素记忆原栈到栈底的最小值,将记忆指针放入容器方便管理
}
```
```java
class MinStack1 {
		public Stack<Integer> data;
		public Stack<Integer> min;

		public MinStack1() {
			data = new Stack<Integer>();
			min = new Stack<Integer>();
		}

		public void push(int val) {
			data.push(val);
			if (min.isEmpty() || val <= min.peek()) {
				min.push(val);
			} else { // !min.isEmpty() && val > min.peek()
				min.push(min.peek());
			}
		}

		public void pop() {
			data.pop();
			min.pop();
		}

		public int top() {
			return data.peek();
		}

		public int getMin() {
			return min.peek();
		}
	}
```

### [最大频率栈(二维栈)](https://leetcode.cn/problems/maximum-frequency-stack/)
```json
{
    "构造一个二维栈套栈":"pow_container",
    "map记忆频率":"map_container"
}
```
```java
class FreqStack {
    HashMap<Integer,Integer> map;
    int max=0;
    HashMap<Integer, ArrayList<Integer>> stack;
    public FreqStack() {
        map=new HashMap<>();
        stack=new HashMap<>();
    }

    public void push(int val) {
        if(map.containsKey(val)){
            map.put(val,map.get(val)+1);
        }else{
            map.put(val,1);
        }
        Integer cishu = map.get(val);
        if(stack.containsKey(cishu)){
            stack.get(cishu).add(val);
        }else{
            ArrayList<Integer> arr = new ArrayList<>();
            arr.add(val);
            stack.put(cishu,arr);
            max++;
        }

    }

    public int pop() {
        List<Integer> arr = stack.get(max);
        Integer remove = arr.remove(arr.size() - 1);
        map.put(remove,map.get(remove)-1);
        if(arr.isEmpty()){
            stack.remove(max);
            max--;
        }
        return remove;
    }
}
```

# 哈希表题目
- 去出hash表某个元素可用迭代器
tmp for(i:hashset){tmp=i;break;}
## [setall](https://www.nowcoder.com/practice/7c4559f138e74ceb9ba57d76fd169967)
```json
{
    "时间戳":"order"
}
```
```java
public static HashMap<Integer, int[]> map = new HashMap<>();
	public static int setAllValue;
	public static int setAllTime;
	public static int cnt;

	public static void put(int k, int v) {
		if (map.containsKey(k)) {
			int[] value = map.get(k);
			value[0] = v;
			value[1] = cnt++;
		} else {
			map.put(k, new int[] { v, cnt++ });
		}
	}

	public static void setAll(int v) {
		setAllValue = v;
		setAllTime = cnt++;
	}

	public static int get(int k) {
		if (!map.containsKey(k)) {
			return -1;
		}
		int[] value = map.get(k);
		if (value[1] > setAllTime) {
			return value[0];
		} else {
			return setAllValue;
		}
	}
```
## [LRU缓存](参见链表习题)
## [O(1) 时间插入、删除和获取随机元素](https://leetcode.cn/problems/insert-delete-getrandom-o1/)
```json
{
    "填remove的空隙":"partition_pointer",//用到划分指针的swap填充功能
    "哈希表计录每个元素索引":"container"//哈希容器
}
```
```java
import java.util.*;

class RandomizedSet {
    private ArrayList<Integer> arr;
    private HashMap<Integer,Integer> map;
    private Random rand;

    public RandomizedSet() {
        arr = new ArrayList<>();
        map = new HashMap<>();
        rand = new Random();
    }

    public boolean insert(int val) {
        if(map.containsKey(val)) return false;
        arr.add(val);
        map.put(val, arr.size() - 1);
        return true;
    }
    //划分指针的swap功能
    public boolean remove(int val) {
        if(!map.containsKey(val)) return false;
        int index = map.get(val);
        int lastVal = arr.get(arr.size() - 1);

        // 把最后的元素放到 index 位置
        arr.set(index, lastVal);
        map.put(lastVal, index);

        // 删除最后一个
        arr.remove(arr.size() - 1);
        map.remove(val);
        return true;
    }

    public int getRandom() {
        int index = rand.nextInt(arr.size());
        return arr.get(index);
    }
}

```

## [O(1) 时间插入、删除和获取随机元素 - 允许重复](https://leetcode.cn/problems/insert-delete-getrandom-o1-duplicates-allowed/)
```json
{
    "填remove的空隙":"partition_pointer",//用到划分指针的swap填充功能
    "哈希表计录每个元素索引":"container"
}
```
```java
import java.util.*;

class RandomizedCollection {
    HashMap<Integer, HashSet<Integer>> map=new HashMap<>();
    ArrayList<Integer> arr=new ArrayList<>();
    public RandomizedCollection() {

    }

    public boolean insert(int val) {
        if(map.containsKey(val)){
            arr.add(val);
            HashSet<Integer> set = map.get(val);
            set.add(arr.size()-1);
            return false;
        }
        arr.add(val);
        HashSet<Integer> set = new HashSet<>();
        set.add(arr.size()-1);
        map.put(val,set);
        return true;
    }

    public boolean remove(int val) {
        if(!map.containsKey(val)) return false;
        HashSet<Integer> valSet = map.get(val);
        int valIndex=0;
        for (Integer i : valSet) {
            valIndex=i;
            break;
        }
        int tailIndex=(arr.size()-1);
        int tailVal = arr.get(tailIndex);
        HashSet<Integer> tailSet = map.get(tailVal);
        if(val==tailVal){
            //注意移出尾巴元素
            valSet.remove(tailIndex);
        }else{
            arr.set(valIndex,tailVal);
            valSet.remove(valIndex);
            tailSet.remove(tailIndex);
            tailSet.add(valIndex);
        }
        arr.remove(tailIndex);
        //注意如果容器空了要移出map
        if(valSet.isEmpty()) map.remove(val);
        return true;
    }

    public int getRandom() {
        return arr.get((int)(Math.random() * arr.size()));
    }
}

```

# 二叉树

## 递归实现遍历
```json
{
    "递归树":"recur_tree"
}
```
- 先序
![alt text](image-5.png)
红打印节点是leaf节点设计到root,branch节点的开栈前边实现先序打印

- 中序
红打印节点是leaf节点设计到root,branch节点的开栈中间实现中序打印

- 后序
红打印节点是leaf节点设计到root,branch节点的开栈后边实现后序打印
```java
public void dfs(treenode root){
    if(root == null) return;
    //先
    dfs(root.left);
    //中
    dfs(root.right);
    //后

}
```

## 栈模拟递归

```json
{   
    "栈模拟递归树":"recur_tree memo_pointer",
    "虚返回":"lazy",//虚返回可以看作懒操作不用一步步返回
}
```
### 先序
- null是leaf节点
- branch节点首次进入就会被记录到ans中经过两次就会弹走
- 终止条件是p==null&&栈空了
```java
class Solution {
    public List<Integer> preorderTraversal(TreeNode root) {
            TreeNode p=root;
        ArrayDeque<TreeNode> cache = new ArrayDeque<>();
        List<Integer> ans = new ArrayList<>();
        while(true){
            //终止条件
            if(cache.isEmpty() && p==null){
                return ans;
            }
            if(p!=null){
                ans.add(p.val);
                cache.push(p);
                p=p.left;
            }else{
                TreeNode pop = cache.pop();
                //这里return的箭头是虚线,虚返回但是返回到了pop右孩子
                p=pop.right;
            }
        }

    }
}

```




### 中序
- null是leaf节点
- branch节点经过两次就会弹走并记录到ans
- 终止条件是p==null&&栈空了
```java
class Solution {
    public List<Integer> inorderTraversal(TreeNode root) {
        List<Integer> ans = new ArrayList<>();
        ArrayDeque<TreeNode> cache = new ArrayDeque<>();
        TreeNode p=root;
        while (true){
            //终止条件
            if(cache.isEmpty() && p==null){
                return ans;
            }
            //模拟recur_tree
            if(p!=null){
                cache.push(p);
                p=p.left;
            }else{
                //这里return的箭头是虚线,虚返回但是返回到了pop右孩子
                TreeNode tmp = cache.pop();
                ans.add(tmp.val);
                p=tmp.right;
            }
        }
    }
}
```


### 后序
- 无敌将左神解法和中序遍历交给gpt5写出来的
- null是leaf节点
- 右节点memo||为空就弹出 并标记
```java
    public List<Integer> postorderTraversal(TreeNode root) {
        List<Integer> ans = new ArrayList<>();
        ArrayDeque<TreeNode> stack = new ArrayDeque<>();
        TreeNode p = root, memo = null;
        while (p != null || !stack.isEmpty()) {
            if(p!=null){
                stack.push(p);
                p=p.left;
            }else{
                TreeNode peek = stack.peek();
                //返回条件
                if(peek.right==memo || peek.right==null){
                    //懒操作
                    TreeNode pop = stack.pop();
                    ans.add(pop.val);
                    memo=pop;
                }else{
                    //懒操作直到右节点满足条件p才真正转移过去
                    p=peek.right;
                }
            }
        }
        return ans;
    }

```


### 先中后序真正的模拟栈法
- p代表函数栈凡是p到的节点state就++
- leaf节点是null 循环终止条件是根节点
- 后序遍历在state==3时候打印先序1 中序2
```java
class Solution {
    public List postorderTraversal(TreeNode root) {
        List<Integer> ans = new ArrayList<Integer>();
        if (root == null) return ans;

        ArrayDeque<Pair> cache = new ArrayDeque<>();
        Pair pairroot = new Pair(root, 1);
        Pair p=pairroot;
        while(true){
            if(p.node==root && p.state==3){
                ans.add(root.val);
                return ans;
            }
            if(p.node!=null){
                if(p.state==1){
                    cache.push(p);
                    Pair tmp = new Pair(p.node.left, 1);
                    p=tmp;
                }else if(p.state==2){
                    Pair tmp = new Pair(p.node.right, 1);
                    p=tmp;
                }else{
                    Pair pop = cache.pop();
                    ans.add(pop.node.val);
                    p=cache.peek();
                    p.state++;
                }
            }else{
                Pair peek = cache.peek();
                p=peek;
                p.state++;
            }
        }
    }

    private static class Pair {
        TreeNode node;
        //记忆每个节点进入几次的状态
        int state;
        Pair(TreeNode n, int s) {
            node = n;
            state = s;
        }
    }
}


```



## out/in 实现bfs dfs

# 堆
- 优先级队列思考堆结构,堆结构是一个""排好序的队列",小头进大头出大根堆,大头进小头出小根堆
- 仅堆顶是确定的最大最小元素其他位置都不确定;如果需要自动排序的数据结构要确定堆顶在哪一头,
小头需要操作就是小根堆,大头需要操作就是大根堆
- 父节点 (i-1)/2
- 子节点 i*2+1  i*2+2 以0为初始索引
- 小根堆大根堆 Less()函数不同而已
## 上滤 heapinsert
```java
	public static void heapInsert(int i) {
        //终止boundary条件是<=
        //(0-1)/2=0所以终止掉在0;
		while (arr[i] > arr[(i - 1) / 2]) {
			swap(i, (i - 1) / 2);
			i = (i - 1) / 2;
		}
	}
```
- O(logn)
## 下滤 heapify
```java
	// i位置的数，向下调整大根堆
	// 当前堆的大小为size
	public static void heapify(int i, int size) {
		int l = i * 2 + 1;
		while (l < size) {
			int best = l + 1 < size && arr[l + 1] > arr[l] ? l + 1 : l;
			best = arr[best] > arr[i] ? best : i;
			if (best == i) {
				break;
			}
			swap(best, i);
			i = best;
			l = i * 2 + 1;
		}
	}
```
- O(logn)

## heapsort
```java
	// 从顶到底建立大根堆，O(n * logn)
	// 依次弹出堆内最大值并排好序，O(n * logn)
	// 整体时间复杂度O(n * logn)
	public static void heapSort1() {
		for (int i = 0; i < n; i++) {
			heapInsert(i);
		}
		int size = n;
		while (size > 1) {
			swap(0, --size);
			heapify(0, size);
		}
	}
```
- 从第一个元素的堆不断加入元素,构建一个大根堆,上滤
- 再从堆顶不断取最大值和末尾交换排序,下滤

```java
	// 从底到顶建立大根堆，O(n)
	// 依次弹出堆内最大值并排好序，O(n * logn)
	// 整体时间复杂度O(n * logn)
	public static void heapSort2() {
		for (int i = n - 1; i >= 0; i--) {
			heapify(i, n);
		}
		int size = n;
		while (size > 1) {
			swap(0, --size);
			heapify(0, size);
		}
	}
```
- 从叶子节点到root进行下滤,每次左右孩子都是已经好的大根堆相当于root节点变化进行下滤操作
- 时间复杂度是o(n)
- 

## discrete_function.∑积分 估计复杂度
- log1+log2+...+logn  is  ∫logn = nlogn
- 上滤下滤来回两轮

## 常量倍增法估计复杂度
- n的时候时间复杂度上界是O(nlogn)
- kn(k取2)2n的时候下界是O(nlogn)
- 由于时间复杂度不变所以是O(nlogn)


## 习题
### [合并k个有序链表leetcode](https://leetcode.cn/problems/merge-k-sorted-lists/)
```json
{
    "优先级队列小根堆":"container.cache",
    "不回退状态指针":"no-backtracking_pointer pointers_container"//进入cache充当不回退指针
}
```
- 合并两个用不回退指针和链表模型
- 注意进入cache充当不回退指针
```java
public class Solution {
    public ListNode mergeKLists(ListNode[] lists) {
        PriorityQueue<ListNode> cache = new PriorityQueue<>((a,b)->{return a.val-b.val;});
        ListNode sentry = new ListNode(666, null);
        ListNode pre=sentry;
        for (ListNode i : lists) {
            if(i!=null){
                cache.offer(i);
            }
            
        }
        while(!cache.isEmpty()){
            ListNode poll = cache.poll();
            pre.next=poll;
            pre=pre.next;
            if(pre.next!=null){
                cache.offer(pre.next);
            }
        }
        return sentry.next;
    }
}
```



### [数组整体累加和减半的操作次数leetcode](https://leetcode.cn/problems/minimum-operations-to-halve-array-sum/)
```java

class Solution {
	public static int halveArray(int[] nums) {
		// 大根堆
		PriorityQueue<Double> heap = new PriorityQueue<>((a, b) -> b.compareTo(a));
		double sum = 0;
		for (int num : nums) {
			heap.add((double) num);
			sum += num;
		}
		// sum，整体累加和，-> 要减少的目标！
		sum /= 2;
		int ans = 0;
		for (double minus = 0, cur; minus < sum; ans++, minus += cur) {
			cur = heap.poll() / 2;
			heap.add(cur);
		}
		return ans;
	}
}

```

### [数据流中的中位数](https://leetcode.cn/problems/find-median-from-data-stream/)
- 用一大一小两个优先级队列维护,拼起来就是一个排好序的数组
- 左部分用大根堆因为大头需要操作,右部分小根堆因为小头需要出来操作
```java
class MedianFinder {
    PriorityQueue<Integer> leftHeap=new PriorityQueue<>((a,b)->{return b-a;});
    PriorityQueue<Integer> rightHeap=new PriorityQueue<>((a,b)->{return a-b;});

    public MedianFinder() {

    }

    public void addNum(int num) {
        if(leftHeap.isEmpty() && rightHeap.isEmpty()){
            leftHeap.offer(num);
            return ;
        }
        Integer peekl = leftHeap.peek();
        if(num<=peekl){
            leftHeap.offer(num);
        }else{
            rightHeap.offer(num);
        }
        blance();
    }

    public double findMedian() {
        if(leftHeap.size()==rightHeap.size()){
            Integer peekl = leftHeap.peek();
            Integer peekr = rightHeap.peek();
            return ((double)(peekl+peekr))/2;
        }
        if(leftHeap.size()>rightHeap.size()) return (double)leftHeap.peek();
        return (double) rightHeap.peek();
    }
    //平衡两个堆的数量差在1以内
    public void blance(){
        int delt=(int)(Math.abs(leftHeap.size()-rightHeap.size()));
        if(delt>1){
            if(leftHeap.size()>rightHeap.size()){
                Integer poll = leftHeap.poll();
                rightHeap.offer(poll);
            }else{
                Integer poll = rightHeap.poll();
                leftHeap.offer(poll);
            }
        }
    }
}

```

# 图


# =================================================================== 2

# 排序导论

# 归并(分治)
```json
{
    "递归树":"recur_tree",
    "merge":"no-backtracking_pointer",//这里merge的时候有一个简单的statefilter
    "统计部分":"partition_pointer no-backtracking_pointer"//这里是开区间的划分指针,开区间更常见仅二分为了方便用闭区间

}
```
- 原理：
1）思考一个问题在大范围上的答案，是否等于，左部分的答案 + 右部分的答案 + 跨越左右产生的答案 //recur_tree state为区间范围
2）计算“跨越左右产生的答案”时，如果加上左、右各自有序这个设定，会不会获得计算的便利性  //函数设计为return答案stack数组变有序,需要划分指针不回退指针实现
3）如果以上两点都成立，那么该问题很可能被归并分治解决（话不说满，因为总有很毒的出题人）
4）求解答案的过程中只需要加入归并排序的过程即可，因为要让左、右各自有序，来获得计算的便利性


## 归并排序
- 二分为两部分每一部分都有序再用辅助数组将两部分合成一个有序部分
```java
class Solution {
    int[] help;
    public int[] sortArray(int[] nums) {
        help = new int[nums.length];
        dfs(nums,0,nums.length-1);
        return nums;
    }
    //recur_tree
    public void dfs(int[] arr,int l,int r){
        if(l==r) return;
        int m=(l+r)>>1;
        dfs(arr,l,m);
        dfs(arr,m+1,r);
        merge(arr,l,m,r);
    }

    public void merge(int[] arr,int l,int m,int r){
        int i=l;int j=m+1;
        //辅助数组container.help_container
        int k=l;
        //i,j nobacktracking指针
        while(i<=m && j<=r){
            if(arr[i]<=arr[j]){
                tmp[k++]=arr[i++];
            }else{
                tmp[k++]=arr[j++];
            }
        }
        //state_filter
        // 左侧指针、右侧指针，必有一个越界、另一个不越界
        while(i<=m){
            tmp[k++]=arr[i++];
        }
        while(j<=r){
            tmp[k++]=arr[j++];
        }
        System.arraycopy(tmp,l,arr,l,r+1-l);
    }
}


```
### 时空复杂度
	// 假设l...r一共n个数
    //merge()操作额外复杂度是O(n)通过分析recurtree可以简易得出
	// T(n) = 2 * T(n/2) + O(n)
	// a = 2, b = 2, c = 1
	// 根据master公式，时间复杂度O(n * logn)
	// 空间复杂度O(n)//用了一个n的辅助help数组

## 习题
### [小和问题nowcoder](https://www.nowcoder.com/practice/edfe05a1d45c4ea89101d936cac32469)
```json
{
    "递归树":"recur_tree",
    "merge排序":"no-backtracking_pointer",
    "统计部分":"partition_pointer no-backtracking_pointer"//这里是开区间的划分指针,开区间更常见仅二分为了方便用闭区间
}
```
```java
import java.io.*;
import java.util.Scanner;

// 注意类名必须为 Main, 不要有任何 package xxx 信息
public class Main {
    public static int MAXN = 100001;

    public static int[] arr = new int[MAXN];

    public static int[] help = new int[MAXN];

    public static int n;

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            for (int i = 0; i < n; i++) {
                in.nextToken();
                arr[i] = (int) in.nval;
            }
            out.println(smallSum(0, n - 1));
        }
        out.flush();
        out.close();
    }

    // 结果比较大，用int会溢出的，所以返回long类型
    // 特别注意溢出这个点，笔试常见坑
    // 返回arr[l...r]范围上，小和的累加和，同时请把arr[l..r]变有序
    // 时间复杂度O(n * logn)
    public static long smallSum(int l, int r) {
        if (l == r) {
            return 0;
        }
        int m = (l + r) / 2;
        long tmp = smallSum(l, m) + smallSum(m + 1, r) + tongji(l, m, r);
        merge(l, m, r);
        return tmp;
    }

    // 统计部分
    public static long tongji(int l, int m, int r) {
        long ans = 0;
        int sum = 0;
        //i是开区间划分指针,sum记录区间状态
        int i = l;
        //j是nobacktrack指针寻找小和
        for (int j = m + 1; j <= r; j++) {
            //寻找右指针对应的区间
            while (true) {
                if (i > m) break;
                if (arr[i] <= arr[j]) {
                    sum += arr[i++];
                } else {
                    break;
                }
            }
            ans += sum;
        }
        return ans;
    }

    // 返回跨左右产生的小和累加和，左侧有序、右侧有序，让左右两侧整体有序
    // arr[l...m] arr[m+1...r]
    public static void merge(int l, int m, int r) {
        // 正常merge
        int i = l;
        int a = l;
        int b = m + 1;
        while (a <= m && b <= r) {
            help[i++] = arr[a] <= arr[b] ? arr[a++] : arr[b++];
        }
        while (a <= m) {
            help[i++] = arr[a++];
        }
        while (b <= r) {
            help[i++] = arr[b++];
        }
        for (i = l; i <= r; i++) {
            arr[i] = help[i];
        }
    }
}
```


### [反转对数量leetcode](https://leetcode.cn/problems/reverse-pairs/)
- 注意溢出风险
- 和第一题几乎一模一样
```json
{
    "递归树":"recur_tree",
    "merge排序":"no-backtracking_pointer",
    "统计部分":"partition_pointer no-backtracking_pointer"//这里是开区间的划分指针,开区间更常见仅二分为了方便用闭区间
}
```
```java
public class Solution {
        int[] help;
        public int reversePairs(int[] nums) {
            help = new int[nums.length];
            int l=0;int r=nums.length-1;
            return dfs(nums,l,r);
        }
        public static int dfs(int[] arr,int l,int r){
            if(l==r){
                return 0;
            }
            int m=(l+r)>>1;
            int tmp=dfs(arr,l,m)+dfs(arr,m+1,r)+tongji(arr,l,m,r);
            merge(arr,l,m,r);
            return tmp;
        }
        public static int tongji(int[]arr,int l,int m,int r){
            int i=l;int j=m+1;int sum=0;int ans=0;
            for(i=l;i<=m;i++){
                while(true){
                    if(j>r) break;
                    //注意溢出风险
                    if((long) arr[i] > (long) arr[j] * 2){
                        sum++;
                        j++;
                    }else{
                        break;
                    }
                }
                ans+=sum;
            }
            return ans;
        }
        public static void merge(int[]arr,int l,int m,int r){
            int i=l;int j=m+1;int k=l;
            while(i<=m && j<=r){
                if(arr[i]<=arr[j]){
                    help[k++]=arr[i++];
                }else{
                    help[k++]=arr[j++];
                }
            }
            while(i<=m){
                help[k++]=arr[i++];
            }
            while(j<=r){
                help[k++]=arr[j++];
            }
            System.arraycopy(help,l,arr,l,r+1-l);
        }
    }
```

# 随机快速(分治)
```json
{
    "递归":"recur_tree",
    "划分区域":"partition_pointer",//划分成< = >三个区域,注意着三个区域的开闭关系,<是) =是[) >是(
    "边界判断技巧":"boundary"
}
```
## 随机快速排序
- dfs函数的io是:
整体排好序
- stack是:
先划分把=区域的元素确定好顺序,再dfs<和>区域
- 划分指针分析
典型的开闭结合划分指针
i是<区域的右开区间和=区域的左[闭区间
k是=区域的)右开区间
j是>区域的左(开区间
开区间都设计为指针的移动方向,因为设计成迭代头的形式方便迭代遍历
这样设计一开始所有区间都没元素
```java
class Solution {
        public int[] sortArray(int[] nums) {
            dfs(nums,0,nums.length-1);
            return nums;
        }
        public static void swap(int[] arr,int l,int r){
            int tmp=arr[l];
            arr[l]=arr[r];
            arr[r]=tmp;
        }
        public static void dfs(int[]arr,int l,int r){
            //boundary技巧
            //注意这里的叶子节点为>= 因为划分指针如果在最右端会出现>的情况
            if(l>=r){
                return ;
            }
            int x=arr[(int)(Math.random()*(r-l+1))+l];
            partition(arr,l,r,x);
            // 为了防止底层的递归过程覆盖全局变量
		    // 这里用临时变量记录first、last
            //如果是golang直接返回两个值就可以
            int left=i-1;
            int right=j+1;
            dfs(arr,l,left);
            dfs(arr,right,r);
        }
        //java没多返回值用两个静态变量当划分指针
        public static int i=0;
        public static int j=0;
        //划分完=区域就排好序确定了
        public static void partition(int[]arr,int l,int r,int x){
            //< 和 >区域的划分指针 注意i也是=区域的左闭区间
            i=l;j=r;
            //k是=区域的)右开区间,这样设计一开始所有区间都没元素
            int k=l;
            while(true){
                if(k>j){
                    break;
                }
                if(arr[k]<x){
                    //        i     k     j
                    //1,2,3,4,5,5,5,4,4,...
                    //k和=区域的左闭区间调换k++扩充=区域,i++扩充<区域
                    swap(arr,i,k);
                    k++;
                    i++;
                }else if(arr[k]==x){
                    //=区域扩充
                    k++;
                }else{
                    swap(arr,j,k);
                    //k不变,因为右边调换过来的数还没检查过
                    j--;
                }
            }
        }
    }
```

## 习题 
### [第k小的数luogu](https://www.luogu.com.cn/problem/P1923)
```json
{
    "递归树":"recur_tree",
    "划分区域":"partition_pointer",
    "剪枝为一叉树":"prune"
}
```
- 参见随机快排划分完=区域已经排好序已经确定不再改变,据此来寻找剪枝寻找第k小的树
- 这里递归树只走一个分支并不会遍历所有节点
- 时间复杂度参考快排的期望计算,每次分一半n/2+n/4+n/8+...+1=log(n)等比数列
```java
import java.io.*;
import java.util.Scanner;

// 注意类名必须为 Main, 不要有任何 package xxx 信息
public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(reader);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        in.nextToken();
        int n=(int)in.nval;
        in.nextToken();
        int k=(int)in.nval;
        int[] arr = new int[n];
        in.nextToken();
        for (int i = 0; i < n; i++) {
            arr[i]=(int)in.nval;
            in.nextToken();
        }
        dfs(arr,0,arr.length-1,k);
        out.println(ans);
        out.flush();
        out.close();

    }
    public static int i=0;
    public static int j=0;
    public static int ans=0;
    public static int dfs(int[] arr,int l,int r,int k){
        //注意这里的Boundary
        if(l==r){
            return arr[l];
        }//if(l>r){
           // return; //因为只走递归树的一个分支所以不会出现l>r的情况
        //}
        int x=(l+(int)(Math.random()*(r-l+1)));
        partition(arr,l,r,x);
        if(k>=i && k<=j){
            ans=arr[i];
            return ;
        }
        int left=i-1;
        int right=j+1;
        if(k<i){
           return dfs(arr,l,left,k);
        }else{
           return dfs(arr,right,r,k);
        }
    }
    public static void partition(int[] arr,int l,int r,int x){
        i=l;j=r;int k=l;
        while(k<=j){
            if(arr[k]<x){
                swap(arr,i,k);
                i++;
                k++;
            }else if(arr[k]==x){
                k++;
            }else{
                swap(arr,k,j);
                j--;
            }
        }
    }

    public static void swap(int[] arr,int a,int b){
        int tmp=arr[a];
        arr[a]=arr[b];
        arr[b]=tmp;
    }
}
```
- 迭代改写递归
因为递归树是一叉树所以简易迭代改写
```java
	// 随机选择算法，时间复杂度O(n)
	public static int findKthLargest(int[] nums, int k) {
		return randomizedSelect(nums, nums.length - k);
	}

	// 如果arr排序的话，在i位置的数字是什么
	public static int randomizedSelect(int[] arr, int i) {
		int ans = 0;
		for (int l = 0, r = arr.length - 1; l <= r;) {
			// 随机这一下，常数时间比较大
			// 但只有这一下随机，才能在概率上把时间复杂度收敛到O(n)
			partition(arr, l, r, arr[l + (int) (Math.random() * (r - l + 1))]);
			// 因为左右两侧只需要走一侧
			// 所以不需要临时变量记录全局的first、last
			// 直接用即可
			if (i < first) {
				r = first - 1;
			} else if (i > last) {
				l = last + 1;
			} else {
				ans = arr[i];
				break;
			}
		}
		return ans;
	}

	// 荷兰国旗问题
	public static int first, last;

	public static void partition(int[] arr, int l, int r, int x) {
		first = l;
		last = r;
		int i = l;
		while (i <= last) {
			if (arr[i] == x) {
				i++;
			} else if (arr[i] < x) {
				swap(arr, first++, i++);
			} else {
				swap(arr, i, last--);
			}
		}
	}

	public static void swap(int[] arr, int i, int j) {
		int tmp = arr[i];
		arr[i] = arr[j];
		arr[j] = tmp;
	}
```

## 时间复杂度分析
- 随机过程用期望值,因为如果用最差情况概率会等于零
- 差
递归树二叉树退化为一叉树,时间复杂度O(N^2) 空间复杂度O(N)
- 好
用等比数列来算 深度x 数量n 
递归树完全是二叉树,时间复杂度是O(NlogN) 空间复杂度是O(logN)
master公式 T(n)=2T(n/2)+O(n)  时间复杂度是O(nlogn)
空间复杂度:由二叉树可得叶子节点是n 树的层数为x  n=2^(x-1) x=log(n) 
- 由于用期望来计算 综合时间复杂度为o(nlogn) 空间复杂度为o(logn)

# 基数(桶)排序
```json
{   "桶":"hubs",//记忆要像桶这个模型倒入倒出起到集线器的作用
    "前缀和函数优化桶":"discrete_function.Σ∫",
    "桶内的次序":"order ordinal_cardinal"//因为前缀,所以排序的时候每个桶内先排大的,所以遍历原数组要从右往左遍历保证大的先排到
}
```
## 计数排序
- 投票问题
适用于范围较小,准备数列,每个索引是一个桶,投哪个就++最后倒出来

## 桶排序 前缀和函数,进制优化
- 自然比较先比较个位排好再比较十位,每一位都进行一遍桶操作
- ![alt text](image-8.png)
## 十进制
```java
    public static void jishuSort(int[] arr){
        int n=arr.length;
        int[] tmp = new int[n];
        int[] tong = new int[10];
        int max=0;
        for (int i : arr) {
            max=Math.max(max,i);
        }
        int bits=(""+max).length();
        int offset=1;
        for(int i=1;i<=bits;i++){
            Arrays.fill(tong,0);
            for(int j=arr.length-1;j>=0;j--){
                int tmpnumber=(arr[j]/offset)%10;
                tong[tmpnumber]++;
            }
            for(int j=1;j<=9;j++){
                tong[j]=tong[j]+tong[j-1];
            }
            for(int j=arr.length-1;j>=0;j--){
                int tmpnumber=(arr[j]/offset)%10;
                tmp[tong[tmpnumber]-1]=arr[j];
                tong[tmpnumber]--;
            }
            System.arraycopy(tmp,0,arr,0,arr.length);

            offset=offset*10;
        }
    }

```

```java


// 基数排序
// 测试链接 : https://leetcode.cn/problems/sort-an-array/
public class Solution {

	// 可以设置进制，不一定10进制，随你设置
	public static int BASE = 10;

	public static int MAXN = 50001;

	public static int[] help = new int[MAXN];

	public static int[] cnts = new int[BASE];

	public static int[] sortArray(int[] arr) {
		if (arr.length > 1) {
			// 如果会溢出，那么要改用long类型数组来排序
			int n = arr.length;
			// 找到数组中的最小值
			int min = arr[0];
			for (int i = 1; i < n; i++) {
				min = Math.min(min, arr[i]);
			}
			int max = 0;
			for (int i = 0; i < n; i++) {
				// 数组中的每个数字，减去数组中的最小值，就把arr转成了非负数组
				arr[i] -= min;
				// 记录数组中的最大值
				max = Math.max(max, arr[i]);
			}
			// 根据最大值在BASE进制下的位数，决定基数排序做多少轮
			radixSort(arr, n, bits(max));
			// 数组中所有数都减去了最小值，所以最后不要忘了还原
			for (int i = 0; i < n; i++) {
				arr[i] += min;
			}
		}
		return arr;
	}

	// 返回number在BASE进制下有几位
	public static int bits(int number) {
		int ans = 0;
		while (number > 0) {
			ans++;
			number /= BASE;
		}
		return ans;
	}

	// 基数排序核心代码
	// arr内要保证没有负数
	// n是arr的长度
	// bits是arr中最大值在BASE进制下有几位
	public static void radixSort(int[] arr, int n, int bits) {
		// 理解的时候可以假设BASE = 10
		for (int offset = 1; bits > 0; offset *= BASE, bits--) {
			Arrays.fill(cnts, 0);
			for (int i = 0; i < n; i++) {
				// 数字提取某一位的技巧
                //桶数组
				cnts[(arr[i] / offset) % BASE]++;
			}
			// 处理成前缀次数累加的形式
			for (int i = 1; i < BASE; i++) {
                //桶数组∑∫
				cnts[i] = cnts[i] + cnts[i - 1];
			}
			for (int i = n - 1; i >= 0; i--) {
				// 前缀数量分区的技巧
				// 数字提取某一位的技巧
				help[--cnts[(arr[i] / offset) % BASE]] = arr[i];
			}
			for (int i = 0; i < n; i++) {
				arr[i] = help[i];
			}
		}
	}

}

```


# 排序算法总结
- 稳定性指元素间相对order不变
- 归并快排用master公式估计时间复杂度
- 主要算法时间、空间、稳定性总结
                  时间               空间              稳定性
SelectionSort    O(N^2)             O(1)               无
BubbleSort       O(N^2)             O(1)               有
InsertionSort    O(N^2)             O(1)               有
MergeSort        O(N*logN)          O(N)               有
QuickSort        O(N*logN)        O(logN)              无
HeapSort         O(N*logN)          O(1)               无
CountSort        O(N)               O(M)               有
RadixSort        O(N)               O(M)               有
- quicksort相比merge空间少了但是不稳定,守恒
- quicksort通常常数时间比heapsort好,守恒

# =================================================================== 3

# binary-bit题目
## 异或题目
- 1~10少了一个元素求这个元素
准备两个集合一个是[1,10]另一个是少了的集合
两个集合元素^  1^1^2^2^... 因为n^n=0 0^n=n 所以最后就剩下了缺失的那个数
- 数组中一种数出现奇数次另一种出现偶数次直接全部异或不必多说
- 黑白棋
### [只出现一次的数字 III](https://leetcode.cn/problems/single-number-iii/)
- 全部异或 剩下a^b
- lowbit 确定a,b不同位某位一定为1 某位一定为0
- 将这一位为1的跳过再全部异或起来最会肯定剩下a或b再a^b^x 确定另一个元素
```java
class Solution {
    public int[] singleNumber(int[] nums) {
        int e1=0;
        for (int num : nums) {
            e1=e1^num;
        }
        int lowbit=e1&(-e1);
        int e2=0;
        for (int num : nums) {
            if((num&lowbit)==0){
                e2=e2^num;
            }
        }
        int[] ans = new int[2];
        int e3=e2^e1;
        ans[0]=e3;ans[1]=e2;
        return ans;
    }
}
```
## bit题目
### [只出现一次的数字 II](https://leetcode.cn/problems/single-number-ii/)
- 统计所有位上的1,不是m的倍数的就是这位就有answer的1最后加起来
```java
class Solution {
    public int singleNumber(int[] nums) {
        int m=3;
        int[] cnt = new int[32];
        for (int num : nums) {
            for(int i=0;i<32;i++){
                int tmp=1&(num>>i);
                if(tmp==1){
                    cnt[i]++;
                }
            }
        }
        int ans=0;
        for(int i=0;i<32;i++){
            if(cnt[i]%m!=0){
            ans=ans | (1<<(i));
            }
        }
        return ans;
    }
}
```
### [2的幂判断](https://leetcode.cn/problems/power-of-two/)
- lowbit
```java
class Solution {
    public boolean isPowerOfTwo(int n) {
        //2的幂仅有一位1所以lowbit看看是不是相同就行
        if(n>0 && (n&(-n))==n) return true;
        return false;
    }
}
```
### [3的幂判断](https://leetcode.cn/problems/power-of-three/)
- 找一个int范围内最大的3的幂计算器或者自己算然后%n==0就是!=0就不是

### [区间内所有数&起来](https://leetcode.cn/problems/bitwise-and-of-numbers-range/)
- lowbit看最右侧的1会不会消失
```java
public class Code04_LeftToRightAnd {
	public static int rangeBitwiseAnd(int left, int right) {
		while (left < right) {
			right -= right & -right;
		}
		return right;
	}

}
```

### java关于bit的api 
- cout hightlowbit trailleading

# =================================================================== 4

# 递归题目
- recur_tree

# =================================================================== 5

# 高等数学
- skills 数学相关指的是数学底层的东西例如集合论soo,mod底层算子原理
- 高等数学是数学相关的应用例如同余原理

# 最大公约数(辗转相除法)
```json
{
    "基数取模":"mod"
}
```
![alt text](Euclidean_algorithm_252_105_animation_flipped.gif)
```java
public int gcd (int a,int b){
    while(b!=0){
        int tmp=a;
        a=b;
        b=tmp%b;
    }
    return a;
}
```
## 习题

# 同余原理

# 组合数学
- 组合is set-element 排列 is order  组合+order=排列

## 全组合
- recur_tree prune
## 全排列
- recur_tree prune

# =================================================================== 6

# 高等数据结构

# 前缀树

# =================================================================== 7

# discrete_function
- 用数组模拟算子,将索引映射的算法
- 动态规划可以看作递归树的逆从leaf到root的遍历,递归可改成dp

# 前缀和和差分 积分和微分

# 一维动态规划
- 用空间代替重复计算,用dp数组模拟算子,将索引dp(i)映射到求解值
## 典中典 fabbnoci 数列
算子dp,将索引i映射到i的斐波那契值 dp(i)=dp(i-1)+dp(i-2);
```java
public static int fabbnoci(int n){
    int[] dp=new int[n+1];
    dp[0]=1;dp[1]=1;
    for(int i=2;i<=n;i++){
        dp[i]=dp[i-1]+dp[i-2];
    }
    return dp[n];
}
```
- 降维优化
```java
public static int fabbnoci(int n){
    int dp1=1;int dp2=1;
    int i=1;
    while(true){
        if(i==n) return dp2;
        int tmp=dp2;
        dp2=dp1+dp2;
        dp1=tmp;
        i++;
    }
}
```

## 习题
### [最低票价](https://leetcode.cn/problems/minimum-cost-for-tickets/)

# KMP
https://www.bilibili.com/video/BV1Er421K7kF/
https://oi-wiki.org/string/kmp/
```json
{
    "前缀算子π":"symmetry discrete_function",
    "π算子幂":"operator_pow"
}
```
## 前缀算子π


## symmetry discrete_function
![alt text](image-6.png)
![alt text](image-7.png)
```go
π(i-1)+1=π(i)
ππ(i-1)+1=π(i)
π^3(i-1)+1=π(i)
...
π^n(i-1)+1=π(i)
//终止条件是π^n==0 || π^n(-1)+1==π(i)
//以1为索引 以0就one_short
```
```java
//以0为索引
class Solution {
    public int strStr(String haystack, String needle) {
        int ans=needle.length();
        StringBuilder sb = new StringBuilder();
        sb.append(needle);sb.append('#');sb.append(haystack);
        int[] pi = new int[sb.length()];
        pi[0]=0;
        for(int i=1;i<pi.length;i++){
            //j是迭代指数 类似于int i while{ i++}末尾状态更新
            int j=pi[i-1];
            while(true){
                if(j==0 || sb.charAt(i)==sb.charAt(j)) break;
                j=pi[j-1];
            }
            if(sb.charAt(i)==sb.charAt(j)){
                pi[i]=j+1;
            }
            if(pi[i]==ans){
                return i-2*ans;
            }
        }
        return -1;
    }
}

//以1为索引
class Solution {
    public int strStr(String haystack, String needle) {
        int ans=needle.length();
        StringBuilder sb = new StringBuilder();
        sb.append(needle);sb.append('#');sb.append(haystack);
        int[] pi = new int[sb.length()];
        pi[0]=0;
        for(int i=1;i<pi.length;i++){
             //j是迭代指数 类似于int i while{ i++}末尾状态更新
            int j=pi[i-1];
            while(true){
                if(j==0 || sb.charAt(i)==sb.charAt(j)) break;
                j=pi[j-1];
            }
            if(sb.charAt(i)==sb.charAt(j)){
                pi[i]=j+1;
            }
            if(pi[i]==ans){
                return i-2*ans;
            }
        }
        return -1;
    }
}
```






