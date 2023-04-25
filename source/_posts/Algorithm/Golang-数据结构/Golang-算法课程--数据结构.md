---
title: Golang 算法课程--数据结构
catalog: true
date: 2023-04-02 00:46:21
subtitle:
header-img:
tags: working, 算法
categories: 算法，Golang
---

# 告别盲目刷题，击破算法面试
> 学习拉钩教育算法课程记录加个人感悟记录
> 如果有版权问题，请联系 2374087322@qq.com 删除课程部分的内容
> 
> 算法能力的高度，决定了个人能够解决的实战问题复杂度的上限
>
> 数学基础决定了算法能力的高低

## ==解题流程==：

### ==四部分析法==

* **==模拟==** ： 模拟题目的运行
  使用简单且有一定量的小例子，将自己当作计算机来执行这个流程
  *一般使用题目给的较长的那个例子就可以*
\
  这部分也是读题和理解输入输出内容的部分，理解题意的部分
\
  这个时候一定不能够着急，不要害怕或者是觉得麻烦，一定要耐下性子，把简单的一个逻辑过程给跑清楚，理解这段程序或者是业务需要咱们处理什么样的问题。
\
  跑的过程，不要完全先入为主，应当以题目的要求来推进演示。
\
  不要想着在这一步就把所有的问题都给解决，一步步推进就可以. 
<br />

* **==规律==** ： 尝试总结出题目的一般规律和特点
  
  数学规律和特性一般来说很难直接从零归纳出来，但我们可以依赖所学习的高数、线性代数、离散数学、测度论等高等数学理论当中所见到的数学计算模型来匹配，这也是这部分最重要的基础

  先总结一些考题可能会用到的观察特点：
  * 形式相关：比如 括号匹配、从1加到100，
  * 数量变化：数量变化与取模相关，数量变化呈现递推公式
  * 


* **==匹配==** ： 找到符合这些特点的数据结构和算法
  * 关注数据的输入类型：对输入数据进行分类，哪一些数据进行怎样的操作

  * **==怎样匹配呢？==**：
    * 题目模拟的时候（这部分一般使用栈、队列、二叉树）来理解题目要求的数字变化
    * 观察结果集合，或者是原本中间的变化集合，当期符合某种数据结构的变化特征的时候，就可以选用这个数据结构


* **==考虑边界条件==**： 考虑特殊情况
  特殊情况：
  * 字符串为空，字符串只有一个，两个、
  * 数组为空，数字为0或者是其他不符合规律的特殊情况


* **==深度思考==** ： 平时练习当中的流程，用于提高算法模型的积累
  * 深度： 这种解法还可以怎么优化
  * 广度： 这种解法的具有普适性吗？可以推广吗？问题的限定条件变多的话，这个模型是否还可以适合。
  * 数学模式扩散： 这样特点的问题是否有对应的数学模型或者是理论描述过



# 栈： 从简单栈到单调栈，让栈问题不再困难

## 结构特征

先进后出

对栈的操作：
* **==pop==** 弹出栈顶元素，一般来说栈中可操作的元素就是栈顶元素，其他元素也都是先pop出其上面的元素，变成栈顶元素之后再进行操作。
*  **==peek==** 获取栈顶元素，只是读取操作，但并没有弹出栈顶元素
*  **==push==** 将元素压入栈中
  
### Golang 栈的使用

在 Go 中并没有直接提供Stack的方法结构，但可以使用切片非常简单地表示和使用栈、队列结构。
 
 先进后出的数据结构，使用**==切片==**表示，压入栈的操作就是往切片中添加元素，弹出栈的操作就是输出末尾元素，并将切片缩小为：`[:len(stack)-1]`

以下为栈的代码模板实现：
```golang
type Stack struct{
    Stack []interface{}
}

func (s *Stack)push(x interface{}){
    s = append(s,x)
}

func (s *Stack)pop(){
    s = s[:len(s)-1]
}

func (s *Stack)peek()(x interface{}){
    return s[len(s)-1]
}
```

关键在于记住：
* 栈顶元素 ---> 切片末尾元素
* 切片是左闭右开，所以pop操作是 s = s[:len(s)-1], 但如果是队列pop出第一个元素就需要往后再移动一位 s = s[1:] 而不是 s = s[0:]

## 典型题目

### 判断字符串是否合法
题目：https://leetcode.cn/problems/valid-parentheses/

#### 正确解法和流程
https://leetcode.cn/link/?target=https://www.bilibili.com/video/BV1AF411w78g
```golang
func isValid(s string) bool {
    n := len(s)
    if n % 2 == 1 {
        return false
    }
    pairs := map[byte]byte{
        ')': '(',
        ']': '[',
        '}': '{',
    }
    stack := []byte{}
    for i := 0; i < n; i++ {
        if pairs[s[i]] > 0 {
            if len(stack) == 0 || stack[len(stack)-1] != pairs[s[i]] {
                return false
            }
            stack = stack[:len(stack)-1]
        } else {
            stack = append(stack, s[i])
        }
    }
    return len(stack) == 0
}
```

#### 个人解法和流程

> 问题集中体现在数据特性处理判断太过分散，属实是缝缝补补有一年
> 对输入数据进行分类，哪一些数据进行怎样的操作
> * 输入的是左括号应该入栈
> * 输入的是右括号应该做判断
<br />

我的代码是：
```golang
    func isValid(s string) bool {
    
    l := len(s)
    if l%2 != 0{
        return false
    }
    stack := make([]rune, 0)

    m := map[rune]rune{
        ']':'[',
        ')':'(',
        '}':'{',
    }
    for _,v := range s{
        if v == '[' ||v == '{' ||v == '('{
            stack = append(stack,v)
            continue
        }
        if len(stack) == 0{
            return false
        }
        if stack[len(stack)-1] == m[v]{
            stack = stack[:len(stack)-1]
            continue
        }

        if m[v] != 0 {return false}
    }

    if len(stack) == 0{return true}

    return false
}
```
上述在判断栈顶元素的时候逻辑不够清晰，所以加了很多的if来补足条件，我们看例子当中所给的逻辑顺序：
```golang
        pairs := map[byte]byte{
        ')': '(',
        ']': '[',
        '}': '{',
    }
    stack := []byte{}
    for i := 0; i < n; i++ {
        if pairs[s[i]] > 0 {
            if len(stack) == 0 || stack[len(stack)-1] != pairs[s[i]] {
                return false
            }
            stack = stack[:len(stack)-1]
        } else {
            stack = append(stack, s[i])
        }
    }
    return len(stack) == 0
```

