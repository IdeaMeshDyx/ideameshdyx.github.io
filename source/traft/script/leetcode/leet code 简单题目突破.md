---
title: Golang 算法课程--算法
catalog: true
date: 2023-04-05 00:46:21
subtitle:
header-img:
tags: working, 算法
categories: 算法，Golang
---

> 考前简单题目遍历：



### [双边判断 - 最后一个单词的长度 - 力扣（LeetCode）](https://leetcode.cn/problems/length-of-last-word/solution/shuang-bian-pan-duan-by-xing-82s-xing/)

- 下标 < 0 或者是 下标 > 数组长度-1的情况都需要考虑
- for 循环要善用，一般的结构组成就是 for{if{}}

```go
func lengthOfLastWord(s string) int {
    if len(s) == 1 && s[0] == ' ' {
        return 0
    }
    // 计算下标--双指针
    l := len(s)
    left, right := l-1,l-1
    // 找到末尾第一个非空字符
    for i := l-1 ; s[i] == ' '; i--{
        right--
    }
    // 找到末尾第二轮开始空的字符
    left = right
    for i := right ; s[i] != ' '; i--{
        left--
        if left < 0{
            break
        }
    }
    return right - left
}
```



### [使用数组按位 - 二进制求和 - 力扣（LeetCode）](https://leetcode.cn/problems/add-binary/solution/shi-yong-shu-zu-an-wei-by-xing-82s-ris9/)

本题目是位计算和字符串转数值计算的典型例子：
仅针对字符串的处理有几点需要格外关注：

string 转 int 按位处理需要借助 byte (当然也可以直接使用strconv.ParseInt(a,2,64),但这样就需要考虑符号位以及其他的因素了)
string 的 a[i] ，所获取的值是 byte 类型（补充如果是一整个string转化位 []byte，如果含有中文使用[]rune）
得到第 i 位的十进制表示的二进制数方式是： i := int(a[i]-'0')
字符串的 + 存在先后顺序；换句话说 i+j 与 j+i所获得字符串不相同是ij,ji,这里的注意点是字符串计算不再使用栈来规划顺序，可以直接使用符号位置来表示
carry 同时表示了进位和当前位的结果值，这个特点是在位运算当中常见，需要记忆模板，其他题目的类型按照结果归纳，需要归类
这里需要计算对齐的是两数的末位，所以需要计算的下标为la-i-1

```go
func addBinary(a string, b string) string {
    //  按位计算并保存一个进位的结果
    //  1. string 按位计算不能够一步到位直接转化为int，需要借助中间值byte
    //  2. 优化逻辑：O(n)的复杂度，遍历的时间复杂度取决于 最长的字符串的长度
    la,lb := len(a),len(b)
    l := maxi(la,lb)
    res := ""
    carry:= 0
    for i := 0; i < l; i++{
        if i < la {
            carry += int(a[la-i-1]-'0')
        }
        if i < lb {
            carry += int(b[lb-i-1]-'0')
        }
        res = strconv.Itoa(carry%2) + res
        carry /= 2
    }
    if carry > 0 {
        res = "1" + res
    }
    return res
}
```



### [字符串转数字比较 - 重复的DNA序列 - 力扣（LeetCode）](https://leetcode.cn/problems/repeated-dna-sequences/solution/zi-fu-chuan-zhuan-shu-zi-bi-jiao-by-xing-lye5/)

```go
const L = 10
var bmap = map[byte]int{'A':0,'C':1,'G':2,'T':3}

func findRepeatedDnaSequences(s string) (ans []string) {
    // 滑动窗口
    // 需要对边界条件 n 小于窗口大小时候判断,当等于窗口大小的时候，也不满足条件，一定要注意等号的边界条件
    if len(s) <= L {
        return 
    }
    win := 0
    // 初始化窗口，将 L 个字符统计出来
    // 注意点1： string 单取是byte类型,而map 当中所存的应该也是单个字符byte
    // 注意点2： for  range 遍历的时候，并不需要控制中间的i对象，所以可以直接用迭代的 v
    // 注意点3： 这里的初始化只需要将首先的10个数字包含进来就可以
    for _, v := range s[:L-1] {
        win = (win<<2) | bmap[byte(v)]
    }

    res := make(map[int]int,0)
    // 选择低位作为开始是为了解决切片的问题，这样加入到结果的字符串当中，只需要操作 s[i:i+L]
    for i := 0; i <= len(s)-L;i++{
        win = ((win<<2) | bmap[s[i+L-1]]) & ((1<<20)-1)
        res[win]++
        // 这个地方只能判断为 2 但不能够是其他的情况，因为出现多次，只需要大于2就满足条件了，但是这个循环会把大于1的字符串每次都加在结果数组当中一次，这样结果当中就会存在非常多的重复的字符串了
        if res[win] == 2  {
            ans = append(ans,s[i:i+L])
        }
    }
    return ans
}
```



