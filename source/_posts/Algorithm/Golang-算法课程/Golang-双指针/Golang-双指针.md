---
title: Golang 双指针
catalog: true
date: 2023-04-02 00:46:21
subtitle:
header-img:
tags: 双指针, 算法
categories: 算法，Golang
---

# 双指针：如何掌握最长、定长、最短区间问题的解题诀窍
> 通常是明明用两个指针在数组/链表上遍历，然后解决满足某种性质的问题
> 解决问题：
> **最长区间**
> **定长区间**
> **最短区间**
> <font color = 'red'>1. 弄清楚题目要的是什么样的区间，是上述三种中的哪一类</font>
> <font color = 'red'>2. 区间需要满足的条件是什么</font>

## **1** &ensp; 区间特性

### 单调性 & 最优
> 使用双指针需要保证区间的单调性

1. 单调性的定义：
   区间的单调性： 固定了划分区间的条件之后，遍历区间内的元素，按照一定顺序的时候，区间内的元素应该是都满足某一个条件，且存在问题定义上的大小单调变化。
   比如： 在一个完全都是正整数的区间里面，划分子集的标准是固定子集右端元素（最右端元素只能是A[i]），集合内元素的和从下标为-1到i-1,均大于某个数，且这个和逐步减少（$\because 元素都是正数，减少了就变小了$）

2. 快速判断区间属性是否满足单调性的办法
   <font color = 'red'> 往区间里面添加元素的时候，区间的约束条件可以变化，但不能出现波折</font>
   理解为： 添加一个元素之后，要么依旧满足条件，符合单调性；要么出现一会不满足一会满足的情况，不符合单调性

> 遍历区间的所有子集可以使用这样的方式： 固定子集的最右边元素为固定元素：
> 固定右区间集合，把A[i]元素固定为区间的右端点，之变动区间的左边界形成的所有区间，并且按照区间长度需要从长到短排列
>
3. 找到最优解
   <font color = 'red'> 从左向右遍历区间右端固定元素集合中的每个区间，找到一个满足条件的解就停止（因为单调性继续调整依旧满足条件）</font>

### 模板
1. 寻找以A[i]为有边界的最优解，分为以下三步
``` golang
Step 1 :
将A[i] 加入到区间中，形成新的区间 （left,i]
room = append(room,A[i])

Step 2：
遍历A[i]的固定右区间集，直到找到以A[i]为右端点的最优解
for left < i && (left,i] 区间不满足要求 {
    left++
} 

Step 3:
此时要么得到一个满足要求的解，要么没有满足单调性的区间
(left,i]区间满足要求
```
2. 题目须具备的条件
   * 给定一个条件
   * 求最长区间/最长字串
   * 题目给出的区间需要具备的单调性

3. 必杀技
   * left，right 指针
   * 只有在不满足条件的时候才向右移动left指针
  
4. 最长区间的代码模板
``` golang
func maxLength(A []int) int{
    // 创建左指针和结果
    left, ans := -1, 0

    // 从左向右遍历区间
    for i:= 0; i< len(A); i++{
        // Assert 在加入 A[i] 之前，(left,i-1] 是一个合法有效的区间，在最开始的时候left = -1，i-1=-1，是空区间，满足条件
        // Step1 : 直接将A[i]加到区间中，形成(left,i]
        // step2 : 将A[I]加入之后，依据left的惰性yuanze
        // TODO: check检查区间状态是否满足条件
        for check(left,i) {
            left++// 如果不满足条件，移动左指针
            // TODO： 修改区间的状态
        }
        // assert 此时的(left,i] 必然满足条件
        ans = max(ans,i-left)
    }
    // 返回最优解
    return ans
}
```

时间复杂度为 O(n)

## **2** &ensp; 例题: 区间长度类型