关键差距就在于这一句话：`pairs[s[i]] > 0 `, 这个判断对输入的数据做了一次分类，依据上面的map结构可知，这句话 < 0 时候标识map当中没有存储对应的对象，而map中存储的是所有的左括号，所以这个判断的作用是**当输入是右括号的时候进入函数**，然后逻辑体依据输入是右括号判断，如果当前栈里面没有元素或者是栈顶元素与右括号不匹配那么就返回false
\
实际上我写的函数最后夜市做了类似的判断，但显然没有考虑数据分类的情况。


### 判断大鱼吃小鱼最后留下的鱼
题目：

近似题目：https://www.nowcoder.com/questionTerminal/3fdfc63015df42c6a78fdae46709fa69?f=discussion

<br />

#### 正确解法和流程
``` c++
class Solution {
public:
    /**
     * 
     * @param N int整型 N条鱼
     * @param A int整型vector 每条鱼的体积为Ai
     * @return int整型
     */
    struct P{
        int x, t;
    };
    int solve(int N, vector<int>& A) {
        stack<P> S;
        int cnt = 0;
        for(int i=N-1;i>=0;i--){
            int t = 0;
            while(!S.empty() && A[i]>S.top().x){
                t = max(S.top().t, t+1);
                S.pop();
            }
            S.push({A[i], t});
            cnt = max(cnt, t);
        }
        return cnt;
    }
};
```


#### 个人解法和流程
由于找不到相同的题目，就找了类似的题目，但是解题的思路不太一样
图片上的大鱼吃小鱼，只需要每次比较栈顶元素和新进来的元素大小即可，当大于的时候，就不做操作，当栈顶元素小于输入元素的时候，pop出栈顶元素并push进入这个最大值，最后栈中元素就是结果。这个过程当中几处需要重视的地方是：
* 当鱼的方向一致时候，大鱼并不会把同方向的小鱼给吃了【可能不论大小鱼的速度相同（bushi）】，而如果小鱼在左，大鱼在右，方向不同，则也不会吃


牛客网的题目则加了非常多的条件和限制，是对栈问题的一个较大的变化

> 对比上述两个题目可以观察到：
> <font color ='blue'> 1. 消除的行为不同</font>
>   括号匹配中，消除行为是配对的两者都会消除，也就是栈顶元素和输入元素一起被消除
>   大鱼吃小鱼中，消除行为是配对的两者中会有一个被消除
> --> 是否入栈和出栈的判断
> <font color ='blue'> 2. 栈中的内容不同</font>
>   括号匹配当中，栈中存放的就是内容本身
>   大鱼吃小鱼当中，栈里存放的是内容的索引，可以通过索引找到内容
> <font color ='blue'> 3. 弹栈的方式也不相同</font>
>   括号匹配只需要每次弹出一个元素就可以
>   大鱼则需要用while语句一直弹出到满足某个条件才停止


## 栈问题的特征和解决流程

### pop 行为不同
pop【弹栈的操作不一样】
常见的就是每次循环都判断栈顶元素的特点而pop或者push或者不操作，但这样必须得是连续性的元素才有这样的特征

**==在弹栈的时候，是否一定要满足某个条件才停止弹栈==**
也就是说当输入元素之后需要将其和站内其他的元素进行比较，在使用的时候尤其要注意迭代过程

### 栈中存储内容不相同
是否栈中存储数据、还是存储索引、还是存储一个自建的新的结构

### 栈顶元素的含义不相同


## 单调栈

单调栈是指栈中元素必须按照升序排列的栈或者是降序排列的栈

单调栈分为：
* 递增栈：
    栈中元素从左到右遵守从小到大的顺序
    入栈时候，当**入栈元素小于栈顶元素**就会pop出栈顶元素，直到入栈元素大于栈顶元素
    特点是：
    入栈小数会消除栈内大数

* 递减栈
    栈中元素从左到右遵守从大到小的顺序
    入栈时候，当**入栈元素大于栈顶元素**就会pop出栈顶元素，直到入栈元素小于栈顶元素
    特点是：
    入栈大数会消除栈内小数


### 典型代码：
```golang
stack := make([]int,0)
/**递增栈的入栈
* 用for 循环出栈，直到栈顶元素满足递增栈的要求
*/
for len(stack)> 0 && A[i] > stack[len(stack)-1]{
    // pop出栈内比 A[i]小但却在前面的元素
    stack = stack[:len(stack)-1]
}
stack = append(stack,A[i])

```
### 找到当前数字右边最小的对应数字
### 取k个字符，求字典序最小的组合
> 字典序：
> * 对单个元素按照ascii 表中大小顺序排列
> * 多个元素时，按照从左到右顺序，先从高位字典排序，然后在相同高位中按照地位再字典排序
### 给定一个数组，数组中元素代表模板的高度，请你求出相邻木板能剪出的最大矩形面积
> 和求最大容积是一个题目

<br />

## leetcode 题目汇总

> 以leetcode 题目为例子