### [二分法解决这道题目 - x 的平方根 - 力扣（LeetCode）](https://leetcode.cn/problems/sqrtx/solution/er-fen-fa-jie-jue-zhe-dao-ti-mu-by-xing-pq1tt/)

这道题目是用二分法来找到一个近似的大致解，逻辑是二分搜索小于 x 区间上的数，数理逻辑是简单的，因为他的根肯定比他自己小等，且把问题只求整数区间的答案，是完全有限的

问题在于二分法的边界问题：

题目的二分区间是 左右均闭区间，所以循环结束条件是二者相相遇时候，而移动指针，则因为判断不满足条件时候要抛弃边界值，所以左右指针都会在mid基础上改变，模板为：

    for left <= right {
        mid = left + (right-left)/2
        ValueOfMid = func(mid)
        if ValueOfMid <= target{
            res = mid//  因为这里判断的结果边界就是所需要的答案
            left = mid + 1 // 左闭区间，如果 mid 不是所求答案，则必然小于答案，直接抛弃mid值
        }else{
            right = mid - 1 // 右闭区间
        }
}
我做了改动，使其变成 左闭右开区间，但这可情况下忽略了 right == left 以及二者相差为1时候的情况，所以在前面补全，但是这并不意味着这个判断就不好，由于左闭右开，所以右边实际上一直指向的是一个空值（逻辑上），在判断条件最后相遇的情况下，可以明确的就是答案一定不会在 [right, x-1]这个区间范围内，所以查找的循环只会在 left < right；如果二者相遇还没找到答案，那么就代表不存在解。

```go
func mySqrt(x int) int {
    // 使用二分法来解决
    left,right := 0,x
    ans := -1
    if right - left <= 1 {
        return x
    }
    for left < right {
        mid := left + (right - left)/2
        if mid*mid <= x {
            ans = mid
            left = mid + 1
        }else{
            right = mid
        }
    }
    return ans
}
```



### [70. 爬楼梯 - 力扣（LeetCode）](https://leetcode.cn/problems/climbing-stairs/submissions/)

![image-20230506104126885](Y:\Blog\blog\source\_posts\Algorithm\leetcode\leet_simple_70.png)

```go
func climbStairs(n int) int {
    // 使用回溯法来解决这个问题
    // 但是递归回溯存在大量的重复判断排列组合的部分
    // res := 0
    // var stepin func(left int)
    // stepin = func(left int){
    //     if left < 0 {
    //         return 
    //     }
    //     if left == 0 {
    //         res++
    //     }
    //     stepin(left-1)
    //     stepin(left-2)
    // }
    // stepin(n)
    // return res
    // 动态规划
    // dp := make([]int,n+1)
    // dp[0],dp[1] = 1,1
    // for i := 2; i <= n; i++{
    //     dp[i] = dp[i-1]+dp[i-2]
    // }
    // return dp[n]
    // 优化内存的表现
    pre, cur ,tmp := 1,1,0
    for i := 0; i < n; i++{
        tmp = pre + cur
        pre = cur
        cur = tmp
    }
    return pre
}
```



### [合并两个有序数组 - 合并两个有序数组 - 力扣（LeetCode）](https://leetcode.cn/problems/merge-sorted-array/solution/he-bing-liang-ge-you-xu-shu-zu-by-leetco-rrb0/)

使用双指针的时候，因为创建了新的数组，而返回值使原本的数组切片指针，这个时候要么再来一个for循环修改原num1的底层数组，要么只能深拷贝 copy(nums1,sorted)