### 不含重复字符的最长区间
> 单调性： 当找到一个没有重复字符的区间时候，减少区间内元素，新的区间依旧满足没有重复元素
> https://leetcode.cn/problems/longest-substring-without-repeating-characters/
>
``` golang
func lengthOfLongestSubstring(s string) int {
    // 双指针解决
    left, ans := -1,0
    // 存储区间内元素的映射
    m := make(map[byte]int,0)
    for i := 0; i <len(s); i++ {
        m[s[i]] += 1
        for m[s[i]] > 1 {
            left++
            m[s[left]]--
        }
        ans = max(ans, i-left)
    }
    return ans
}

func max(args ...int)int{
    m := args[0]
    for _, val := range args{
        if val > m {
            m = val
        }
    }
    return m
}
```

### 替换后的最长重复字符
> 给你一个字符串 s 和一个整数 k 。你可以选择字符串中的任一字符，并将其更改为任何其他大写英文字符。该操作最多可执行 k 次。
> https://leetcode.cn/problems/longest-repeating-character-replacement/
> 
在执行上述操作后，返回包含相同字母的最长子字符串的长度。
示例 1：
输入：s = "ABAB", k = 2
输出：4
解释：用两个'A'替换为两个'B',反之亦然。
示例 2：
输入：s = "AABABBA", k = 1
输出：4
解释：
将中间的一个'A'替换为'B',字符串变为 "AABBBBA"。
子串 "BBBB" 有最长重复字母, 答案为 4。
 提示：
1 <= s.length <= 105
s 仅由大写英文字母组成
0 <= k <= s.length


``` golang
func characterReplacement(s string, k int) int {
    // 
    left, ans := -1,0
    max_repeat := 0
    m := make(map[byte]int,0)
    for i := 0; i < len(s); i++{
        m[s[i]]++

        max_repeat = max(m[s[i]],max_repeat)
        for i-left-max_repeat > k{
            left++
            m[s[left]]--
        } 
        ans = max(ans,i-left)
    }
    return ans
}
func max(args ...int)int{
    m := args[0]
    for _, val := range args{
        if val > m {
            m = val
        }
    }
    return m
}
```


### 字符流中第一个只出现一次的字符
> 请实现一个函数用来找出字符流中第一个只出现一次的字符。
> https://www.acwing.com/problem/content/60/
例如，当从字符流中只读出前两个字符 go 时，第一个只出现一次的字符是 g。
当从该字符流中读出前六个字符 google 时，第一个只出现一次的字符是 l。
如果当前字符流没有存在出现一次的字符，返回 # 字符。
数据范围
字符流读入字符数量 [0,1000]

样例
输入："google"
输出："ggg#ll"
解释：每当字符流读入一个字符，就进行一次判断并输出当前的第一个只出现一次的字符。

```golang
type Solution struct {
    left int // 最左侧字符位置
    cnt  [256]int // 字符个数计数器
    s    string // 保存输入的字符串
}

var s Solution

func insert(ch byte) {
    s.cnt[ch]++ // 将该字符出现次数加1
    s.s += string(ch) // 将该字符加入到字符串s中
    // 如果最左侧的字符出现次数大于1，则将最左侧字符的位置向右移动，直到最左侧字符出现次数为1或者left >= right
    for s.left < len(s.s) && s.cnt[s.s[s.left]] > 1 {
        s.left++
    }
}

func firstAppearingOnce() byte {
    // 如果最左侧字符位置left大于等于字符串s的长度，则返回'#'
    if s.left >= len(s.s) {
        return '#'
    }
    // 返回最左侧的字符
    return s.s[s.left]
}
```

### 最多有k个不同字符的最长子字符串
> 给定字符串S，找到最多有k个不同字符的最长子串T。
> https://www.lintcode.com/problem/386/
样例
样例 1:

输入: S = "eceba" 并且 k = 3
输出: 4
解释: T = "eceb"
样例 2:

输入: S = "WORLD" 并且 k = 4
输出: 4
解释: T = "WORL" 或 "ORLD"
挑战
O(n) 时间复杂度
``` golang
/**
 * @param s: A string
 * @param k: An integer
 * @return: An integer
 */
func LengthOfLongestSubstringKDistinct(s string, k int) int {
    //
    left, count,l := -1,0,0

    m := make(map[byte]int,0)
    for i:=0; i< len(s); i++{
        if m[s[i]] == 0 {
            count++
        }
        m[s[i]]++
        for count > k {
            left++
            m[s[left]]--
            if m[s[left]] == 0 {
                count--
            }
        }
        l = max(l,i-left)
    }
    return l
}

func max(args ...int) int{
    m := args[0]
    for _, val := range args{
        if val > m {
            m = val
        }
    }
    return m
}
```