相关栈的题目汇总：
[1][https://leetcode.cn/problem-list/xb9nqhhg/?topicSlugs=stack&page=1]
[2][https://leetcode.cn/problem-list/e8X3pBZi/?page=1&topicSlugs=heap-priority-queue]
[3][https://leetcode.cn/problem-list/2cktkvj/?page=1&topicSlugs=stack]


# 队列：FIFO 队列与单调队列的深挖与扩展

先进先出，是共同特征

类别上可以分出：
* FIFO队列
* 单调队列

## FIFO队列

**==Push 元素时候， 总是将放在元素放在队列尾部，也就是操作 fifo[len(fifo)-1]==**
**==Pop 元素时候，总是将队列首部的元素扔掉 ，也就是操作 fifo = fifo[1:]==**

###  二叉树的层次遍历（两种方法）

* 规律： 
广度遍历（层次遍历）：由于二叉树的特点，当拿到第N层的结点A之后，可以通过 A 的left，right指针拿到下一层的节点
**但是与A在同一层的节点还有其他吗，这个时候就需要按层来存储节点，不能直接使用递归**

    <br />
    顺序输出：每层输出时，排在左边的节点，它的子节点同样排在下一层的最左边

--> **==题目具备广度遍历（分层遍历）的特点 和 顺序输出的特点 ，应该想到应用FIFO队列==**

* 边界
  特殊判断： 如果发现是一棵空二叉树，就直接返回空结果
  ==制定一个规则==： 不要让空指针进入到FIFO队列（一些编程的亮点）

<font color = 'red'> 非常重要的概念： QSize 表示当前层数 </font>

#### 层次遍历二叉树
题目链接：https://leetcode.cn/problems/binary-tree-level-order-traversal/submissions/

##### 解题思路1
关键思路在于将每一层的节点都存在FIFO队列里面，在每次遍历的时候从左到右pop出该层的节点，同时在队尾加入他的左右孩子

队首pop出当层节点，队尾append下一层的孩子节点
QSize 记录当层的节点数量

时间复杂度是O(n), 空间复杂度由QSize决定O(K),K表示QSize最大，也就是存储的一层节点数量最多的时候

##### 代码
```golang
/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val int
 *     Left *TreeNode
 *     Right *TreeNode
 * }
 */
func levelOrder(root *TreeNode) [][]int {
    // 创建FIFO 队列来存储遍历的过程
    fifo := make([]*TreeNode,0)
    // QSize 表示当前遍历的层
    QSize := 1
    // 初始化最终结果
    result := make([][]int,0)
    if root == nil{
        return result
    }
    //将根节点入栈
    fifo = append(fifo,root)
    // 开始层序遍历，只要当前队列不为空
    for len(fifo) > 0 {
        // 创建结果数组用于存储当层pop出的元素值
        tmp := make([]int, 0)
        // 当层元素QSize全部遍历以此，这里不能用len(fifo)，因为fifo的长度是在变化的
        for i := QSize;i > 0;i--{
            // 拿出队列头元素
            node := fifo[0]
            // 判断他的左孩子是否为空
            if node.Left!= nil{
                fifo = append(fifo,node.Left)
            }
            // 判断他的右孩子是否为空
            if node.Right != nil{
                fifo = append(fifo,node.Right)
            }
            // 将该节点的值存入结果
            tmp = append(tmp,node.Val)
            // 推出队首元素
            fifo = fifo[1:]
        }
        // 将结果 tmp 存入到结果数组当中
        result = append(result,tmp)
        // 重新计算当前层的节点数量
        QSize = len(fifo)
    }
    return result
}
```
##### 官方题解
```golang
func levelOrder(root *TreeNode) [][]int {
    ret := [][]int{}
    if root == nil {
        return ret
    }
    q := []*TreeNode{root}
    for i := 0; len(q) > 0; i++ {
        ret = append(ret, []int{})
        p := []*TreeNode{}
        for j := 0; j < len(q); j++ {
            node := q[j]
            ret[i] = append(ret[i], node.Val)
            if node.Left != nil {
                p = append(p, node.Left)
            }
            if node.Right != nil {
                p = append(p, node.Right)
            }
        }
        q = p
    }
    return ret
}

```

##### 解题思路2

使用链表来解决问题

#### 锯齿状层次遍历
题目链接：https://leetcode.cn/problems/binary-tree-zigzag-level-order-traversal/

##### 解题思路
层次遍历的基础上加一个qs，表示当前层是从左到右还是从右到左

**==本题当中所犯的错误：==**：
* 每一轮都需要重新计算qsize,一定不要忘了这一点
* tmp 接收的时候还是按照栈的pop逻辑，所以顺序上还需要再反一次
* 题目样例当中root是按照从左到右遍历过一次来计算的

##### 代码

```golang
/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val int
 *     Left *TreeNode
 *     Right *TreeNode
 * }
 */
func zigzagLevelOrder(root *TreeNode) [][]int {
    //结果数组
    result := make([][]int,0)
    //全局的fifo队列
    fifo := make([]*TreeNode,0)
    // Qsize 表示当前层的节点数，qs 表示该层的遍历顺序，0表示从左到右，1表示从右到左
    Qsize ,qs := 1 , 1
    // 如果树中没有节点则直接返回
    if root == nil{
        return result
    }
    // 将 root 放入队列
    fifo = append(fifo,root)
    //遍历整棵树
    for len(fifo) > 0 {
        tmp := make([]int,0)
        for i:= 1; Qsize >= i && qs == 0 ;i++{
            node := fifo[Qsize-i]
            if node.Right != nil {
                fifo = append(fifo,node.Right)
            }
            if node.Left != nil{
                fifo = append(fifo,node.Left)
            }
            tmp = append(tmp,node.Val)                
        }
        for i:= 1; Qsize >= i && qs == 1 ;i++{
            node := fifo[Qsize-i]
            if node.Left != nil{
                fifo = append(fifo,node.Left)
            }
            if node.Right != nil{
                fifo = append(fifo,node.Right)
            }
            tmp = append(tmp,node.Val)                
        }
        fifo = fifo[Qsize:]
        Qsize = len(fifo)
        result = append(result,tmp)
        if qs == 1{
            qs = 0
        }else{
            qs = 1
        }
    }
    return result
}
```



#### 倒序层次遍历
题目链接：https://leetcode.cn/problems/binary-tree-level-order-traversal-ii/

##### 解题思路
从题目要求当中可以读出，是在之前的层序遍历基础上把结果倒过来输出，那么会比较自然想到可以在使用一个栈用来存储中间结果

##### 代码

```golang
/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val int
 *     Left *TreeNode
 *     Right *TreeNode
 * }
 */
func levelOrderBottom(root *TreeNode) [][]int {
    // 构造全局fifo队列
    fifo := make([]*TreeNode,0)
    // 构造结果栈
    stack := make([][]int,0)
    result := make([][]int,0)
    //表示当前层的节点数量
    Qsize := 1
    fifo = append(fifo,root)
    if root == nil{
        return result
    }
    for len(fifo) > 0{
        tmp := make([]int,0)
        for Qsize > 0{
            node:= fifo[0]
            if node.Left != nil{
                fifo =append(fifo,node.Left)
            }
            if node.Right != nil{
                fifo = append(fifo,node.Right)
            }
            Qsize--
            fifo = fifo[1:]
            tmp = append(tmp,node.Val)
        }
        stack = append(stack,tmp)
        Qsize = len(fifo)
    }

    // 将栈中元素pop 到结果当中
    for len(stack) > 0{
        result = append(result,stack[len(stack)-1])
        stack = stack[:len(stack)-1]
    }
    return result
}
```

## 循环队列

设计一个可以容纳 k 个元素的循环队列，需要实现以下接口：

```golang
type ringQueue interface{
    //构造函数，参数k表示这个循环队列最多容纳k个元素
    CircularQueue(int)
    //将value放到队列中，成功返回true
    EnQueue(int) bool
    // 删除队首元素，成功返回true
    DeQueue() bool
    // 得到队首元素，如果队列为空，返回-1
    Front() int
    // 得到队尾元素，如果队列为空，返回-1
    Rear() int
    // 查看循环队列是否为空
    isEmpty() bool
    // 查看队列是否已经放满k个元素
    isFull() bool
}
```

* **==循环队列的重点在于==: <font color = 'red'>循环使用固定空间</font>**
* **==难点在于==： <font color='red'>控制好 Front/Rear两个首位指示器</font>**

### 表示方法1
使用 `used`、`front`、`rear` 三个变量来控制，其中`used, front`都代表的是数组的下标

注意以下几点：
* index = i 的后一个是i+1，前一个是i+1
* index = k-1 的后一个就是index=0
* index = 0 的前一个是 index = k-1
**==可以使用取模的方式统一处理==:**
<font color='red'> index = i 的后一个元素下标是（i+1）% k</font>
<font color='red'> index = i 的前一个元素下标是（i-1+k）% k</font>
<font color='blue'>所有的循环数组下标的处理都需要按照这个取模的方式</font>

参考的实例代码如下：
```golang
type MyCircularQueue struct {
    queue  []int
    rear   int
    front  int
    used   int
    length int
}

func CircularQueue(k int) ringQueue {
    return &MyCircularQueue{
        queue:  make([]int, k),
        rear:   0,
        front:  0,
        used:   0,
        length: k,
    }
}

func (q *MyCircularQueue) EnQueue(value int) bool {
    if q.isFull() {
        return false 
    }
    q.queue[q.rear] = value
    q.rear = (q.rear + 1) % q.length
    q.used++
    return true
}

func (q *MyCircularQueue) DeQueue() bool {
    if q.isEmpty() {
        return false
    }
    q.front = (q.front + 1) % q.length
    q.used--
    return true
}

func (q *MyCircularQueue) Front() int {
    if q.used == 0 {
        return -1
    }
    return q.queue[q.front]
}

func (q *MyCircularQueue) Rear() int {
    if q.used == 0 {
        return -1
    }
    return q.queue[(q.rear-1+q.length)%q.length]
}

func (q *MyCircularQueue) isEmpty() bool {
    return q.used == 0
}

func (q *MyCircularQueue) isFull() bool {
    return q.used == q.length
}
```
备注：
在 `DeQueue()` 方法中，删除队首元素时并不会真的删除该元素，而是通过移动 `front` 指针来达到删除的效果。

循环队列是一个环状的数据结构，可以想象成沿着环形路径移动指针。在实现循环队列时，每当删除队首元素时，我们需要将 `front` 指针向前移一位，指向队列中的下一个元素，这样队列中原来的第二个元素就成为了新的头部元素。这里使用 "指向队列中的下一个元素" 实际上是模运算的作用，如 `(i+1) % n` 将会得到指向 `i` 在循环数组中下一个元素的索引值。

而在这个移动指针的过程中，由于队列的前面已经没有元素，所以我们不需要将队首元素真正地删除。相反，仅需要更新 `front` 指针，让它指向目前第一个元素，后面再添加新的元素，也会覆盖掉先前的元素，实现对队列的循环利用。

### 表示方法2
```golang
type MyCircularQueue struct {
    // 使用 k + 1 ，也就是多余一个空格的循环队列来设计
    queue []int
    front int
    rear int
    capacity int
}


func Constructor(k int) MyCircularQueue {
    return MyCircularQueue{
        queue: make([]int,k+1),
        front: 0,
        rear: 0,
        capacity: k+1,
    }
}


func (this *MyCircularQueue) EnQueue(value int) bool {
    if this.IsFull(){
        return false
    }
    this.queue[this.rear] = value
    this.rear = (this.rear + 1)%this.capacity
    return true
}


func (this *MyCircularQueue) DeQueue() bool {
    if this.IsEmpty(){
        return false
    }
    this.front = (this.front+1)%this.capacity
    return true
}


func (this *MyCircularQueue) Front() int {
    if this.IsEmpty() {
        return -1
    }
    return this.queue[this.front]
}


func (this *MyCircularQueue) Rear() int {
    if this.IsEmpty(){
        return -1
    }
    rearPosition := (this.rear-1+this.capacity)%this.capacity
    return this.queue[rearPosition]
}


func (this *MyCircularQueue) IsEmpty() bool {
    return this.rear ==this.front
}


func (this *MyCircularQueue) IsFull() bool {
    return (this.rear+1)%this.capacity == this.front
}

/**
 * Your MyCircularQueue object will be instantiated and called as such:
 * obj := Constructor(k);
 * param_1 := obj.EnQueue(value);
 * param_2 := obj.DeQueue();
 * param_3 := obj.Front();
 * param_4 := obj.Rear();
 * param_5 := obj.IsEmpty();
 * param_6 := obj.IsFull();
 */
```

### 循环双向队列

#### 解题思路


**==犯错的地方：==**
<font color='red'> InsertFront的时候，需要先移动front向前一位，然后再把值插进去</font>
最开始想的，直接让front和rear都指向一个空白的空间，那么就需要在插入的时候先将front向前移动两位，但这样的话就会浪费一个数值的空间，因为多余一个位就完全可以满足要求

使用k+1的情况，如果是在LRU缓存或者是Ringbuffer当中还需要考虑，将队尾[或者是队中]的元素插入到队首，也就是将最近使用的元素放到前面

#### 代码

```golang
type MyCircularDeque struct {
    queue []int
    front int
    rear int 
    capacity int
}


func Constructor(k int) MyCircularDeque {
    return MyCircularDeque{
        queue: make([]int,k+1),
        front: 0,
        rear: 0,
        capacity: k+1,
    }
}


func (this *MyCircularDeque) InsertFront(value int) bool {
    if this.IsFull(){
        return false
    }
    this.front = (this.front-1 + this.capacity)%this.capacity
    this.queue[this.front] = value
    return true
}


func (this *MyCircularDeque) InsertLast(value int) bool {
    if this.IsFull(){
        return false
    }
    this.queue[this.rear] = value
    this.rear = (this.rear+1)%this.capacity
    return true
}


func (this *MyCircularDeque) DeleteFront() bool {
    if this.IsEmpty(){
        return false
    }
    this.front = (this.front+1)%this.capacity
    return true
}


func (this *MyCircularDeque) DeleteLast() bool {
    if this.IsEmpty(){
        return false
    }
    this.rear = (this.rear-1+this.capacity)%this.capacity
    return true
}


func (this *MyCircularDeque) GetFront() int {
    if this.IsEmpty(){
        return -1
    }
    return this.queue[this.front]
}


func (this *MyCircularDeque) GetRear() int {
    if this.IsEmpty(){
        return -1
    }
    return this.queue[(this.rear-1+this.capacity)%this.capacity]
}


func (this *MyCircularDeque) IsEmpty() bool {
    return this.front == this.rear
}


func (this *MyCircularDeque) IsFull() bool {
    return this.front == (this.rear+1)%this.capacity
}


/**
 * Your MyCircularDeque object will be instantiated and called as such:
 * obj := Constructor(k);
 * param_1 := obj.InsertFront(value);
 * param_2 := obj.InsertLast(value);
 * param_3 := obj.DeleteFront();
 * param_4 := obj.DeleteLast();
 * param_5 := obj.GetFront();
 * param_6 := obj.GetRear();
 * param_7 := obj.IsEmpty();
 * param_8 := obj.IsFull();
 */
```

相似点：
* 都使用了取模的方式

## 单调队列
单调队列属于双端队列的一种

要求队列中的元素必须满足单调性

单调队列如对时候的要求：入队前后，单调性完整

**==单调递减队列最重要的特性==:<font color='red'>入队和出队的组合，可以在O(1)时间得到某个区间上的最大值</font>**

### 情况讨论
> 需要回答的问题：
> * 这个区间是什么
> * 怎样定量地描述这个区间
> * 与队列中的元素个数有什么关系
可以分以下两种情况来讨论：
1. 只有入队的情况
   在没有出队的情况下，对原数组的比较范围就会逐步增加
   队首元素表示是已比较范围内的最大值
2. 出队和入队混合的情况
   控制覆盖范围为 k --> 滑动窗口
    * 入队： 扩展单调队列的覆盖范围
    * 出队： 控制单调队列的覆盖范围
    * 队首元素是覆盖范围的最大值
    * 队列中的元素个数小于覆盖范围的元素个数

### 核心代码
```golang
//入队的代码
func (q *queue)push(val int){
    // 入队时候，要剔除掉尾部的元素，知道尾部元素大于或者是等于入队元素
    while(!q.isEmpty() && q.getLast()<val){
        q.removeLast()
    }
    // 将元素入队
    q.addLast(val)
}

// 出队的时候，需要给出一个value
func(q *queue) pop(val int){
    if(!q.isEmpty() && q.getFirst()==val){
        q.removeFirst()
    }
}
```
这样的代码编写关键：
* 队首元素q.getFirst() 所获取的值是队列中的最大值
* 出队时
  * 如果一个元素已经被其他元素剔除出去了，那么他就不会再入队
  * 如果一个元素是当前队列的最大值，会再出队

### 滑动窗口的最大值


### 捡金币游戏

> 考点:
> * 找到get数组，并知道get数组是当前元素和滑动窗口中最大值的和计算而来
> * 利用单调队列在get[]数组上操作，找到滑动窗口的最大值

拓展： 是否存在不同的出队方式

> 整理一下代码模板：
> <font color = 'red'>分层遍历</font>
> <font color = 'red'>循环队列</font>
> <font color = 'red'>单调队列</font>

一些有意思的题目：
* 利用栈实现一个队列
* 利用队列实现一个栈


# 优先级队列：堆与优先级队列，筛选最优元素

## 堆
 FIFO队列： 节点之间的优先级是由遍历时的顺序决定的
 优先级队列： 节点之间按照大小进行排序后，再决定优先级，底层依赖的数据结构一般是堆

#### 堆的分类

1. 大根堆
   节点的值比他的孩子节点都大

2. 小根堆
   节点的值要比他的孩子节点都小
堆的特点--大堆的根是最大值，小堆的根是最小值


#### 堆的实现
> 以大堆为例子

大多数时候都是使用数组来表示堆
``` golang
type Heap struct {
    data []int
}

// 创建新的大根堆
func NewHeap() Heap {
    return Heap{
        data: make([]int, 0),
    }
}

// 获取大根堆的长度
func (h *Heap) Len() int {
    return len(h.data)
}

// 获取指定位置元素的父节点位置
func parent(i int) int {
    return (i - 1) / 2
}

// 获取指定位置元素的左子节点位置
func leftChild(i int) int {
    return i*2 + 1
}

// 获取指定位置元素的右子节点位置
func rightChild(i int) int {
    return i*2 + 2
}

// 下沉操作，将指定位置的元素向下移动，直到它大于所有子节点为止
func (h *Heap) sink(i int) {
    for {
        left, right := leftChild(i), rightChild(i)
        maxPos := i
        if left < h.Len() && h.data[left] > h.data[maxPos] {
            maxPos = left
        }
        if right < h.Len() && h.data[right] > h.data[maxPos] {
            maxPos = right
        }
        if maxPos == i {
            break
        }
        h.data[i], h.data[maxPos] = h.data[maxPos], h.data[i]
        i = maxPos
    }
}

// 上浮操作，将指定位置的元素向上移动，直到它小于其父节点为止
func (h *Heap) swim(i int) {
    for i > 0 {
        p := parent(i)
        if h.data[p] >= h.data[i] {
            break
        }
        h.data[p], h.data[i] = h.data[i], h.data[p]
        i = p
    }
}

// 出堆，弹出大根堆的堆顶元素，并重新调整堆结构
func (h *Heap) pop() int {
    res := h.data[0]
    h.data[0] = h.data[len(h.data)-1]
    h.data = h.data[:len(h.data)-1]
    h.sink(0)
    return res
}

// 入堆，将新元素插入到大根堆中，并重新调整堆结构
func (h *Heap) push(val int) {
    h.data = append(h.data, val)
    h.swim(len(h.data) - 1)
}

```

#### 最小的k个数
> N 的数量级非常大，或者其希望能够获得一个较小的区间内的数字
> 同时输出的操作是每时每刻的话，一直是用排序的代价就会很高
在上述大根堆的基础上来完成的话，就是以下代码：

```golang
func getLeastNumbers(arr []int, k int) []int {
    // 建立大根堆
    minH := Heap{}
    for i:=0; i < len(arr); i++{
        minH.push(arr[i])
        if len(minH.data) > k {
            minH.pop()
        }
    }
    return minH.data
}
```

## 优先级队列               

#### google 面试题目：有一台机器会每隔一秒输出一个信号，请在每次输出信号的时候输出所有信号的中间值，如果信号数量位偶数则返回中间两数的平均值
题目连接：
> leetcode 这道题目还能够用排序是因为算的是所有一共的，如果是实时输出就每次都需要排序，所以直接维护一个结构更适合


# 链表： 如何利用"假头，新链表，双指针"解决链表类型题目
> 解决链表问题的三板斧：
> 假头
> 新链表
> 双指针
> 链表尤其需要考虑各种边界条件、链表结构简单，但是查找交换反转非常容易出错
>

### 三板斧

#### 假头
在链表前面增加额外的节点--> 可以节省许多对于nil指针的操作，能够节省不少的精力

dummy 指针初始化之后就不会再发生改变了
tail  指针随着元素改变移动

1. tail 插入节点
2. 头部插入节点
3. 查找结点（总是会查找目标节点的pre）
4. 在指定位置插入节点--> getPre
5. 删除节点
```golang
type linkList interface{
    initDummyList()
    appendNode(*interface{})bool
    getPre(int)*interface{}
    findNode(int) *interface{}
    insertNode(*interface{})bool
    deletNode(int) bool
}
```


# 树： 如何深度运用树的遍历
> 大部分语言的map数据结构，基本上是基于树来实现的
b+树，红黑树，二叉树等等，在leetcode和考题当中常见二叉树，同时对于其他的树结构，可以通过二叉树的遍历来扩展出对应的遍历方式。


## **1** &ensp; 树节点的结构：

```golang
type TreeNode struct{
    val int
    left *TreeNode
    right *TreeNode
}
```
## **2** &ensp; 前序遍历
> <font color='red'>遍历根节点、左子树、右子树</font>

### **2.1** &ensp; 使用递归完成前序遍历
采用整体的思想：
首先遍历根节点，然后遍历左子树的时候，就把左子树放到相应的位置，遍历右子树的时候，就把右子树放到相应的位置。
然后展开左子树
然后展开右子树

> 时间复杂度：O(N)
> 空间复杂度：O(K) K表示的树的高度
<font color=CC6699>一定注意要问清楚:在访问每个节点的时候，是需要Print出来，还是放到一个链表/数组当中存储</font>

``` Golang
//使用递归方式
func traverse(root *TreeNode){
    if root == nil {
        return 
    }
    traverse(root.Left)
    traverse(root.Right)
}
```

### **2.2** &ensp; 使用栈完成前序遍历
``` golang
package main

import "fmt"

type TreeNode struct {
    Val   int
    Left  *TreeNode
    Right *TreeNode
}

// 前序遍历
func preorderTraversal(root *TreeNode) []int {
    if root == nil {
        return []int{}
    }

    var res []int
    var stack []*TreeNode
    stack = append(stack, root)

    for len(stack) > 0 {
        node := stack[len(stack)-1]
        stack = stack[:len(stack)-1]
        res = append(res, node.Val)
        if node.Right != nil {
            stack = append(stack, node.Right)
        }
        if node.Left != nil {
            stack = append(stack, node.Left)
        }
    }

    return res
}

```

### **2.2-1** &ensp; Morris 遍历: 只需要O(1)的空间


### **2.3** &ensp; 题目
下述为前序遍历常见题目

#### **2.3.1** 验证二叉树
验证一颗二叉树是否满足二叉搜索树的性质

```golang
type basic struct{
    node *TreeNode
    leftboard int
    rightboard int
} 

func stackBst(root *TreeNode) bool{
    // 构造边界影子树栈
    stack := make([]basic,0)
    left, right := math.MinInt64,math.MaxInt64
    for root != nil || len(stack) > 0{
        // 当还没有遍历完左子树
        for root != nil{
            // 判断不满足搜索树的节点要求
            if root.Val <= left || root.Val >= right {
                return false
            }
            // 满足范围要求，那就要往下继续找
            // 先记录当前影子树的边界
            stack = append(stack, basic{
                node: root,
                leftboard: left,
                rightboard: right,
            })
            // 往下移动，同时缩小右边界
            right = root.Val
            root = root.Left
        }
        // 左子树遍历完了，找右子树
        top := stack[len(stack)-1]
        stack = stack[:len(stack)-1]

        // 关键就是这里需要重新赋值比较的left和right
        root = top.node
        left,right = top.leftboard,top.rightboard
        left = root.Val
        root = root.Right       
    }
    return true
}

func isValidBST(root *TreeNode) bool {
    return stackBst(root)
}
```
或者是使用递归的方式
```golang
func isValidBST(root *TreeNode) bool {
    ans := true
    ans = preOderBST(root,math.MinInt64,math.MaxInt64)
    return ans
}
func preOderBST(root *TreeNode, left int, right int)bool{
	if root == nil {
		return true
	}
	if root.Val <= left || root.Val >= right {
		return false
	}
	return preOderBST(root.Left,left,root.Val) && preOderBST(root.Right,root.Val,right)
}
// // 特殊在于 golang 的特点： 传参如果要一直修改其中的值，就需要传入一个引用，或者是采用闭包的方式
// func preOderBST(root *TreeNode, left int, right int, ans *bool){
// 	// 递归是否达到条件，即到达叶节点，到达叶节点表示所有节点都满足情况，所以为true
// 	// 第二个条件是 是否有判断出不满足的树，有的话ans就会变成false,直接返回
// 	if root == nil || !(*ans) {
// 		return
// 	}
// 	// 判断条件就是 当前的值要小于right同时大于left才满足
// 	if root.Val <= left || root.Val >= right {
// 		*ans = false
// 		return
// 	}
// 	// 前序遍历
// 	preOderBST(root.Left, left, root.Val, ans)
// 	preOderBST(root.Right, root.Val, right, ans)
// }
```

#### **2.3.2** 目标和的所有路径
https://leetcode.cn/problems/path-sum/
> 二叉树进行回溯的代码模板
> * 遇到新的节点： 路径总是从尾部添加节点
> * 遍历完节点，路径就把他从尾部扔掉
```golang
// func hasPathSum(root *TreeNode, targetSum int) bool {
    
//     var backTrace func(*TreeNode, int) bool
//     backTrace = func(root *TreeNode, Sum int)bool{
//         left , right := false,false 

//         if root == nil {
//             return false
//         }
//         Sum += root.Val
//         if root.Left == nil && root.Right == nil && Sum == targetSum {
//             return true
//         }
//         if root.Left != nil{
//             left = backTrace(root.Left,Sum)
//         }
//         if root.Right != nil{
//             right = backTrace(root.Right,Sum)
//         }
//         return left || right
//     }
//     return backTrace(root,0)
// }

// // 使用广度优先的遍历--层序遍历--队列
// func hasPathSum(root *TreeNode, targetSum int) bool {
//     if root == nil{
//         return false
//     }
//     fifo := make([]*TreeNode,0)
//     Qsize := 1
//     fifo = append(fifo,root)

//     for len(fifo) > 0 {
//         for Qsize > 0 {
//             top := fifo[0]
//             if top.Left == nil && top.Right == nil && top.Val == targetSum{
//                 return true
//             }
//             if top.Left != nil{
//                 top.Left.Val = top.Left.Val + top.Val
//                 fifo = append(fifo,top.Left)
//             }
//             if top.Right != nil{
//                 top.Right.Val = top.Right.Val + top.Val
//                 fifo = append(fifo,top.Right)
//             }
//             fifo = fifo[1:]
//             Qsize -= 1
//         }
//         Qsize = len(fifo)
//     }
//     return false
// }

// 使用栈来存储，栈中元素是当前树的路径
type path struct{
    node *TreeNode
    sum int
}

func hasPathSum(root *TreeNode, targetSum int) bool {
    if root == nil {
        return false
    }
    paths := make([]path,0)
    paths = append(paths, path{
        node: root,
        sum: root.Val,
    })
    for len(paths) > 0 {
        node := paths[len(paths)-1]
        paths = paths[:len(paths)-1]
        if node.node.Left == nil && node.node.Right == nil && node.sum == targetSum {
            return true
        }
        if node.node.Right != nil {
            right := node.node.Right
            paths = append(paths,path{
                node: right,
                sum: right.Val + node.sum,
            })
        }
        if node.node.Left != nil {
            left := node.node.Left
            paths = append(paths,path{
                node: left,
                sum: left.Val + node.sum,
            })
        }
    } 
    return false
}
```

#### **2.3.3** 得到路径和为指定数字的路径集合
https://leetcode.cn/problems/path-sum-ii/solution/
<font color='red'> 这道题目非常重要：有两大问题都在这个地方表现出来了</font>

==Golang的特性：Defer函数的使用==
这道题目在使用前序遍历的时候，由于在叶子节点以及从左子树转换为右子树的时候都需要将原本记录在path当中的路径节点删除pop出来，递归时候就需要考虑在什么时候执行出栈操作，没错即便是在递归当中也还是必须要考虑栈的操作，因为需要一个连续记录的路径信息

关键在于pop的时机：pop的时机是：1. 本身是叶子节点，直接return 结束dfs，2. 左右的子树都被递归判断过的树中结点，也就是dfs(Left),dfs(Right)正常结束，刚好发现二者均都是在dfs执行完之后执行，而且覆盖了dfs执行完之后所有的情况
同时 Golang 的 **Defer(){}** 会在函数执行完并在返回之前执行，完全满足这个场景的需求，所以可以在递归函数体当中使用defer来完成对应的操作

==Golang的特性：切片索引==
切片本身就是指针，且每次操作都会影响到底层数组
如果不在递归函数体当中使用切片之前重新对切片进行赋值，那么，之后对于底层数组的操作也会反映到之前的切片上，产生的效果就是明明原本计算好了结果但最后得到的并不是正确答案，关键就在于==后面切片的操作修改了底层数组，导致原本切片对应的结果被修改了==

```golang
func pathSum(root *TreeNode, targetSum int) [][]int {
    result := make([][]int,0)
    path := make([]int,0)
    if root == nil {
        return result
    }
    var dfs func(*TreeNode,int)
    dfs = func(root *TreeNode,left int){
        if root == nil{
            return 
        }
        path = append(path,root.Val)
        left = left - root.Val
        defer func() { 
            path = path[:len(path)-1]
        }()
        if root.Left == nil && root.Right == nil && left == 0{
            // new := make([]int,len(path))
            // copy(new,path)
            // result = append(result,new)
            result = append(result,append([]int(nil),path...))
            return 
        }
        dfs(root.Left,left)
        dfs(root.Right,left)
    }
    dfs(root,targetSum)
    return result
}
```

#### **2.3.3** 
> 等待回溯来看
> https://leetcode.cn/problems/path-sum-iii/solution/437-lu-jing-zong-he-iii-dfshui-su-qian-zhui-he-yi-/


## **3** 中序遍历
<font color='red'>遍历左子树，然后是根节点，然后是右子树</font>

### **3.1** &ensp; 使用递归完成中序遍历
``` golang

```

### **3.2** &ensp; 使用栈完成中序遍历
```golang
func inorderTraversal(root *TreeNode) []int {
    if root == nil {
        return []int{}
    }

    var res []int
    var stack []*TreeNode
    var pathStack []string
    node := root

    for node != nil || len(stack) > 0 {
        if node != nil {
            stack = append(stack, node)
            pathStack = append(pathStack, fmt.Sprintf("%d", node.Val))
            node = node.Left
        } else {
            node = stack[len(stack)-1]
            stack = stack[:len(stack)-1]
            path := pathStack[len(pathStack)-1]
            pathStack = pathStack[:len(pathStack)-1]

            if node.Left == nil && node.Right == nil {
                res = append(res, node.Val)

                // 输出到达叶子节点的路径
                fmt.Println(path)
            }

            node = node.Right
        }
    }

    return res
}
```

### **3.3** 找出二叉搜索树里面出现次数最多的数
找众数就需要遍历所有的节点，二叉搜索树中序遍历的结果会是一个递增的数组，其数据特性就在于使用中序遍历的时候，所有的元素都是连续的
``` golang
/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val int
 *     Left *TreeNode
 *     Right *TreeNode
 * }
 */
func findMode(root *TreeNode) []int {
    // 结果数组
    ans := make([]int,0)
    base,count,maxnum := math.MinInt64,0,0

    // 使用递归的方式
    var dfs func(*TreeNode)
    dfs = func(root *TreeNode){
        if root == nil {
            return 
        }
        dfs(root.Left)
        if root.Val == base {
            count++
        }else{
            base = root.Val
            count = 1
        }
        if count == maxnum {
            ans = append(ans,base)
        }
        if count > maxnum {
            ans = []int{}
            maxnum = count
            ans = append(ans,base)
        }
        dfs(root.Right)
    }
    dfs(root)
    return ans
}
```

### **3.4** 找出二叉搜索树里面任意两个节点之间绝对值得最小值

https://leetcode.cn/problems/minimum-distance-between-bst-nodes/

```golang
func minDiffInBST(root *TreeNode) int {
    // 使用栈来中序遍历，栈顶元素就是上一遍历的节点元素
    stack := make([]*TreeNode,0)
    res := make([]int,0)
    for root != nil || len(stack) > 0{
        for root != nil {
            stack = append(stack,root)
            root = root.Left
        }

        node := stack[len(stack)-1]
        stack = stack[:len(stack)-1]
        res = append(res,node.Val)

        root = node
        root = root.Right
    }
    m := math.MaxInt64
    for i:= 0; i < len(res)-1; i++{
        r := res[i+1]-res[i]
        m = min(m,r) 
    } 
    return m
}

func min(args ...int)int{
    min := args[0]
    for _, val := range args{
        if val < min {
            min = val
        }
    }
    return min
}
```

### **3.5** 一棵二叉搜索树的两个节点被交换了，恢复这颗二叉搜索树

```golang
func recoverTree(root *TreeNode)  {
    // 使用递归解决这个问题
    problem := make([]*TreeNode,0)
    var findP func(*TreeNode)
    findP = func(root *TreeNode){
        if root == nil{
            return 
        }
        findP(root.Left)
        // if pre == math.MaxInt64{
        //     pre = root.Val
        //     return
        // }
        // if root.Val - pre < 0{
        //     problem = append(problem,root)
        // }
        // pre = root.Val
        problem = append(problem, root)
        findP(root.Right)
    }
    findP(root)
    pre,cur := -1,-1
    for i := 0; i < len(problem)-1; i++{
        if problem[i].Val > problem[i+1].Val {
            cur = i + 1
            if pre == -1 {
                pre = i
            }
        }
    }
    problem[pre].Val,problem[cur].Val = problem[cur].Val,problem[pre].Val
    return 
}
```

### 删除二叉搜索树的节点
> 题目最重要的考点就是分类，讨论各种情况下的处理方式

<font sizecolor ='red'>清晰地讲出每种情况的处理办法</font>
<font sizecolor ='red'>清晰简介地实现代码</font>




## 后序遍历

### 使用栈完成后序遍历

### 迭代写法的考点
1. 是否有右子树
2. pre指针是不是指向当前结点的右子树