```go
func merge(nums1 []int, m int, nums2 []int, n int) {
    sorted := make([]int, 0, m+n)
    p1, p2 := 0, 0
    // 使用双指针分别指向此时对应的最小值
    for {
        // 这两个if的判断很典型，当双指针有其中一个到达了边界，证明对方为空
        // 将长的数组剩余全部加入
        // 使用方法是append(sorted,num[p2:]...)
        // 需要记住这个一次性加入多个切片的操作写法:append(target, n[]...)
        if p1 == m {
            sorted = append(sorted, nums2[p2:]...)
            break
        }
        if p2 == n {
            sorted = append(sorted, nums1[p1:]...)
            break
        }
        if nums1[p1] < nums2[p2] {
            sorted = append(sorted, nums1[p1])
            p1++
        } else {
            sorted = append(sorted, nums2[p2])
            p2++
        }
    }
    // 对底层数组的修改，需要尤为注意
    // 只有 copy会把底层数组的值给复制过去，其他使用 = 的情况只是切片对象，也就是一个指针，如果底层数组改变了，那么结果也就改变了
    copy(nums1, sorted)
}
```



### [ 二叉树的最大深度 - 力扣（LeetCode）](https://leetcode.cn/problems/maximum-depth-of-binary-tree/solution/ke-yi-shi-xiao-gai-goyu-yan-zhu-xing-zhu-q5a0/)

```go
/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val int
 *     Left *TreeNode
 *     Right *TreeNode
 * }
 */
func maxDepth(root *TreeNode) int {
  	//根节点为空，最大深度返回0 
    if root == nil {
		return 0
	}
    //记录左子树的最大深度
	leftMax := maxDepth(root.Left)
    //记录有右子树的最大深度
	rightMax := maxDepth(root.Right)
    //最终的深度=左子树和右子树的max，然就再加上根节点还有的1,
	height := 1 + max(leftMax, rightMax)
	return height
}

func max(a,b int)int {
    if a>b {
        return a
    }
    return b 
}
```



### [将有序数组转换为二叉搜索树 - 力扣（LeetCode）](https://leetcode.cn/problems/convert-sorted-array-to-binary-search-tree/solution/tu-jie-er-cha-sou-suo-shu-gou-zao-di-gui-python-go/)

构造树，不论顺序如何，必定是存在着 `node := &TreeNode{val, getTree(right/left), getTree(right/left) }`  , 先得把节点构造出来作为根节点，然后再去遍历找其他的节点

```go
/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val int
 *     Left *TreeNode
 *     Right *TreeNode
 * }
 */
func sortedArrayToBST(nums []int) *TreeNode {
    if len(nums) == 0 {
        return nil
    }

    mid := len(nums) / 2
    
    left := nums[:mid]
    right := nums[mid+1:]
    // 这个递归的设计非常优美，递归的核心是构造了mid值得根节点，然后继续递归传入左右的切片
    node := &TreeNode{nums[mid], sortedArrayToBST(left), sortedArrayToBST(right)}

    return node
}
```



### [ 二叉树的最小深度 - 力扣（LeetCode）](https://leetcode.cn/problems/minimum-depth-of-binary-tree/solution/ke-yi-shi-xiao-gai-goyu-yan-zhu-xing-zhu-q9ed/)

出现特殊情况是因为最小深度，会计算到有一个子树为空的情况，但是另一个子树不一定为空，那么其根节点就不是叶子节点

```go
/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val int
 *     Left *TreeNode
 *     Right *TreeNode
 * }
 */
 
//tips:利用左右根（后续遍历） 求出的最小高度，也是这棵树的最小深度
func minDepth(root *TreeNode) int {
	if root == nil {
		return 0
	}
	//先求出左右子树的最小深度
	leftMin := minDepth(root.Left)
	rightMin := minDepth(root.Right)

	/*
		1.但是要考虑特殊情况，根节点的左子树为空，右子树不为空，
        不能直接min(root.Left,root.Right)，
		2.因为不符合题目“根节点到最近叶子节点的最短路径上的节点数量”
        的要求一定要有叶子节点
	*/
	if root.Left == nil && root.Right != nil {
		return 1 + rightMin
		//如上
	} else if root.Left != nil && root.Right == nil {
		return 1 + leftMin
		//如果左右子树都不为空才能用min
	} else {
		return 1 + min(leftMin, rightMin)
	}
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}
```



