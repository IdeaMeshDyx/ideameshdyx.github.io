---
title: Golang 使用链表
catalog: true
date: 2023-03-28 00:34:11
subtitle:
header-img:
tags: Golang, List
categories:
published: false
---

# Golang 链表的使用

链表是通过指针串联在一起的线性结构，每一个节点都包含两个部分的内容：指针域和数据域；指针域用于存储指向其他节点的指针变量

对于链表而言有俩个最重要的概念：
* head
* head.Next

在操作链表的时候非常容易将移动指针和操作节点内容弄混，首先 Head *ListNode 是一个指向节点的指针，本身是一个地址；Head.Next 是节点内的指针变量用于指向其他的节点。当我们在遍历链表结构的时候不断移动的是 Head 变量，而如果要对链表的结构进行改动，就需要修改 Head.Next 的值为其他的节点地址。

但有一个非常简单的方法可以识别出对指针的操作以及他的身份: 
1. Next/Pre(节点内值) 变量在**等号左边**必定是增删修改节点位置，一定要想清楚当前使用Next的节点是哪一个; 在**等号右边**一般就是移动指针的位置，但没有改变链表的结构 
2. Head 在**等号左边**必定是改变指针位置，移动到其他的节点； 在**等号右边**一般是改变链表的结构或者是让其他的节点指向当前节点。  

所以要改变链表的结构，Head.Next的值一定会改变且在循环中出现在等号的左边，Head 本身应该理解为一个地址指针用于指向要操作内容的节点



# Golang 链表算法使用
> leetcode 题目汇总：
> [1] [https://leetcode.cn/problems/remove-nth-node-from-end-of-list/solution/shan-chu-lian-biao-de-dao-shu-di-nge-jie-dian-b-61/ ]
>