###  数组中的最长山脉
> https://leetcode.cn/problems/longest-mountain-in-array/description/
>
把符合下列属性的数组 arr 称为 山脉数组 ：

arr.length >= 3
存在下标 i（0 < i < arr.length - 1），满足
arr[0] < arr[1] < ... < arr[i - 1] < arr[i]
arr[i] > arr[i + 1] > ... > arr[arr.length - 1]
给出一个整数数组 arr，返回最长山脉子数组的长度。如果不存在山脉子数组，返回 0 。
示例 1：
输入：arr = [2,1,4,7,3,2,5]
输出：5
解释：最长的山脉子数组是 [1,4,7,3,2]，长度为 5。
示例 2：

输入：arr = [2,2,2]
输出：0
解释：不存在山脉子数组。
提示：
1 <= arr.length <= 104
0 <= arr[i] <= 104
 
进阶：
你可以仅用一趟扫描解决此问题吗？
你可以用 O(1) 空间解决此问题吗？

``` golang
func longestMountain(A []int) int {
    N := len(A)
    if N < 3 {
        return 0
    }

    left := -1
    // -1表示只有一个元素
    // 0表示正上升
    // 1表示正下降
    status := -1
    preValue := A[0]
    ans := 0

    // 题目要求必须至少有3个元素，所以不可能从0开始
    for i := 1; i < N; i++ {
        x := A[i]

        // 如果要把x加进来
        // 如果里面还只有一个元素
        if status == -1 {
            if x > preValue {
                // 那么状态改为上升
                status = 0
            } else {
                // 如果相等，或者变小，那么区间只能再变成只有一个元素的了
                // 状态依然更新为只有一个元素
                status = -1
                // 区间更新为(left, i]
                left = i - 1
            }
        }
        // 如果正在上升
        if status == 0 {
            if x > preValue {
                // nothing
            } else if x == preValue {
                // 如果相等，那么区间只能再变成只有一个元素的状态了
                status = -1
                left = i - 1
            } else {
                // 下降了
                status = 1
            }
        }
        // 如果正在下降
        if status == 1 {
            if x < preValue {
                // nothing
            } else if x == preValue {
                status = -1
                left = i - 1
            } else {
                // 如果正在上升
                status = 0
                // 注意这里left要变成(i - 2, i]
                // 这里已经有两个元素了
                left = i - 2
            }
        }

        preValue = x
        if status == 1 {
            ans = max(ans, i-left)
        }
    }

    if ans >= 3 {
        return ans
    }
    return 0
}


func max(args ...int)int{
    m := args[0]
    for _, val := range args{
        if val > m {
             m = val
        }
    }
    return m
}
```

---

## **3**  &ensp; 例题：区间计数

### 区间计数
> 区间最优原则表示：当按照区间最右边元素划分区间，并找到最优解之后，left继续向有移动形成的短区间都满足条件

#### 代码模板
> 在求最长区间代码模板上变式
```golang
func rangeCounter(A []int){
    // 区间的左指针
    left,ans := -1,0
    // 不变式0： 最开始的区间为(-1，-1] 是一个空区间
    //          我们认为空区间总是满足条件
    for i:=0; i<len(A); i++{
        // 不变式1： 在加入A[i]之前，(left,i-1]是一个合法的有效区间
        // 需要改变的部分为下：
        // Step1： 直接将A[i]加入到区间中，形成(left,i]
        // Step2:  将A[i] 加入之后，依据多性原则判断Left是否移动且移动多少
        /** TODO: 设计check函数，检查区间是否满足条件
        */
        for check(left,i] {
            // 如果不满足条件，则移动左指针
            left++
            /**
            TODO: 修改区间的状态或者改变区间的性质
            */
        }
        // 不变式2： 此时(left,i]必然合法
        // 累计区间个数: 以A[i]为有边界的子区间总共有i-left个
        ans = ans + i-left
    }
    return ans
}
```