### [118. 杨辉三角 - 力扣（LeetCode）](https://leetcode.cn/problems/pascals-triangle/submissions/)

使用 dp 解题,核心在于杨辉三角的计算过程符合 dp 的问题拆解

```go
func generate(numRows int) [][]int {
    // dp 模板1： 创建dp数组一维或者是二维
    dp := make([][]int, numRows)
	if numRows == 0 {
		return dp
	}
    // dp 数组的初始化，一般来说需要在纸上把这个dp数组画出来，然后观察数组的规律，将那些dp[][]边界值给计算出来
    
	for k := range dp {
		dp[k] = make([]int, k+1)
	}
	for i := 0; i < numRows; i++ {
		for j := 0; j < i+1; j++ {
			if j == 0 || j == i {
				dp[i][j] = 1
			} else {
				dp[i][j] = dp[i-1][j] + dp[i-1][j-1]
			}
		}
	}
	return dp
}
```



### [单调栈，贪心算法，最简单的思路，找到最小值，找到其后最大值，两个相减即可得 - 买卖股票的最佳时机 - 力扣（LeetCode）](https://leetcode.cn/problems/best-time-to-buy-and-sell-stock/solution/-by-gracious-vvilson1bb-w8yb/)

关键常数，直接背住：

```go
	maxs :=math.MinInt64
	mins :=math.MaxInt64
```

单调栈来一次 O(n^2)遍历一次找到所有的元素向右间距，比较出最大值就可以

题目做了优化，考虑贪心的方法

```go
func maxProfit(prices []int) (s int) {
	maxs :=math.MinInt64
	mins :=math.MaxInt64
	for i := 0; i < len(prices); i++ {
        // 由于 max 总是在已有的 mins 基础上来计算，相当于这个问题就变成了
        // 遍历先找当前最小的元素
        // 再计算当前元素比之前最小元素大的间距
        // 因为本体的大小关系只局限在数组元素的大小，而不考虑数组下标的间距，所以可以直接寻找最优解
		//记一个最小值
		mins =min(mins,prices[i])
		//记一个最大值
		maxs =max(maxs,prices[i]-mins)

	}
	//返回最大差值
	return maxs
}

func max(x, y int) int {
	if x > y {
		return x
	} else {
		return y
	}
}
func min(x, y int) int {
	if x > y {
		return y
	} else {
		return x
	}
}
```



### [dp-丑数 II - 丑数 II - 力扣（LeetCode）](https://leetcode.cn/problems/ugly-number-ii/solution/chou-shu-ii-by-beney-2-0uk5/)

关键点1 ： 求因数的计算常规是：

```go
%n == 0 表示n是他的因数
```

关键点2：第 n  个丑数是前面 某个丑数 *2或者 *3 或者 *5 得来的，且对于同一个数而言他的丑数因数乘以2，3，5肯定不一样（可证），反过来也就是说每一个丑数 乘2乘3乘5所得的丑数不一样

```go
func nthUglyNumber(n int) int {
    if n == 0 {
        panic(errors.New("invalid n"))
    }
    m2, m3, m5 := 0, 0, 0
    dp := make([]int, n)
    dp[0] = 1
    for i := 1; i < n; i++ {
        a, b, c := dp[m2]*2, dp[m3]*3, dp[m5]*5
        dp[i] = min(a, min(b, c))
        if dp[i] == a {
            m2++
        }
        if dp[i] == b {
            m3++
        }
        if dp[i] == c {
            m5++
        }
    }
    return dp[n-1]
}

func min(x, y int) int {
    if x < y {
        return x
    }
    return y
}
```





### [验证回文串 - 验证回文串 - 力扣（LeetCode）](https://leetcode.cn/problems/valid-palindrome/solution/yan-zheng-hui-wen-chuan-by-leetcode-solution/)

关键点在于对输入数据的处理:48,65,97

1. 判断是否是字母数字字符

   ```go
   func isalnum(ch byte) bool {
       return (ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z') || (ch >= '0' && ch <= '9')
   }
   ```

2. 大写转小写

   ```go
   strings.ToLower(s)
   strings.ToUpper(s)
   ```

   其他常用提醒：

   ```go
   ```

   

