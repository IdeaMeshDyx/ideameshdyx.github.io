---
title: Go 系统知识汇总
catalog: true
date: 2023-04-01 20:57:34
subtitle:
header-img:
tags:
categories: 
    - enhanced
---
- [Golang 系统知识回答收集](#golang-系统知识回答收集)
  - [Golang 语法方面](#golang-语法方面)
    - [Golang关键字有哪些](#golang关键字有哪些)
    - [Golang 当中](#golang-当中)
    - [range 函数的具体使用](#range-函数的具体使用)
    - [Slice 扩容机制](#slice-扩容机制)
    - [Slice 为什么不是线程安全的](#slice-为什么不是线程安全的)
    - [map的底层原理](#map的底层原理)
    - [map的扩容机制](#map的扩容机制)
    - [map的遍历为什么无序](#map的遍历为什么无序)
    - [map的底层存储不是连续的](#map的底层存储不是连续的)
    - [map 为什么不是线程安全的](#map-为什么不是线程安全的)
    - [Map如何查找](#map如何查找)
    - [map 冲突解决的方式](#map-冲突解决的方式)
    - [map 的负载因子为什么时6.5](#map-的负载因子为什么时65)
    - [Map和 Sync.Map哪一个性能好](#map和-syncmap哪一个性能好)
    - [channel 底层实现原理](#channel-底层实现原理)
    - [channel 有什么特点](#channel-有什么特点)
    - [Channel 的使用场景](#channel-的使用场景)
    - [channel 为什么是线程安全的](#channel-为什么是线程安全的)
    - [Channel 发送和接收什么情况下会死锁](#channel-发送和接收什么情况下会死锁)
    - [互斥锁实现原理](#互斥锁实现原理)
    - [悲观锁与乐观锁](#悲观锁与乐观锁)
    - [原子操作和锁的区别](#原子操作和锁的区别)
    - [互斥锁允许自旋的条件](#互斥锁允许自旋的条件)
    - [读写锁的实现原理](#读写锁的实现原理)
    - ["原子操作"有哪些](#原子操作有哪些)
    - [Goroutine 的底层实现原理](#goroutine-的底层实现原理)
    - [](#)
    - [goroutine 和线程的区别](#goroutine-和线程的区别)
    - [Go 线程模型（Go底层怎么实现高并发的）](#go-线程模型go底层怎么实现高并发的)
    - [Golang assertion](#golang-assertion)
  - [Golang调用方面](#golang调用方面)
    - [len 统计长度](#len-统计长度)


# Golang 系统知识回答收集

## Golang 语法方面

### Golang关键字有哪些

### Golang 当中
关键字是指被编程语言用作特定目的的保留单词，这些关键字在代码当中具有特殊的含义，不能被用作标识符（例如变量名，函数名，类型名等）。以下是Golang中关键字的列表

```go
func 
type 

interface 
struct 
var

break continue 

default

case 
select
defer
switch
for 
range 
goto
else
if

const
chan 
map

import
package

go
return 

fallthrough

```

### range 函数的具体使用

golang当中range 关键字可以用于迭代数组、切片、字符串、map和通道等数据类型

```go
//迭代数组和切片时候，返回当前元素的索引和值
arr := [3]int{1,2,3}
for key,num := range arr{
	fmt.Printf("now arr[%d] is %d\n", key,num)
}

// map 迭代字符串的时候，每次迭代返回当前字符的索引和Unicode码点

s := "hello world"
for i, c := range s{
	fmt.Printf("index:%d, Unicode code ponit : %U\n",i,c)
}

//迭代map结构
m := map[int]string{
	1: "one",
	2: "two",
	3: "three",
}
for k,v := range m{
	fmt.Printf("key : %d, value : %s",k,v)

}

//迭代通道使用range 迭代通道的时候，会不断地从通道当中接受元素，直到通道关闭为止

ch := make(chan int)
go func() {
	for i := 0;i<5,i++{
	ch <- i
	}
	close(ch)
}()

for v := range ch {
	fmt.Println(v)
}
```

在迭代通道的时候，如果通道没有关闭，那么循环就会一直等待下去，知道程序死锁，因此必须要再写入完所有的数据之后关闭通道，或者使用'select'语句在接受通道数据的时候检查通道是否已经关闭


### Slice 扩容机制

Go 1.18 版本之后，当新切片需要的容量cap大于两倍扩容的容量时候，则直接按照新切片需要的容量进行扩容：

* 当原 Slice 容量 < threshold 的时候，新 slice 容量变成原来的2 倍
* 当原 Slice 容量 > threshold 的时候，进入一个循环，每次容量增加 （旧容量 + 3*threshold）/4


### Slice 为什么不是线程安全的

因为 Slice 内部使用了底层数组，数组在内存当中是连续存储的并没有加锁的机制，本身并不支持并发的读写

当多个Goroutine并发访问同一个Slice的时候，可能存在某个Goroutine修改了Slice中的某个元素，其他Goroutine无法立即看到这个修改，也可能会造成竞争问题。可以通过使用((20230318150223-agvrll2 "互斥锁"))或者((20230318154221-miv3alf "原子操作"))来保证某个Goroutine访问的时候其他goroutine不能够同时访问，另外也可以使用通道来进行同步，通过将Slice的访问权限交给某个Goroutine，从而保障其他的Goroutine无法同时访问该Slice。



### map的底层原理

map对象本身是一个指针，占用8个字节（64位计算机），指向`hmap`结构体，hmap包含多个bmap数组（桶）

```go
type hmap struct{
	count int // 元素个数，调用len(map)的时候直接返回
	flags uint8 // 标志当前map的状态，正在删除元素、添加元素、、、、
	B uint8 //单元(buckets)的对数 B=5表示能容纳32个元素  B随着map容量增大而变大

	noverflow uint16  //单元(buckets)溢出数量，如果一个单元能存8个key，此时存储了9个，溢出了，就需要再增加一个单元
	hash0 uint32 //哈希种子
	buckets unsafe.Pointer //指向单元(buckets)数组,大小为2^B，可以为nil
	oldbuckets unsafe.Pointer //扩容的时候，buckets长度会是oldbuckets的两倍
	nevacute uintptr  //指示扩容进度，小于此buckets迁移完成 
	extra *mapextra //与gc相关 可选字段 
}

type bmap struct{
	tophash [bucketCnt]uint8 
}
//实际上编译期间会生成一个新的数据结构  
type bmap struct { 
    topbits [8]uint8     //key hash值前8位 用于快速定位keys的位置
    keys [8]keytype     //键
    values [8]valuetype //值
    pad uintptr 
    overflow uintptr     //指向溢出桶 无符号整形 优化GC
}

```


### map的扩容机制

扩容时机：向map里面插入新的key的时候，会进行条件检测，符合以下两个条件就会触发扩容操作：

扩容条件：

1. 超过负载 map元素个数 > 负载因子 * 桶个数
2. 溢出桶太多

负载因子是元素个数与桶的数量的比值

当桶总数<2^15^时，如果溢出桶总数>=桶总数，则认为溢出桶过多

当桶总数>2^15^时，如果溢出桶总数>=2^15^，则认为溢出桶过多


扩容机制：

* 双倍扩容：针对条件1，新建一个buckets数组，新的buckets大小是原来的2倍，然后旧buckets数据搬迁到新的buckets。
* 等量扩容：针对条件2，并不扩大容量，buckets数量维持不变，重新做一遍类似双倍扩容的搬迁动作，把松散的键值对重新排列一次，使得同一个 bucket 中的 key 排列地更紧密，节省空间，提高 bucket 利用率，进而保证更快的存取。

* 渐进式扩容： 插入修改删除key的时候，都会尝试进行搬迁桶的工作，每次都会检查oldbucket是否**nil**，如果不是**nil**则每次搬迁**2**个桶，蚂蚁搬家一样渐进式扩容


### map的遍历为什么无序

map  每次遍历，都会从一个随机值序号的桶开始，再从其中随机的cell 开始遍历，并且扩容后，原来桶中的key会落到其他的桶中，本身就会造成失序。

如果想要遍历map，先把key放到切片中排序，再按照key的顺序遍历map

```go
//请写一段代码验证
m := map[int]string {
	1: "one",
	2: "two",
	3: "three",
}

for key,value := range m{
	fmt.Printf("data is : %d ---> %S \n", key,value)
}

```


### map的底层存储不是连续的

具体来说map 内部存储的是一个桶（bucket）数组，桶数组中的每个元素有事一个指向链表头的指针，他存储的数据并不连续


### map 为什么不是线程安全的

多个协程同时对**map**进行并发读写**,**程序会**panic**

想要线程安全，可以使用sync.RWLock锁

在sync.map 这个包当中实现了锁，是线程安全的


### Map如何查找

1. 计算hash值
    key经过哈希函数计算后,得到64bit(64位CPU)
    10010111 | 101011101010110101010101101010101010 | 10010
2. 找到hash对应的桶
    上面64位后5(hmap的B值)位定位所存放的桶
    如果当前正在扩容中,并且定位到旧桶数据还未完成迁移,则使用旧的桶
3. 遍历桶查找
    上面64位前8位用来在tophash数组查找快速判断key是否在当前的桶中,如果不在需要去溢出桶查找
4. 返回key对应的指针



### map 冲突解决的方式

Go采用链式地址解决冲突，具体实现就是插入key到map中时，当key定位的桶填满8个元素，将会创建一个溢出桶并且将溢出桶插入到当前桶所在的链表尾部

Golang当中采用链式哈希表（Cahined Hash Table）

在Golang的哈希表实现当中，每一个桶就是一个链表的头指针，桶内每个元素都是哈希链表节点，节点包含了该元素的哈希值、键以及指向下一个节点的指针。

在查找时候，先根据键的哈希值找到对应的桶，然后在该桶对应的链表中顺序查找，指导找到目标元素或者是链表遍历完毕。


### map 的负载因子为什么时6.5

> 负载因子 = 哈希表存储的元素个数 / 桶个数

Go 官方发现：装载因子越大，填入的元素越多，空间利用率就越高，但发生哈希冲突的几率就变大。
装载因子越小，填入的元素越少，冲突发生的几率减小，但空间浪费也会变得更多，而且还会提高扩容操作的次数

Go 官方取了一个相对适中的值，把 Go 中的 map 的负载因子硬编码为 6.5，这就是 6.5 的选择缘由。

这意味着在 Go 语言中，当 map存储的元素个数大于或等于 6.5 * 桶个数 时，就会触发扩容行为。


### Map和 Sync.Map哪一个性能好

对比原始map：

和原始map+RWLock的实现并发的方式相比，减少了加锁对性能的影响。

它做了一些优化：可以无锁访问read map，而且会优先操作read map，倘若只操作read map就可以满足要求，那就不用去操作write map(dirty)，所以在某些特定场景中它发生锁竞争的频率会远远小于map+RWLock的实现方式

* 优点：
  适合读多写少的场景
* 缺点：
  写多的场景，会导致 read map 缓存失效，需要加锁，冲突变多，性能急剧下降



### channel 底层实现原理

通过**var****声明或者是**​**make****函数创建的channel变量**是一个存储在函数栈帧上的指针，占用8个字节，指向堆上的hchan结构体

```go
type hchan struct{
	closed uint32 // channel 是否关闭的标志
	elemtype *_type // channel 中的元素类型

	buf unsafe.Pointer //指向底层循环数组的指针（环形缓存区）
	qcount uint // 循环数组中的元素数量
	dataqsiz uint //循环数组的长度
	elemsize uint16 //元素的大小
	sendx uint // 下一次写下标的位置
	recvx uint // 下一次读下标的位置
	// 尝试读取channel 或者向channel 写入数据而被阻塞的goroutine
    	recvq    waitq  // 读等待队列
    	sendq    waitq  // 写等待队列
    	lock mutex //互斥锁，保证读写channel时不存在并发竞争问题
}
```

channel 分为无缓冲和有缓冲两种

* 对于有缓冲的channel存储数据，使用了ring buffer(环形缓冲区) 来缓存写入的数据，本质是循环数组。

  为啥是循环数组呢？普通数组不行吗，普通数组容量固定，更适合指定的空间，弹出元素的时候，普通数组需要全部前移。

  `当下标超过数组容量后会回到第一个位置，所以需要有两个字段记录当前读和写的下标位置`

* 对于无缓冲的channel 存储数据

等待队列： 

双向链表，包含一个头结点和一个尾结点 每个节点是一个sudog结构体变量，记录哪个协程在等待，等待的是哪个channel，等待发送**/**接收的数据在哪里

```go
type wait struct{
	first *sudog
	last *sudog
}

type sudog struct{
	g *g
	next *sudog
	pre  *sudog
	elem unsafe.Pointer
	c  *hchan
	...
}
```


创建 channel 的时候：

创建时会做一些检查**:** 

* 元素大小不能超过 **64**K
* 元素的对齐大小不能超过 maxAlign 也就是 **8** 字节
* 计算出来的内存是否超过限制

创建时的策略:

* 如果是无缓冲的channel，会直接给hchan 分配内存
* 如果是有缓冲的channel，并且元素不包含指针，那么会为 hchan  和底层数组分配一段连续的地址

* 如果是有缓冲的channel，元素包含指针，那么就会为了hchan 和底层数组分别分配地址

发送时：

* 如果 channel 的读队列存在着接收者 goroutine，将唤醒接收的goroutine，将数据**直接发送**给第一个等待的 goroutine

* 如果channel 的读等待队列不存在接收者 goroutine

  * 如果循环数组buffer未满，那么将会把数据发送到循环数组buffer的队尾
  * 如果循环数组buffer已满，这个时候就会阻塞发送的流程，将当前goroutine加入写等待队列，**并挂起等待唤醒**

接收时：

* 如果 channel 的写等待队列存在发送者 goroutine

  * 如果是无缓冲 channel ，**直接**从第一个发送者goroutine 那里 把数据拷贝给接受变量，**唤醒 发送的goroutine**
  * 如果是有缓冲的 channel（已满），将循环数组的buffer的队首元素拷贝给接受变量，将第一个发送者goroutine的数据拷贝到buffer循环数组的队尾，**唤醒发送的goroutine**
* 如果channel 的写等待队列不存在发送者goroutine

  * 如果循环数组buffer非空，将循环数组buffer的队首元素拷贝给接受变量
  * 如果循环数组buffer为空，这个时候就会阻塞接收的流程，将当前goroutine 加入读等待队列，并**挂起等待唤醒**


### channel 有什么特点

channel是线程安全的

channel 有两种类型： 无缓冲、有缓冲

channel 有三种模式： 写操作模式（单向通道）、读操作模式（单向通道）、读写操作模式（双向通道）

```go
写操作模式    make(chan<- int)
读操作模式    make(<-chan int)
读写操作模式    make(chan int)
```

channel 有 3 种状态：未初始化、正常、关闭

| 操作 \ 状态 | 未初始化         | 关闭                               | 正常             |
| ------------- | ------------------ | ------------------------------------ | ------------------ |
| 关闭        | panic            | panic                              | 正常             |
| 发送        | 永远阻塞导致死锁 | panic                              | 阻塞或者成功发送 |
| 接收        | 永远阻塞导致死锁 | 缓冲区为空则为零值，否则可以继续读 | 阻塞或者成功接收 |

注意点：

* 一个 channel不能多次关闭，会导致painc

* 如果多个 goroutine 都监听同一个 channel，那么 channel 上的数据都可能随机被某一个 goroutine 取走进行消费
* 如果多个 goroutine 监听同一个 channel，如果这个 channel 被关闭，则所有 goroutine 都能收到退出信号

### Channel 的使用场景

无缓冲 Channel 在并发编程中的具体业务使用场景很多，主要应用于 Go 语言中。以下是一些常见的无缓冲 Channel 的具体业务使用场景及例子：

1. 并发控制：在并发程序中，通过无缓冲 Channel 可以实现多个 Goroutine 之间的**同步和控制**。例如，一个任务需要多个协程协作完成时，可以使用无缓冲 Channel 来传递任务数据和控制信号。
2. 事件驱动：在事件驱动的编程中，可以使用无缓冲 Channel 来传递事件和执行结果。例如，当一个 HTTP 请求到达时，可以将请求交给一个协程处理，并使用无缓冲 Channel 返回处理结果。
3. 分布式计算：在分布式计算中，可以使用无缓冲 Channel 来实现节点之间的通信和数据传递。例如，在 MapReduce 算法中，可以使用无缓冲 Channel 来传递 Map 阶段的输出结果并驱动 Reduce 阶段的计算。

有缓冲 Channel 在并发编程中的具体业务使用场景也很多，主要应用于 Go 语言中。以下是一些常见的有缓冲 Channel 的具体业务使用场景及例子：

1. 网络编程：在 TCP 或 UDP 数据处理中，可以使用有缓冲 Channel 缓存数据，**以避免因数据接收太慢而导致发送者被阻塞**。例如，在高并发的 Web 服务器中，可以使用有缓冲 Channel 缓存请求数据以提高吞吐量。
2. IO 操作：在使用 IO 操作时，如文件读写、数据库访问等，可以使用有缓冲 Channel 缓存数据，以避免因数据处理速度不匹配而导致发送者或接收者被阻塞。例如，**在从数据库获取大量数据时，可以使用有缓冲 Channel 缓存数据，减少数据库连接次数。**
3. 并发控制：在并发程序中，通过有缓冲 Channel 可以实现多个 Goroutine 之间的同步和控制。例如，一个任务需要多个协程协作完成时，可以使用有缓冲 Channel 来传递任务数据和控制信号，并根据缓冲区的剩余空间来控制协程的执行顺序。
4. 事件驱动：在事件驱动的编程中，可以使用有缓冲 Channel 来缓存事件和执行结果，并根据缓冲区的剩余空间来控制事件的处理顺序。例如，当一个 HTTP 请求到达时，可以将请求交给一个协程处理，并使用有缓冲 Channel 缓存处理结果，避免处理速度过慢导致请求被阻塞。


### channel 为什么是线程安全的

不同协程通过channel进行通信，本身的使用场景就是多线程，为了保证数据的一致性，必须实现线程安全


channel的底层实现中，hchan结构体中采用Mutex锁来保证数据读写安全。在对循环数组buf中的数据进行入队和出队操作时，必须先获取互斥锁，才能操作channel数据


### Channel 发送和接收什么情况下会死锁

```go
func deadlock1() {    //无缓冲channel只写不读
    ch := make(chan int) 
    ch <- 3 //  这里会发生一直阻塞的情况，执行不到下面一句
}
func deadlock2() { //无缓冲channel读在写后面
    ch := make(chan int)
    ch <- 3  //  这里会发生一直阻塞的情况，执行不到下面一句
    num := <-ch
    fmt.Println("num=", num)
}
func deadlock3() { //无缓冲channel读在写后面
    ch := make(chan int)
    ch <- 100 //  这里会发生一直阻塞的情况，执行不到下面一句
    go func() {
        num := <-ch
        fmt.Println("num=", num)
    }()
    time.Sleep(time.Second)
}
func deadlock3() {    //有缓冲channel写入超过缓冲区数量
    ch := make(chan int, 3)
    ch <- 3
    ch <- 4
    ch <- 5
    ch <- 6  //  这里会发生一直阻塞的情况
}
func deadlock4() {    //空读
    ch := make(chan int)
    // ch := make(chan int, 1)
    fmt.Println(<-ch)  //  这里会发生一直阻塞的情况
}
func deadlock5() {    //互相等对方造成死锁
    ch1 := make(chan int)
    ch2 := make(chan int)
    go func() {
        for {
        select {
        case num := <-ch1:
            fmt.Println("num=", num)
            ch2 <- 100
        }
    }
    }()
    for {
        select {
        case num := <-ch2:
            fmt.Println("num=", num)
            ch1 <- 300
        }
    }
}
```

### 互斥锁实现原理

Go sync包提供了两种锁类型：互斥锁sync.Mutex 和 读写互斥锁sync.RWMutex，都属于((20230402113517-ppcs0gj "悲观锁"))。
[https://blog.csdn.net/baolingye/article/details/111357407](https://blog.csdn.net/baolingye/article/details/111357407)

在正常模式下，**锁的等待者会按照先进先出的顺序获取锁**。但是刚被唤起的 Goroutine 与新创建的 Goroutine 竞争时，大概率会获取不到锁，在这种情况下，这个被唤醒的 Goroutine 会加入到等待队列的前面。 如果一个等待的 Goroutine 超过1ms 没有获取锁，那么它将会把锁转变为**饥饿模式**。
Go在1.9中引入优化，目的保证互斥锁的公平性。在饥饿模式中，互斥锁会直接交给等待队列最前面的 Goroutine。新的 Goroutine 在该状态下不能获取锁、也不会进入自旋状态，它们只会在队列的末尾等待。如果一个 Goroutine 获得了互斥锁并且它在队列的末尾或者它等待的时间少于 1ms，那么当前的互斥锁就会切换回正常模式。


### 悲观锁与乐观锁

**悲观锁**是基于一种悲观的态度类来防止一切数据冲突，它是以一种预防的姿态在**修改数据之前把数据锁住，然后再对数据进行读写，在它释放锁之前任何人都不能对其数据进行操作，直到前面一个人把锁释放后下一个人数据加锁才可对数据进行加锁，**然后才可以对数据进行操作，一般数据库本身锁的机制都是基于悲观锁的机制实现的;

特点：可以完全保证数据的独占性和正确性，因为每次请求都会先对数据进行加锁， 然后进行数据操作，最后再解锁，而加锁释放锁的过程会造成消耗，所以性能不高;


**乐观锁**是对于数据冲突保持一种乐观态度，操作数据时不会对操作的数据进行加锁（这使得多个任务可以并行的对数据进行操作），只有到数据提交的时候才通过一种机制来验证数据是否存在冲突(一般实现方式是通过加版本号然后进行版本号的对比方式实现);

特点：乐观锁是一种并发类型的锁，其本身不对数据进行加锁通而是通过业务实现锁的功能，不对数据进行加锁就意味着允许多个请求同时访问数据，同时也省掉了对数据加锁和解锁的过程，这种方式因为节省了悲观锁加锁的操作，所以可以一定程度的的提高操作的性能，不过在并发非常高的情况下，会导致大量的请求冲突，冲突导致大部分操作无功而返而浪费资源，所以在高并发的场景下，乐观锁的性能却反而不如悲观锁。



### 原子操作和锁的区别

在并发编程里，Go语言`sync`包里的同步原语`Mutex`是我们经常用来保证并发安全的，那么他跟`atomic`包里的这些操作有啥区别呢？在我看来他们在使用目的和底层实现上都不一样：

* 使用目的：互斥锁是用来保护一段逻辑，原子操作用于对一个变量的更新保护。
* 底层实现：`Mutex`由**操作系统**的调度器实现，而`atomic`包中的原子操作则由**底层硬件指令**直接提供支持，这些指令在执行的过程中是不允许中断的，因此原子操作可以在`lock-free`的情况下保证并发安全，并且它的性能也能做到随`CPU`个数的增多而线性扩展。




### 互斥锁允许自旋的条件

线程没有获取到锁时常见有2种处理方式：

* 一种是没有获取到锁的线程就会循环等待判断该资源是否已经释放锁，这种锁也叫做自旋锁，它不用将线程阻塞起来， 适用于并发低且程序执行时间短的场景，缺点是cpu占用较高
* 另外一种处理方式就是把自己阻塞起来，会释放CPU给其他线程，内核会将线程置为「睡眠」状态，等到锁被释放后，内核会在合适的时机唤醒该线程，适用于高并发场景，缺点是有线程上下文切换的开销
  Go语言中的Mutex实现了自旋与阻塞两种场景，当满足不了自旋条件时，就会进入阻塞
  **允许自旋的条件：**

1. 锁已被占用，并且锁不处于饥饿模式。
2. 积累的自旋次数小于最大自旋次数（active_spin=4）。
3. cpu 核数大于 1。
4. 有空闲的 P。
5. 当前 goroutine 所挂载的 P 下，本地待运行队列为空。


### 读写锁的实现原理

读写锁的底层是基于互斥锁实现的。
写锁需要阻塞写锁：一个协程拥有写锁时，其他协程写锁定需要阻塞；
写锁需要阻塞读锁：一个协程拥有写锁时，其他协程读锁定需要阻塞；
读锁需要阻塞写锁：一个协程拥有读锁时，其他协程写锁定需要阻塞；
**读锁不能阻塞读锁：一个协程拥有读锁时，其他协程也可以拥有读锁。**


### "原子操作"有哪些

Go atomic包是最轻量级的锁（也称无锁结构），可以在不形成临界区和创建互斥量的情况下完成并发安全的值替换操作，不过这个包只支持int32/int64/uint32/uint64/uintptr这几种数据类型的一些基础操作（增减、交换、载入、存储等）
当我们想要对**某个变量**并发安全的修改，除了使用官方提供的 `mutex`，还可以使用 sync/atomic 包的原子操作，它能够保证对变量的读取或修改期间不被其他的协程所影响。
atomic 包提供的原子操作能够确保任一时刻只有一个goroutine对变量进行操作，善用 atomic 能够避免程序中出现大量的锁操作。
**常见操作：**

* 增减Add     AddInt32 AddInt64 AddUint32 AddUint64 AddUintptr
* 载入Load    LoadInt32 LoadInt64    LoadPointer    LoadUint32    LoadUint64    LoadUintptr
* 比较并交换   CompareAndSwap    CompareAndSwapInt32...
* 交换Swap    SwapInt32...
* 存储Store    StoreInt32...


### Goroutine 的底层实现原理

```go
g本质是一个数据结构,真正让 goroutine 运行起来的是调度器
type g struct { 
    goid int64  // 唯一的goroutine的ID 
    sched gobuf // goroutine切换时，用于保存g的上下文 
    stack stack // 栈 
    gopc // pc of go statement that created this goroutine 
    startpc uintptr  // pc of goroutine function ... 
} 
type gobuf struct {     //运行时寄存器
    sp uintptr  // 栈指针位置 
    pc uintptr  // 运行到的程序位置 
    g  guintptr // 指向 goroutine 
    ret uintptr // 保存系统调用的返回值 ... 
} 
type stack struct {     //运行时栈
    lo uintptr  // 栈的下界内存地址 
    hi uintptr  // 栈的上界内存地址 
}
```

### 

### goroutine 和线程的区别

内存占用:
创建一个 goroutine 的栈内存消耗为 2 KB，实际运行过程中，如果栈空间不够用，会自动进行扩容。创建一个 thread 则需要消耗 1 MB 栈内存。
创建和销毀:
Thread 创建和销毀需要陷入内核,系统调用。而 goroutine 因为是由 Go runtime 负责管理的，创建和销毁的消耗非常小，是用户级。
切换:
当 threads 切换时，需要保存各种寄存器,而 goroutines 切换只需保存三个寄存器：Program Counter, Stack Pointer and BP。一般而言，线程切换会消耗 1000-1500 ns,Goroutine 的切换约为 200 ns,因此，goroutines 切换成本比 threads 要小得多。


### Go 线程模型（Go底层怎么实现高并发的）

> 线程协程，进程的区别：
>
> [https://zhuanlan.zhihu.com/p/337978321](https://zhuanlan.zhihu.com/p/337978321)
>
> [https://www.bilibili.com/read/cv9346691/](https://www.bilibili.com/read/cv9346691/)

Golang的调度器是一个轻量级的协程调度器，主要负责管理和调度协程。Golang 中的调度器采用 **M:N 模型**，即 M 个用户级线程对应 N 个内核线程。

调度器会将 Golang 中的协程（goroutine）调度到不同的线程上运行，以实现并发执行的效果。

M个线程对应N个内核线程的优点：

* 能够利用多核
* 上下文切换成本低
* 如果进程中的一个线程被阻塞，不会阻塞其他线程，是能够切换同一进程内的其他线程继续执行

### Golang assertion 

## Golang调用方面

### len 统计长度
<font color = 'red'>len()计算的是字节的长度，和编码无关，对于英文和数组对象等，字节长度等效于实际长度</font>
当需要计算中文字符长度的时候，就需要调用其他的函数方法：
`utf8.RuneCountInString("中文")`
