---
title: Golang 算法课程--算法
catalog: true
date: 2023-04-02 00:46:21
tags: working, 算法
categories: 算法，Golang
---

# 算法思想篇
> 个人学习算法经验：
> 1. 深入了解和使用一门语言 ---> Golang
> 2. 深入理解基础的数据结构和算法基础 ---> 数学理论
> 3. 知识需要依据模块和分区来做体系的整理和学习 

# **1** &ensp; 二分搜索： 为什么说有序皆可用二分
> 本章节的学习目标：
> * 二分搜索的两个标准模板
> * 二分搜索的提问破解法
> * 二分搜索的切分法

## **1.1** &ensp; 二分搜索的关键考点

1. 开闭原则
   一定要注意，在写二分搜索时候，每一个区间的表示都是严格按照开闭原则进行的
   开闭原则 --> 左闭右开 --> 左边指针指向起点，右边指针指向尾部元素的后面一个空位 

2. 区间的变化计算

3. 代码的流畅度
   * ==是否深度理解了二分搜索的原则在该题目当中的体现== --> <font color='red'> 所有算法题目的代码流畅度检验思考一</font>
   * ==是否真的记住了代码的模板== --> <font color='red'> 所有算法题目的代码流畅度检验思考二</font>
   * ==所有代码编写流畅度问题的根源都是在于不熟练--> 用的不多 --> 不会转化为已知的问题 --> 是否理解了运用的原理== --> <font color='red'> 代码熟练度尤其关注 </font>

``` mermaid
graph TD
A[联系] --> B(开闭原则)
B --> D[二分搜索]
B --> E[快速排序-三路切分]
B --> F[归并排序-切分为两个区间]
A --> C(扔掉一半)
C --> G[二叉搜索树]
G --> H[查找]
G --> I[删除]
G --> N[插入]
C --> J(三路切分)
J --> K[第k小的数]
J --> L[唯一出现的数]   
```
<br />


## **1.2** &ensp; 提问破解法解决二分问题

### 要什么，什么就是x 

1. 将目标元素设置为 x --> 去除掉题目当中所给的最小最长最大最短等限制条件，得到一个点描述
2. 得到目标 x 的区间范围: --> 决定左开右闭的规则
   
### 满足约束条件的f(x)=0

### 不满足约束条件的f(x)设置为-1或者是1

构造出一个单调变化的 f(x)，以上两步的关键在于确定（构造）f(x)是否有序，需要观察数组元素和题目要求的内容变化

### 使用lowbound 还是 upbound
最优解 0 在 f(x)=0 结果区间的最左边还是最右边，决定使用lowbound 还是 upbound 

### 有序数组中最左边的元素
> 模板题目

### 给定有序数组和target ，返回起始和终止位置
> 模板题目


### 寻找山峰



### 最小长度的连续子数组
求取的中间数组[-1,-1,0,0,1,1] 中元素代表的是子数组的长度，-1表示小于target,0 表示等于target
<!-- // 209. 长度最小的子数组

// 给定一个含有 n 个正整数的数组和一个正整数 target 。

// 找出该数组中满足其和 ≥ target 的长度最小的 连续子数组 [numsl, numsl+1, ..., numsr-1, numsr] ，并返回其长度。如果不存在符合条件的子数组，返回 0 。

//  

// 示例 1：

// 输入：target = 7, nums = [2,3,1,2,4,3]
// 输出：2
// 解释：子数组 [4,3] 是该条件下的长度最小的子数组。
// 示例 2：

// 输入：target = 4, nums = [1,4,4]
// 输出：1
// 示例 3：

// 输入：target = 11, nums = [1,1,1,1,1,1,1,1]
// 输出：0
//  

// 提示：

// 1 <= target <= 109
// 1 <= nums.length <= 105
// 1 <= nums[i] <= 105

// 求和数组 -->
``` golang
func isTarget(nums []int,l int,target int)int{
    sum := 0
    for i := 0 ; i < len(nums) ; i++ {
        sum += nums[i]
        if i < l-1 {
            continue
        }
        if sum >= target{
            return 0
        } 
        sum = sum - nums[i-(l-1)]
    } 
    return -1
}


func minSubArrayLen(target int, nums []int) int {
    left, right := 1,len(nums)+1

    for left < right{
        m := left + (right-left)/2
        now := isTarget(nums,m,target)
        if now < 0 {
            left = m + 1
        }else{
            right = m
        }
    }
    if left > len(nums){
        return 0
    }
    return left
}
```

