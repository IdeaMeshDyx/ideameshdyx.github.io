---
title: 【RPC】Golang 实现简单 RPC
catalog: true
date: 2023-03-24 02:59:34
subtitle:
header-img:
tags:
categories:
published: false
---

# [RPC] Goalng 实现简单的 RPC

## 什么是 RPC 

### RPC 定义
RPC(Remote Procedure Call，远程过程调用)是一种**计算机通信协议**，允许**调用不同进程空间的程序**。RPC 的客户端和服务器可以在一台机器上，也可以在不同的机器上。程序员使用时，就像调用本地程序一样，无需关注内部的实现细节。

### RPC 需要解决的问题
> core: 为进程运行提供 “overlay” 服务，使得不同团队的进程，不同进程的调用，可以在不同时间、机器、不同规则上实现一体化服务的提供，这对于分布式环境下多个类型公司主体处理同一份数据并给统一团体客户提供多样服务有着重要作用
>
> 


### 设计的简单RPC 需要实现的功能(RoadMap)

参考 (GeeRpc)[https://geektutu.com/post/geerpc.html] 作为基础 rpc 实现



## 实现服务端和消息编码
> 目标是：
> * 使用encoding/gob 实现消息的解编码（序列化和反序列化）
> * 实现简易的服务端，仅接受消息不处理




---

## 问题集锦

### encode/gob 与 Protobuf

二者都是完成信息做序列化的工作，但是 encode/gob 仅仅是提供了对于Golang语言的支持，要想在不同的平台应用得使用Protobuf

### 什么是工厂模式


### Golang 包名字的统一


### var _ Codec = (*GobCodec)(nil) 的作用
> 参考文章：[https://cloud.tencent.com/developer/article/2025793]
在 Golang 中，var _ 可以用作声明变量但不使用它的占位符。在 var _ Codec = (*GobCodec)(nil) 中，_ 的作用是占位符。它们结合在一起可以起到两个作用：

防止编译器报错：当一个接口类型被定义后，需要确保该接口类型被所有实现都正确实现。编译器可以通过检查是否所有实现都满足该接口的方法来验证这一点。在接口类型和实现之间声明 var _ InterfaceType = (*ImplementType)(nil) 可以防止编译器发出“实现不完整”的警告。

检验类型之间的兼容性：在 var _ Codec = (*GobCodec)(nil) 中，则是要检验 GobCodec 是否实现了 Codec 接口。如果 GobCodec 没有实现 Codec 接口中的所有方法，则编译时将无法通过，从而起到检验类型之间的兼容性的作用。

总之，var _ Codec = (*GobCodec)(nil) 的目的是检验 GobCodec 是否实现了 Codec 接口、避免编译器报错并判断类型之间的兼容性。它通常用于接口类型和实现之间的声明，对于保证代码质量和类型安全是很有帮助的。