### 最大平均值
但限制了数组长度为k的时候，可以直接使用滑动窗口来解决这个问题
``` golang 
/**
 * @param nums: an array
 * @param k: an integer
 * @return: the maximum average value
 */
func FindMaxAverage(nums []int, k int) float64 {
	// Write your code here
	max := -10001
	sum := 0
	for i := 0; i < len(nums); i++ {
		sum = sum + nums[i]
		if i < k-1 {
			continue
		}
		if sum > max {
			max = sum
		}
		if i >= k-1 {
			sum = sum - nums[i-(k-1)]
		}
	}
	return float64(max) / float64(k)
}
```
### 连续子数组的最大和问题
在上述两个问题的基础之上，衍生出来同类型的问题：
1. 如果子数组的长度无限制： 采用落差发或者是双指针，DP来解决这个问题
2. 子数组长度等于K 时候采用滑动窗口
3. 长度>=K,采用滑动窗口和落差法来解决
4. 如果限制长度必须要<=k的连续子数组最大和，可以分别求1-k的最大值，然后再选一个最大值


## **3**三步切分法

1. 找出一个分界元素
2. 将有序的搜索空间分为两半（复杂度为O（1））
   扔掉不需要的那一半
3. 在剩下的空间中递归使用切分法

切分法不需要有序性，但是二分搜索必须要求有序性
### 求旋转数组当中的某个元素
以下是未重复的题目：
```
33. 搜索旋转排序数组
整数数组 nums 按升序排列，数组中的值 互不相同 。

在传递给函数之前，nums 在预先未知的某个下标 k（0 <= k < nums.length）上进行了 旋转，使数组变为 [nums[k], nums[k+1], ..., nums[n-1], nums[0], nums[1], ..., nums[k-1]]（下标 从 0 开始 计数）。例如， [0,1,2,4,5,6,7] 在下标 3 处经旋转后可能变为 [4,5,6,7,0,1,2] 。

给你 旋转后 的数组 nums 和一个整数 target ，如果 nums 中存在这个目标值 target ，则返回它的下标，否则返回 -1 。

你必须设计一个时间复杂度为 O(log n) 的算法解决此问题。

示例 1：

输入：nums = [4,5,6,7,0,1,2], target = 0
输出：4
示例 2：

输入：nums = [4,5,6,7,0,1,2], target = 3
输出：-1
示例 3：

输入：nums = [1], target = 0
输出：-1
 

提示：

1 <= nums.length <= 5000
-104 <= nums[i] <= 104
nums 中的每个值都 独一无二
题目数据保证 nums 在预先未知的某个下标上进行了旋转
-104 <= target <= 104
```

如果增加一个重复的元素，题目变成：
```
81. 搜索旋转排序数组 II
已知存在一个按非降序排列的整数数组 nums ，数组中的值不必互不相同。

在传递给函数之前，nums 在预先未知的某个下标 k（0 <= k < nums.length）上进行了 旋转 ，使数组变为 [nums[k], nums[k+1], ..., nums[n-1], nums[0], nums[1], ..., nums[k-1]]（下标 从 0 开始 计数）。例如， [0,1,2,4,4,4,5,6,6,7] 在下标 5 处经旋转后可能变为 [4,5,6,6,7,0,1,2,4,4] 。

给你 旋转后 的数组 nums 和一个整数 target ，请你编写一个函数来判断给定的目标值是否存在于数组中。如果 nums 中存在这个目标值 target ，则返回 true ，否则返回 false 。

你必须尽可能减少整个操作步骤。
```
增加了重复的元素，那么只需要判断重复的元素是否是目标元素，如果不是那么就直接删除重复的元素，使得问题便会原本不重复元素的形式

```golang
func search(nums []int, target int)bool {
    n := len(nums)
    left,right := 0 , n

    for left < right {
        m := left + (right-left)/2

        if nums[left] == target || nums[m] == target || nums[right-1] == target{
            return true
        }
        if nums[m] > nums[left] {
            if target > nums[left] && target < nums[m]{
                right = m
            }else{
                left = m + 1
            }
        }else if nums[m] < nums[left]{
            if target > nums[m] && target < nums[right-1]{
                left = m + 1
            }else{
                right = m
            }
        }else{
            for left < right && nums[m] == nums[left]{
                left++
            }
        }
    }
    return false
}
```

