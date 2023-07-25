---
title: Go basic knowledge
catalog: true
date: 2023-02-10 01:16:19
subtitle:
header-img:
tags:
categories: 
	- Basic
---
# Go 入门知识

> 本章节内容基于 https://tour.go-zh.org/  [Go语言测试平台](https://tour.go-zh.org/list) 索引整理完成
>
> 答案训练参考：
>
> https://gist.github.com/zyxar/2317744
>
> https://gist.github.com/CarlosLanderas/11b4f6727deec051883ddc02edf5cd0b
>
> 一些有用书籍索引：
>
> [Go语言圣经（中文版）](https://books.studygolang.com/gopl-zh/)
>
> [Go语言入门教程，Golang入门教程](http://c.biancheng.net/golang/)
>
> [《Go语言标准库》](https://books.studygolang.com/The-Golang-Standard-Library-by-Example/)

# 1. Go 包相关

## 1.1 路径

每个 Go 程序都是由包构成的。

程序从 `main`​​​ 包开始运行。

比如通过导入路径 `"fmt"`​​ 和 `"math/rand"`​​ 来使用这两个包。

按照约定，包名与导入路径的最后一个元素一致。例如，`"math/rand"`​​​ 包中的源码均以 `package rand`​​​ 语句开始。

‍

## 1.2 导入包

圆括号组合了导入，这是“分组”形式的导入语

# 2. 变量

注意类型在变量名之后 

```go
y int
```

‍

`var`​​​ 语句用于声明一个变量列表，跟函数的参数列表一样，类型在最后

```go
var a ,b c, d int
```

变量声明可以包含初始值，每个变量对应一个， 逗号隔开，如果初始化值已存在，则可以省略类型；变量会从初始值中获得类型。

```go
var i, j int = 1, 2
var c, python, java = true, false, "no!"
```

‍

简洁赋值语句 `:=`​​​ 可在类型明确的地方代替 `var`​​​ 声明。

函数外的每个语句都必须以关键字开始（`var`​​​, `func`​​​ 等等），因此 ​`:=`​​​​ 结构不能在函数外使用[相较之下 var 可以写到函数外面，在包层级]

```go
	k := 3
	c, python, java := true, false, "no!"
```

‍

**Go 的基本类型有**

```
bool

string

int  int8  int16  int32  int64
uint uint8 uint16 uint32 uint64 uintptr

byte // uint8 的别名

rune // int32 的别名
    // 表示一个 Unicode 码点

float32 float64

complex64 complex128
```

本例展示了几种类型的变量。 同导入语句一样，变量声明也可以“分组”成一个语法块。

```go
var (
	ToBe   bool       = false
	MaxInt uint64     = 1<<64 - 1
	z      complex128 = cmplx.Sqrt(-5 + 12i)
)
```

`int`​​​, `uint`​​​ 和 `uintptr`​​​ 在 32 位系统上通常为 32 位宽，在 64 位系统上则为 64 位宽。 当你需要一个整数值时应使用 `int`​​​ 类型，除非你有特殊的理由使用固定大小或无符号的整数类型。

‍

没有明确初始值的变量声明会被赋予它们的 **零值**。

零值是：

* 数值类型为 `0`​​​，
* 布尔类型为 `false`​​​，
* 字符串为 `""`​​​（空字符串）。

‍

表达式 `T(v)`​​​ 将值 `v`​​​ 转换为类型 `T`​​​。

一些关于数值的转换：

```
var i int = 42
var f float64 = float64(i)
var u uint = uint(f)
```

或者，更加简单的形式：

```
i := 42
f := float64(i)
u := uint(f)
```

与 C 不同的是，Go 在不同类型的项之间赋值时需要显式转换,，等号右边的数值必须是类型明确的

‍

## 2.1 常量

常量的声明与变量类似，只不过是使用 `const`​​​ 关键字。

常量可以是字符、字符串、布尔值或数值。

常量不能用 `:=`​​​ 语法声明。

```go
const World = "世界"
//相较之下，这个申明的world是一个变量，也就是可以改变其类型的
world := "世界"

	const World = "世界"
	fmt.Println("Hello", World)

	world := "世界"
	fmt.Println("Go rules?", world)
	world = "是吗"
	fmt.Println("Go rules?", world)
	结果是：
	Hello 世界
	Go rules? 世界
	Go rules? 是吗
```

‍

## 2.2 类型推导

在声明一个变量而不指定其类型时（即使用不带类型的 `:=`​​​ 语法或 `var =`​​​ 表达式语法），变量的类型由右值推导得出。

当右值声明了类型时，新变量的类型与其相同：

```
var i int
j := i // j 也是一个 int
```

不过当右边包含未指明类型的数值常量时，新变量的类型就可能是 `int`​​​, `float64`​​​ 或 `complex128`​​​ 了，这取决于常量的精度：

```
i := 42           // int
f := 3.142        // float64
g := 0.867 + 0.5i // complex128
```

‍

## 2.3 数值常量

数值常量是高精度的 **值**。

一个未指定类型的常量由上下文来决定其类型。

再尝试一下输出 `needInt(Big)`​​​ 吧。

（`int`​​​ 类型最大可以存储一个 64 位的整数，有时会更小。）

（`int`​​​​ 可以存放最大64位的整数，根据平台不同有时会更少。）

```go
const (
	// 将 1 左移 100 位来创建一个非常大的数字
	// 即这个数的二进制是 1 后面跟着 100 个 0
	Big = 1 << 100
	// 再往右移 99 位，即 Small = 1 << 1，或者说 Small = 2
	Small = Big >> 99
)
```

# 3. 语句

## 3.1 if

Go 的 `if`​​​​ 语句与 `for`​​​​ 循环类似，表达式外无需小括号 `( )`​​​​ ，而大括号 `{ }`​​​​ 则是必须的。

```go
if x < 0 {
	return sqrt(-x) + "i"
}
```

## 3.2 for

Go 只有一种循环结构：`for`​​​ 循环。

基本的 `for`​​​ 循环由三部分组成，它们用分号隔开：

* 初始化语句：在第一次迭代前执行
* 条件表达式：在每次迭代前求值
* 后置语句：在每次迭代的结尾执行

初始化语句通常为一句短变量声明，该变量声明仅在 `for`​​​ 语句的作用域中可见。

一旦条件表达式的布尔值为 `false`​​​，循环迭代就会终止。

初始化语句和后置语句是可选的，也就是说完全可以只有一个条件，其含义也变成了wihle语句，但是go里面没有while只有for

**注意**：和 C、Java、JavaScript 之类的语言不同，**Go 的 for 语句后面的三个构成部分外没有小括号**， 而包围函数主体的大括号 `{ }`​​​​ 则是必须的。

```go
package main

import "fmt"

func main() {
	sum := 0
	for i := 0; i < 10; i++ {
		sum += i
	}
	fmt.Println(sum)
}


func main() {
	sum := 1
	for sum < 1000{
		sum += sum
	}
	fmt.Println(sum)
}

```

‍

## 3.3 if 的简短语句

同 `for`​​​ 一样， `if`​​​ 语句可以在条件表达式前执行一个简单的语句。

**该语句声明的变量作用域仅在 ​****`if`**​​​**​ 之内。**也就是说出了if语句，这个变量就没有了

```go
func pow(x, n, lim float64) float64 {
	if v := math.Pow(x, n); v < lim {
		return v
	}
	return lim
}
```

‍

## 3.4 if 和 else

在 `if`​​ 的简短语句中声明的变量同样可以在任何对应的 `else`​​ 块中使用。

```go
if v := math.Pow(x, n); v < lim {
		return v
	} else {
		fmt.Printf("%g >= %g\n", v, lim)
	}


//一般格式是：
if {
}else if {
}else {}
```

  

## 3.5 switch

`switch`​​ 是编写一连串 `if - else`​​ 语句的简便方法。它运行第一个值等于条件表达式的 case 语句。

Go 的 switch 语句类似于 C、C++、Java、JavaScript 和 PHP 中的，不过 Go 只运行选定的 case，而非之后所有的 case。 实际上，Go 自动提供了在这些语言中每个 case 后面所需的 `break`​​ 语句。 除非以 `fallthrough`​​ 语句结束，否则分支会自动终止。 Go 的另一点重要的不同在于 switch 的 case 无需为常量，且取值不必为整数。

```go
	switch os := runtime.GOOS; os {
	case "darwin":
		fmt.Println("OS X.")
	case "linux":
		fmt.Println("Linux.")
	default:
		// freebsd, openbsd,
		// plan9, windows...
		fmt.Printf("%s.\n", os)
	}
```

‍

## 3.6 switch 的求值顺序

switch 的 case 语句从上到下顺次执行，直到匹配成功时停止。

（例如，  

```
switch i {
case 0:
case f():
}
```

在 `i==0`​​ 时 `f`​​ 不会被调用。  

```go
	today := time.Now().Weekday()
	switch time.Saturday {
	case today + 0:
		fmt.Println("Today.")
	case today + 1:
		fmt.Println("Tomorrow.")
	case today + 2:
		fmt.Println("In two days.")
	default:
		fmt.Println("Too far away.")
	}
```



## 3.7 没有条件的 switch

没有条件的 switch 同 `switch true`​​ 一样。

这种形式能将一长串 if-then-else 写得更加清晰。

```go
t := time.Now()
	switch {
	case t.Hour() < 12:
		fmt.Println("Good morning!")
	case t.Hour() < 17:
		fmt.Println("Good afternoon.")
	default:
		fmt.Println("Good evening.")
	}
```

‍

## 3.8 defer

defer 语句会将函数推迟到外层函数返回之后执行。

推迟调用的函数其参数会立即求值，但直到外层函数返回前该函数都不会被调用。

```go
package main

import "fmt"

func main() {
	defer fmt.Println("world")

	fmt.Println("hello")
}
结果是：
hello
world
```

‍

## 3.9 defer 栈

推迟的函数调用会被压入一个栈中。当外层函数返回时，被推迟的函数会按照后进先出的顺序调用。  

```go
package main

import "fmt"

func main() {
	fmt.Println("counting")

	for i := 0; i < 10; i++ {
		defer fmt.Println(i)
	}

	fmt.Println("done")
}
由于是按照栈的形式来存的
counting
done
9
8
7
6
5
4
3
2
1
0
```

[Defer，Panic,Recover](https://blog.go-zh.org/defer-panic-and-recover)

‍

## 3.10 函数返回

函数可以返回任意数量的返回值, 但是结构上需要结合函数形式

```go
func swap(x, y string) (string, string) {
	return y, x
}
```

‍

Go 的返回值可被命名，它们会被视作定义在函数顶部的变量。

返回值的名称应当具有一定的意义，它可以作为文档使用。

没有参数的 `return`​ 语句返回已命名的返回值。也就是 `直接`​ 返回。

直接返回语句应当仅用在下面这样的短函数中。在长的函数中它们会影响代码的可读性。

(x, y int) 中的（）不可以省略

```go
func split(sum int) (x, y int) {
	x = sum * 4 / 9
	y = sum - x
	return
}
```

‍

‍

## 3.11 Retrun and Defer

> ‍

![image](Y:/Blog/blog/source/_posts/Go/Go-basic-knowledge/assets/image-20230228154553-m65t587.png)​

```go
package main
 
import "fmt"
 
// return语句执行步骤
// 1、返回值赋值
// 2、defer语句
// 3、真正RET返回
func f0() (x int) {
	x = 5
	defer func() {
		x++
	}()
	return x //返回值RET=x, x++, RET=x=6
}
 
func f1() int {
	x := 5
	defer func() {
		x++ //修改的是x，不是返回值
	}()
	return x //返回值RET=5, x++, RET=5
}
 
func f2() (x int) {
	defer func() {
		x++
	}()
	return 5 //返回值RET=x=5, x++, RET=6
}
 
func f3() (y int) {
	x := 5
	defer func() {
		x++
	}()
	return x //返回值RET=y=x=5, x++, RET=5
}
 
func f4() (x int) {
	defer func(x int) {
		x++
	}(x)
	return 5 //返回值RET=x=5, x`++, RET=5
}
 
func main() {
	fmt.Println(f0()) //6
	fmt.Println(f1()) //5
	fmt.Println(f2()) //6
	fmt.Println(f3()) //5
	fmt.Println(f4()) //5
}
```

要注意的是实际返回的值和在函数内运算的值是不相同的对象，存在一个赋值的过程

首先要明确 defer 后紧接的代码可以有两种写法：

> 参考文章： 
>
> [Golang中defer和return的执行顺序 + 相关测试题（面试常考）](https://blog.csdn.net/qq_37102984/article/details/128946146?spm=1001.2101.3001.6650.1&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EAD_ESQUERY%7Eyljh-1-128946146-blog-116449166.pc_relevant_3mothn_strategy_and_data_recovery&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EAD_ESQUERY%7Eyljh-1-128946146-blog-116449166.pc_relevant_3mothn_strategy_and_data_recovery)
>
> [Golang Defer 深入理解](https://blog.csdn.net/qq_14997473/article/details/116449166)
>
> [汇编层面](https://cloud.tencent.com/developer/article/1453355)
>
> [Return的机制](https://haicoder.net/golang/golang-return.html)

* defer + 表达式，例如：  
  此时就会直接保留当前变量 x 已有的值到栈中，一直到最后直接打印输出，不再受后续 return x 结果的影响。例如$t e s t 1$ 和 $t e s t 2$中的变量 x 。 **例如 test1 和 test2 中的变量 x。**

  ```go
  defer fmt.Printf("in defer: x = %d\n", x
  ```

* defer + 匿名函数（无入参/有入参），例如：

  ```go
  defer func() {fmt.Printf("in defer: x = %d\n", x)}()
  或者是
  defer func(n int) {fmt.Printf("in defer x as parameter: x = %d\n", n) fmt.Printf("in defer x after return: x = %d\n", x)}(x)
  ```

  此时需要区分打印输出的变量到底是【defer匿名函数内要访问的变量 n】，还是【defer匿名函数内要访问的变量 x】。

  * 针对【defer匿名函数内要访问的变量 n】，其值取决于在一开始遇到 defer 时入参 n 的值（也就是最开始还没被改变时的变量 x 的值，起初是0）。这个变量 n 的值是独立的，不会受后续 return x 结果的影响。
  * 针对【defer匿名函数内要访问的变量 x】，由于匿名函数能访问外部函数的变量，也就是说【defer匿名函数内要访问的变量 x】最终会被【defer匿名函数外最终要 return 返回出去的变量 x】所影响。

‍

‍

# 4. 结构及指针

## 4.1 指针

Go 拥有指针。指针保存了值的内存地址。

类型 `*T`​ 是指向 `T`​ 类型值的指针。其零值为 `nil`​。

```
var p *int
```

`&`​​ 操作符会生成一个指向其操作数的指针。

所以当赋值的时候，或者是传输的时候只能够只用&p来表示获取到p的地址，*p是地址指向的内容

```
i := 42
p = &i
```

`*`​ 操作符表示指针指向的底层值。

```
fmt.Println(*p) // 通过指针 p 读取 i
*p = 21         // 通过指针 p 设置 i
```

这也就是通常所说的“间接引用”或“重定向”。

与 C 不同，Go 没有指针运算。

```go
package main

import "fmt"

func main() {
	i, j := 42, 2701

	p := &i         // 指向 i
	fmt.Println(*p) // 通过指针读取 i 的值
	*p = 21         // 通过指针设置 i 的值
	fmt.Println(i)  // 查看 i 的值

	p = &j         // 指向 j
	*p = *p / 37   // 通过指针对 j 进行除法运算
	fmt.Println(j) // 查看 j 的值
}
```

‍

## 4.2 结构体

一个结构体（`struct`​）就是一组字段（field）。

```go
type Vertex struct {
	X int
	Y int
}
```

## 4.3 结构体字段

结构体字段使用点号来访问。

```go
type Vertex struct {
	X int
	Y int
}

func main() {
	v := Vertex{1, 2}
	v.X = 4
	fmt.Println(v.X)
}
```

‍

## 4.4 结构体指针

结构体字段可以通过结构体指针来访问。

如果我们有一个指向结构体的指针 `p`​，那么可以通过 `(*p).X`​ 来访问其字段 `X`​。不过这么写太啰嗦了，所以语言也允许我们使用隐式间接引用，直接写 `p.X`​ 就可以。

```go
type Vertex struct {
	X int
	Y int
}

func main() {
	v := Vertex{1, 2}
	p := &v
	p.X = 1e9
	fmt.Println(v)
}

```

‍

## 4.5 结构体文法

结构体文法通过直接列出字段的值来新分配一个结构体。

使用 `Name:`​ 语法可以仅列出部分字段。（字段名的顺序无关。）

特殊的前缀 `&`​ 返回一个指向结构体的指针。

```go
type Vertex struct {
	X, Y int
}

var (
	v1 = Vertex{1, 2}  // 创建一个 Vertex 类型的结构体
	v2 = Vertex{X: 1}  // Y:0 被隐式地赋予
	v3 = Vertex{}      // X:0 Y:0
	p  = &Vertex{1, 2} // 创建一个 *Vertex 类型的结构体（指针）
)

func main() {
	fmt.Println(v1, p, v2, v3)
}
```

‍

## 4.6 数组

类型 `[n]T`​ 表示拥有 `n`​ 个 `T`​ 类型的值的数组。

表达式

```
var a [10]int
```

会将变量 `a`​ 声明为拥有 10 个整数的数组。

数组的长度是其类型的一部分，**因此数组不能改变大小**。这看起来是个限制，不过没关系，Go 提供了更加便利的方式来使用数组。

```go
package main

import "fmt"

func main() {
	var a [2]string
	a[0] = "Hello"
	a[1] = "World"
	fmt.Println(a[0], a[1])
	fmt.Println(a)

	primes := [6]int{2, 3, 5, 7, 11, 13}
	fmt.Println(primes)
}
```

‍

‍

## 4.7 切片

每个数组的大小都是固定的。而切片则为数组元素提供动态大小的、灵活的视角。在实践中，切片比数组更常用。

切片可以看作是对数组的划分，也就是说原数组是一个全集，切片就是其依据不同标准划分的子集

类型 `[]T`​ 表示一个元素类型为 `T`​ 的切片。

切片通过两个下标来界定，即一个上界和一个下界，二者以冒号分隔：

```
a[low : high]
```

它会选择一个半开区间，包括第一个元素，但排除最后一个元素。

以下表达式创建了一个切片，它包含 `a`​ 中下标从 1 到 3 的元素：

```
a[1:4]
```

切片就像数组的引用

切片并不存储任何数据，它只是描述了底层数组中的一段。

更改切片的元素会修改其底层数组中对应的元素。

与它**共享底层数组**的切片都会观测到这些修改（也就是说它是一种深拷贝）

```go
package main

import "fmt"

func main() {
	names := [4]string{
		"John",
		"Paul",
		"George",
		"Ringo",
	}
	fmt.Println(names)

	a := names[0:2]
	b := names[1:3]
	fmt.Println(a, b)

	b[0] = "XXX"
	fmt.Println(a, b)
	fmt.Println(names)
}

```

‍

## 4.8 切片文法

切片文法类似于没有长度的数组文法。

这是一个数组文法：**构建的是一个数组**

```
[3]bool{true, true, false}
```

下面这样则会创建一个和上面相同的数组，然后构建一个引用了它的切片：

```
[]bool{true, true, false}
```

‍

## 4.9 切片的默认行为

在进行切片时，你可以利用它的默认行为来忽略上下界。

切片下界的默认值为 `0`​，上界则是该切片的长度。

对于数组

```
var a [10]int
```

来说，以下切片是等价的：

```
a[0:10]
a[:10]
a[0:]
a[:]
```

可以明确的是：

1. 数组和切片不能够相互赋值

   ```go
   这个函数不可行，因为s 初始化的是一个数组，之后不能够赋值给切片
   func main() {
   	s := [6]int{2, 3, 5, 7, 11, 13}
   	s = s[1:4]
   	fmt.Println(s)
   }
   报错显示：
   ./prog.go:8:7: cannot use s[1:4] (value of type []int) as [6]int value in assignment
   
   ```

‍

## 4.10 切片的长度与容量

切片拥有 **长度** 和 **容量**。

切片的长度就是它所包含的元素个数。

切片的容量是从它的第一个元素开始数，到其底层数组元素末尾的个数；容量也可以理解为切片总的能够扩展的（包括长度）数量

切片 `s`​ 的长度和容量可通过表达式 `len(s)`​ 和 `cap(s)`​ 来获取。

你可以通过重新切片来扩展一个切片，给它提供足够的容量

```go
package main

import "fmt"

func main() {
	s := []int{2, 3, 5, 7, 11, 13}
	printSlice(s)

	// 截取切片使其长度为 0
	s = s[:0]
	printSlice(s)

	// 拓展其长度
	s = s[:4]
	printSlice(s)

	// 舍弃前两个值
	s = s[2:]
	printSlice(s)
}

func printSlice(s []int) {
	fmt.Printf("len=%d cap=%d %v\n", len(s), cap(s), s)
}
```

‍

## 4.11 nil 切片

切片的零值是 `nil`​。

nil 切片的长度和容量为 0 且没有底层数组。

‍

## 4.12 用 make 创建切片

切片可以用内建函数 `make`​ 来创建，这也是你创建动态数组的方式。

`make`​ 函数会分配一个元素为零值的数组并返回一个引用了它的切片：

```
a := make([]int, 5)  // len(a)=5
```

要指定它的容量，需向 `make`​ 传入第三个参数：

```
b := make([]int, 0, 5) // len(b)=0, cap(b)=5

b = b[:cap(b)] // len(b)=5, cap(b)=5
b = b[1:]      // len(b)=4, cap(b)=4
```

```go
package main

import "fmt"

func main() {
	a := make([]int, 5)
	printSlice("a", a)

	b := make([]int, 0, 5)
	printSlice("b", b)

	c := b[:2]
	printSlice("c", c)

	d := c[2:5]
	printSlice("d", d)
}

func printSlice(s string, x []int) {
	fmt.Printf("%s len=%d cap=%d %v\n",
		s, len(x), cap(x), x)
}

结果显示为：
a len=5 cap=5 [0 0 0 0 0]
b len=0 cap=5 []
c len=2 cap=5 [0 0]
d len=3 cap=3 [0 0 0]

```

‍

## 4. 13 创建二维切片：

> 参考文献：
>
> [直接参考的](https://www.cnblogs.com/yahuian/p/11934122.html)
>
> [Stack  例子讲解：](https://stackoverflow.com/questions/39804861/what-is-a-concise-way-to-create-a-2d-slice-in-go)
>
> [make 和  new 的区别](https://stackoverflow.com/questions/9320862/why-would-i-make-or-new)
>
> [二维数组的结合](https://stackoverflow.com/questions/39561140/what-is-two-dimensional-arrays-memory-representation)

最常用的方法，需要记忆：

```go
a := make([][]uint8, dy)
for i := range a {
    a[i] = make([]uint8, dx)
}
```

```go
	// 方法0
	row, column := 3, 4
	var answer [][]int
	for i := 0; i < row; i++ {
		inline := make([]int, column)
		answer = append(answer, inline)
	}
	fmt.Println(answer)

	// 方法1，最常用
	answer1 := make([][]int, row)
	for i := range answer1 {
		answer1[i] = make([]int, column)
	}

```

‍

‍

## 4. 14 切片的切片

切片可包含任何类型，甚至包括其它的切片[参照二维数组]

```go
package main

import (
	"fmt"
	"strings"
)

func main() {
	// 创建一个井字板（经典游戏）
	board := [][]string{
		[]string{"_", "_", "_"},
		[]string{"_", "_", "_"},
		[]string{"_", "_", "_"},
	}

	// 两个玩家轮流打上 X 和 O
	board[0][0] = "X"
	board[2][2] = "O"
	board[1][2] = "X"
	board[1][0] = "O"
	board[0][2] = "X"

	for i := 0; i < len(board); i++ {
		fmt.Printf("%s\n", strings.Join(board[i], " "))
	}
}
```

## 4. 15 向切片追加元素

为切片追加新的元素是种常用的操作，为此 Go 提供了内建的 `append`​ 函数。内建函数的[文档](https://go-zh.org/pkg/builtin/#append)对此函数有详细的介绍。

```
func append(s []T, vs ...T) []T
```

`append`​ 的第一个参数 `s`​ 是一个元素类型为 `T`​ 的切片，其余类型为 `T`​ 的值将会追加到该切片的末尾。

`append`​ 的结果是一个包含原切片所有元素加上新添加元素的切片。

当 `s`​ 的底层数组太小，不足以容纳所有给定的值时，它就会分配一个更大的数组。返回的切片会指向这个新分配的数组。

```go
package main

import "fmt"

func main() {
	var s []int
	printSlice(s)

	// 添加一个空切片
	s = append(s, 0)
	printSlice(s)

	// 这个切片会按需增长
	s = append(s, 1)
	printSlice(s)

	// 可以一次性添加多个元素
	s = append(s, 2, 3, 4)
	printSlice(s)
}

func printSlice(s []int) {
	fmt.Printf("len=%d cap=%d %v\n", len(s), cap(s), s)
}
```

可参考文章：  [Go 切片：用法和本质](https://blog.go-zh.org/go-slices-usage-and-internals)

‍

## 4. 16 Range

`for`​ 循环的 `range`​ 形式可遍历切片或映射。

当使用 `for`​ 循环遍历切片时，每次迭代都会返回两个值。第一个值为当前元素的下标，第二个值为该下标所对应元素的一份副本。

```go
package main

import "fmt"

var pow = []int{1, 2, 4, 8, 16, 32, 64, 128}

func main() {
	for i, v := range pow {
		fmt.Printf("2**%d = %d\n", i, v)
	}
}

```

‍

## 4. 17 range（续）

可以将下标或值赋予 `_`​ 来忽略它。

```
for i, _ := range pow
for _, value := range pow
```

若你只需要索引，忽略第二个变量即可。

```
for i := range pow
```

‍

## 4. 18 映射（Map）

映射将键映射到值。

映射的零值为 `nil`​ 。`nil`​ 映射既没有键，也不能添加键。

`make`​ 函数会返回给定类型的映射，并将其初始化备用。

```go
package main

import "fmt"

type Vertex struct {
	Lat, Long float64
}

var m map[string]Vertex

func main() {
	m = make(map[string]Vertex)
	m["Bell Labs"] = Vertex{
		40.68433, -74.39967,
	}
	fmt.Println(m["Bell Labs"])
}
```



## 4. 19 映射的文法

映射的文法与结构体相似，不过必须有键名。

若顶级类型只是一个类型名，你可以在文法的元素中省略它。

```go
package main

import "fmt"

type Vertex struct {
	Lat, Long float64
}

var m = map[string]Vertex{
	"Bell Labs": {40.68433, -74.39967},
	"Google":    {37.42202, -122.08408},
}

func main() {
	fmt.Println(m)
}

```

‍

## 4. 20 修改映射

在映射 `m`​ 中插入或修改元素：

```
m[key] = elem
```

获取元素：

```
elem = m[key]
```

删除元素：

```
delete(m, key)
```

通过双赋值检测某个键是否存在：

```
elem, ok = m[key]
```

若 `key`​ 在 `m`​ 中，`ok`​ 为 `true`​ ；否则，`ok`​ 为 `false`​。

若 `key`​ 不在映射中，那么 `elem`​ 是该映射元素类型的零值。

同样的，当从映射中读取某个不存在的键时，结果是映射的元素类型的零值。

**注** ：若 `elem`​ 或 `ok`​ 还未声明，你可以使用短变量声明：

```
elem, ok := m[key]
```

```go
package main

import "fmt"

func main() {
	m := make(map[string]int)

	m["Answer"] = 42
	fmt.Println("The value:", m["Answer"])

	m["Answer"] = 48
	fmt.Println("The value:", m["Answer"])

	delete(m, "Answer")
	fmt.Println("The value:", m["Answer"])

	v, ok := m["Answer"]
	fmt.Println("The value:", v, "Present?", ok)
}

```

‍

‍

## 4. 21 函数值

函数也是值。它们可以像其它值一样传递。

函数值可以用作函数的参数或返回值。

```go
package main

import (
	"fmt"
	"math"
)

func compute(fn func(float64, float64) float64) float64 {
	return fn(3, 4)
}

func main() {
	hypot := func(x, y float64) float64 {
		return math.Sqrt(x*x + y*y)
	}
	fmt.Println(hypot(5, 12))

	fmt.Println(compute(hypot))
	fmt.Println(compute(math.Pow))
}
```

‍

## 4. 22 函数的闭包

Go 函数可以是一个闭包。闭包是一个函数值，它引用了其函数体之外的变量。该函数可以访问并赋予其引用的变量的值，换句话说，该函数被这些变量“绑定”在一起。

例如，函数 `adder`​ 返回一个闭包。每个闭包都被绑定在其各自的 `sum`​ 变量上。

```go
package main

import "fmt"

func adder() func(int) int {
	sum := 0
	return func(x int) int {
		sum += x
		return sum
	}
}

func main() {
	pos, neg := adder(), adder()
	for i := 0; i < 10; i++ {
		fmt.Println(
			pos(i),
			neg(-2*i),
		)
	}
}

最终的结果是：
0 0
1 -2
3 -6
6 -12
10 -20
15 -30
21 -42
28 -56
36 -72
45 -90
```

‍

‍

# 5. 方法和接口

## 5.1 方法

Go 没有类。不过你可以为结构体类型定义方法。

方法就是一类带特殊的 ​**接收者**​ 参数的函数。

方法接收者在它自己的参数列表内，位于 `func`​ 关键字和方法名之间。

在此例中，`Abs`​ 方法拥有一个名为 `v`​，类型为 `Vertex`​ 的接收者。

```go
package main

import (
	"fmt"
	"math"
)

type Vertex struct {
	X, Y float64
}

func (v Vertex) Abs() float64 {
	return math.Sqrt(v.X*v.X + v.Y*v.Y)
}

func main() {
	v := Vertex{3, 4}
	fmt.Println(v.Abs())
}
```

方法即函数

记住：方法只是个带接收者参数的函数。

现在这个 `Abs`​ 的写法就是个正常的函数，功能并没有什么变化。

```go
package main

import (
	"fmt"
	"math"
)

type Vertex struct {
	X, Y float64
}

func Abs(v Vertex) float64 {
	return math.Sqrt(v.X*v.X + v.Y*v.Y)
}

func main() {
	v := Vertex{3, 4}
	fmt.Println(Abs(v))
}
```

但是这个是函数，并不能够通过v对象直接调用

‍

## 5.2 方法（续）

你也可以为非结构体类型声明方法。

在此例中，我们看到了一个带 `Abs`​ 方法的数值类型 `MyFloat`​。

你只能为在同一包内定义的类型的接收者声明方法，而不能为其它包内定义的类型（包括 `int`​ 之类的内建类型）的接收者声明方法。

（译注：就是接收者的类型定义和方法声明必须在同一包内；不能为内建类型声明方法。）

```go
package main

import (
	"fmt"
	"math"
)

type MyFloat float64

func (f MyFloat) Abs() float64 {
	if f < 0 {
		return float64(-f)
	}
	return float64(f)
}

func main() {
	f := MyFloat(-math.Sqrt2)
	fmt.Println(f.Abs())
}
```

‍

## 5.3 指针接收者

你可以为指针接收者声明方法。

这意味着对于某类型 `T`​，接收者的类型可以用 `*T`​ 的文法。（**此外，****`T`**​**​ 不能是像 ​****`*int`**​**​ 这样的指针，换句话说就是没有双指针。**不能够出现**int这样的结构）

例如，这里为 `*Vertex`​ 定义了 `Scale`​ 方法。

指针接收者的方法可以修改接收者指向的值（就像 `Scale`​ 在这做的）。由于方法经常需要修改它的接收者，指针接收者比值接收者更常用。

试着移除第 16 行 `Scale`​ 函数声明中的 `*`​，观察此程序的行为如何变化。

若使用值接收者，那么 `Scale`​ 方法会对原始 `Vertex`​ 值**的副本**进行操作。（对于函数的其它参数也是如此。）`Scale`​ 方法必须用指针接受者来更改 `main`​ 函数中声明的 `Vertex`​ 的值。也就是说使用指针的时候才能够对原本的数据结构当中的值做修改，但如果使用值接收者，就会修改一个副本，那么函数之间的调用修改就会不起作用，生命周期只在这个函数当中完成。

```go
package main

import (
	"fmt"
	"math"
)

type Vertex struct {
	X, Y float64
}

func (v Vertex) Abs() float64 {
	return math.Sqrt(v.X*v.X + v.Y*v.Y)
}

//使用指针接收者，结果会是50 ，也就是说本函数的修改，abs能够获取到
func (v *Vertex) Scale(f float64) {
	v.X = v.X * f
	v.Y = v.Y * f
}
//使用值接收者，结果会是5，也就是说本函数的修改只在本函数当中，abs无法感知到v.x,v.y的值发生变化
func (v Vertex) Scale(f float64) {
	v.X = v.X * f
	v.Y = v.Y * f
}


func main() {
	v := Vertex{3, 4}
	v.Scale(10)
	fmt.Println(v.Abs())
}
```

![image](Y:/Blog/blog/source/_posts/Go/Go-basic-knowledge/assets/image-20230228103213-yqcw1ma.png)​

‍

## 5.4 方法与指针重定向

比较前两个程序，你大概会注意到**带指针参数的函数必须接受一个指针**：

```
var v Vertex
ScaleFunc(v, 5)  // 编译错误！
ScaleFunc(&v, 5) // OK
```

而以**指针为接收者的方法被调用时，接收者既能为值又能为指针：**

```
var v Vertex
v.Scale(5)  // OK
p := &v
p.Scale(10) // OK
```

对于语句 `v.Scale(5)`​，即便 `v`​ 是个值而非指针，带指针接收者的方法也能被直接调用。 也就是说，由于 `Scale`​ 方法有一个指针接收者，为方便起见，Go 会将语句 `v.Scale(5)`​ 解释为 `(&v).Scale(5)`​。

```go
package main

import "fmt"

type Vertex struct {
	X, Y float64
}

func (v *Vertex) Scale(f float64) {
	v.X = v.X * f
	v.Y = v.Y * f
}

func ScaleFunc(v *Vertex, f float64) {
	v.X = v.X * f
	v.Y = v.Y * f
}

func main() {
	v := Vertex{3, 4}
	v.Scale(2)
	ScaleFunc(&v, 10)

	p := &Vertex{4, 3}
	p.Scale(3)
	ScaleFunc(p, 8)

	fmt.Println(v, p)
}
```

同样的事情也发生在相反的方向。

接受一个值作为参数的函数必须接受一个指定类型的值：

```
var v Vertex
fmt.Println(AbsFunc(v))  // OK
fmt.Println(AbsFunc(&v)) // 编译错误！
```

而以值为接收者的方法被调用时，接收者既能为值又能为指针：

```
var v Vertex
fmt.Println(v.Abs()) // OK
p := &v
fmt.Println(p.Abs()) // OK
```

这种情况下，方法调用 `p.Abs()`​ 会被解释为 `(*p).Abs()`​。

‍

## 5.5 选择值或指针作为接收者

使用指针接收者的原因有二：

首先，方法能够修改其接收者指向的值。

其次，这样可以避免在每次调用方法时复制该值。若值的类型为大型结构体时，这样做会更加高效。

在本例中，`Scale`​ 和 `Abs`​ 接收者的类型为 `*Vertex`​，即便 `Abs`​ 并不需要修改其接收者。

通常来说，所有给定类型的方法都应该有值或指针接收者，但并不应该二者混用。

```go
package main

import (
	"fmt"
	"math"
)

type Vertex struct {
	X, Y float64
}

func (v *Vertex) Scale(f float64) {
	v.X = v.X * f
	v.Y = v.Y * f
}

func (v *Vertex) Abs() float64 {
	return math.Sqrt(v.X*v.X + v.Y*v.Y)
}

func main() {
	v := &Vertex{3, 4}
	fmt.Printf("Before scaling: %+v, Abs: %v\n", v, v.Abs())
	v.Scale(5)
	fmt.Printf("After scaling: %+v, Abs: %v\n", v, v.Abs())
}

结果显示是：
Before scaling: &{X:3 Y:4}, Abs: 5
After scaling: &{X:15 Y:20}, Abs: 25
```

‍

## 5. 6 接口 

**接口类型** 是由一组方法签名定义的集合。

> 参考文献 ：
>
> [接口常见知识](https://blog.kennycoder.io/2020/02/03/Golang-%E6%B7%B1%E5%85%A5%E7%90%86%E8%A7%A3interface%E5%B8%B8%E8%A6%8B%E7%94%A8%E6%B3%95/)

接口类型的变量可以保存任何实现了这些方法的值。

> 接口就可以理解为一系列动作的集合  
> **而某个struct能够实现里面的所有方法，那么这个struct就是这个接口的一个实现**

**注意:** 示例代码的 22 行存在一个错误。由于 `Abs`​ 方法只为 `*Vertex`​ （指针类型）定义，因此 `Vertex`​（值类型）并未实现 `Abser`​。

```go
type Abser interface {
	Abs() float64
}

func main() {
	var a Abser
	f := MyFloat(-math.Sqrt2)
	v := Vertex{3, 4}

	a = f  // a MyFloat 实现了 Abser
	a = &v // a *Vertex 实现了 Abser

	// 下面一行，v 是一个 Vertex（而不是 *Vertex）
	// 所以没有实现 Abser。
	a = v

	fmt.Println(a.Abs())
}

type MyFloat float64

func (f MyFloat) Abs() float64 {
	if f < 0 {
		return float64(-f)
	}
	return float64(f)
}

type Vertex struct {
	X, Y float64
}

func (v *Vertex) Abs() float64 {
	return math.Sqrt(v.X*v.X + v.Y*v.Y)
}

显示错误：
./prog.go:22:6: cannot use v (variable of type Vertex) as Abser value in assignment: Vertex does not implement Abser (method Abs has pointer receiver)
```

‍

## 5.7 接口与隐式实现

类型通过实现一个接口的所有方法来实现该接口。既然无需专门显式声明，也就没有“implements”关键字。

隐式接口从接口的实现中解耦了定义，这样接口的实现可以出现在任何包中，无需提前准备。

因此，也就无需在每一个实现上增加新的接口名称，这样同时也鼓励了明确的接口定义。

```go
package main

import "fmt"

type I interface {
	M()
}

type T struct {
	S string
}

// 此方法表示类型 T 实现了接口 I，但我们无需显式声明此事。
func (t T) M() {
	fmt.Println(t.S)
}

func main() {
	var i I = T{"hello"}
	i.M()
}
```

‍

## 5.8 接口值

接口也是值。它们可以像其它值一样传递。

接口值可以用作函数的参数或返回值。

在内部，接口值可以看做包含值和具体类型的元组：

```
(value, type)
```

接口值保存了一个具体底层类型的具体值。

接口值调用方法时会执行其底层类型的同名方法

```go
package main

import (
	"fmt"
	"math"
)

type I interface {
	M()
}

type T struct {
	S string
}

func (t *T) M() {
	fmt.Println(t.S)
}

type F float64

func (f F) M() {
	fmt.Println(f)
}

func main() {
	var i I

	i = &T{"Hello"}
	describe(i)
	i.M()

	i = F(math.Pi)
	describe(i)
	i.M()
}

func describe(i I) {
	fmt.Printf("(%v, %T)\n", i, i)
}

输出结果是：
//因为 T 实现是传入（* T）

(&{Hello}, *main.T)
Hello

//因为 F 实现是传入（F）
(3.141592653589793, main.F)
3.141592653589793
```

在上述代码当中的接口值是：(&{Hello}, *main.T) 以及 (3.141592653589793, main.F)

‍

## 5.9 底层值为 nil 的接口值

即便接口内的具体值为 nil，方法仍然会被 nil 接收者调用。

在一些语言中，这会触发一个空指针异常，但在 Go 中通常会写一些方法来优雅地处理它（如本例中的 `M`​ 方法）。

**注意:** 保存了 nil 具体值的接口其自身并不为 nil。

```go
package main

import "fmt"

type I interface {
	M()
}

type T struct {
	S string
}

func (t *T) M() {
	if t == nil {
		fmt.Println("<nil>")
		return
	}
	fmt.Println(t.S)
}

func main() {
	var i I

	var t *T
	i = t
	describe(i)
	i.M()

	i = &T{"hello"}
	describe(i)
	i.M()
}

func describe(i I) {
	fmt.Printf("(%v, %T)\n", i, i)
}

记结果输出为：
(<nil>, *main.T)
<nil>
(&{hello}, *main.T)
hello
```

‍

## 5.10 nil 接口值

nil 接口值既不保存值也不保存具体类型。

为 nil 接口调用方法会产生运行时错误，因为接口的元组内并未包含能够指明该调用哪个 **具体** 方法的类型。

```go
package main

import "fmt"

type I interface {
	M()
}

func main() {
	var i I
	describe(i)
	i.M()
}

func describe(i I) {
	fmt.Printf("(%v, %T)\n", i, i)
}

```

```go
上述代码会显示：
(<nil>, <nil>)
panic: runtime error: invalid memory address or nil pointer dereference
[signal SIGSEGV: segmentation violation code=0x1 addr=0x0 pc=0x481961]

goroutine 1 [running]:
main.main()
	/tmp/sandbox4223192970/prog.go:12 +0x61
```

‍

以上两者是不同的概念：

第一个是接口对象不为空，但是对象指向的地方为空，也就是说接口申明了之后，还是给了他一个赋值的对象，但这个对象可能还没有初始化

第二个是接口对象为空

‍

## 5.11 空接口

指定了零个方法的接口值被称为 *空接口：*

```
interface{}
```

空接口可保存任何类型的值。（因为每个类型都至少实现了零个方法。）

空接口被用来处理未知类型的值。例如，`fmt.Print`​ 可接受类型为 `interface{}`​ 的任意数量的参数。

```go
package main

import "fmt"

func main() {
	var i interface{}
	describe(i)

	i = 42
	describe(i)

	i = "hello"
	describe(i)
}

func describe(i interface{}) {
	fmt.Printf("(%v, %T)\n", i, i)
}
```

‍

## 5.12 类型断言

> [断言具体释义](https://blog.kalan.dev/posts/golang-type-assertion)

**类型断言** 提供了**访问接口值底层具体值**的方式。

```
t := i.(T)
```

该语句断言接口值 `i`​ 保存了具体类型 `T`​，并将其底层类型为 `T`​ 的值赋予变量 `t`​。

若 `i`​ 并未保存 `T`​ 类型的值，该语句就会触发一个恐慌。

为了 **判断** 一个接口值是否保存了一个特定的类型，类型断言可返回两个值：其底层值以及一个报告断言是否成功的布尔值。

```
t, ok := i.(T)
```

若 `i`​ 保存了一个 `T`​，那么 `t`​ 将会是其底层值，而 `ok`​ 为 `true`​。

否则，`ok`​ 将为 `false`​ 而 `t`​ 将为 `T`​ 类型的零值，程序并不会产生恐慌。

请注意这种语法和读取一个映射时的相同之处。

```go
package main

import "fmt"

func main() {
	var i interface{} = "hello"

	s := i.(string)
	fmt.Println(s)

	s, ok := i.(string)
	fmt.Println(s, ok)

	f, ok := i.(float64)
	fmt.Println(f, ok)

	f = i.(float64) // 报错(panic)
	fmt.Println(f)
}


结果显示为：
hello
hello true
0 false
panic: interface conversion: interface {} is string, not float64
```

‍

## 5.13 类型选择

**类型选择** 是一种按顺序从几个类型断言中选择分支的结构。

类型选择与一般的 switch 语句相似，不过类型选择中的 case 为类型（而非值）， 它们针对给定接口值所存储的值的类型进行比较。

```
switch v := i.(type) {
case T:
    // v 的类型为 T
case S:
    // v 的类型为 S
default:
    // 没有匹配，v 与 i 的类型相同
}
```

类型选择中的声明与类型断言 `i.(T)`​ 的语法相同，**只是具体类型 ​****`T`****​ 被替换成了关键字 ​****`type`****。**

此选择语句判断接口值 `i`​ 保存的值类型是 `T`​ 还是 `S`​。在 `T`​ 或 `S`​ 的情况下，变量 `v`​ 会分别按 `T`​ 或 `S`​ 类型保存 `i`​ 拥有的值。在默认（即没有匹配）的情况下，变量 `v`​ 与 `i`​ 的接口类型和值相同。

```go
package main

import "fmt"

func do(i interface{}) {
	switch v := i.(type) {
	case int:
		fmt.Printf("Twice %v is %v\n", v, v*2)
	case string:
		fmt.Printf("%q is %v bytes long\n", v, len(v))
	default:
		fmt.Printf("I don't know about type %T!\n", v)
	}
}

func main() {
	do(21)
	do("hello")
	do(true)
}

结果是：
Twice 21 is 42
"hello" is 5 bytes long
I don't know about type bool!
```

‍

## 5. 14 Stringer

[fmt](https://go-zh.org/pkg/fmt/)``​ 包中定义的 [Stringer](https://go-zh.org/pkg/fmt/#Stringer)``​ 是最普遍的接口之一。

```
type Stringer interface {
    String() string
}
```

`Stringer`​ 是一个可以用字符串描述自己的类型。`fmt`​ 包（还有很多包）都通过此接口来打印值。

```go
package main

import "fmt"

type Person struct {
	Name string
	Age  int
}

func (p Person) String() string {
	return fmt.Sprintf("%v (%v years)", p.Name, p.Age)
}

func main() {
	a := Person{"Arthur Dent", 42}
	z := Person{"Zaphod Beeblebrox", 9001}
	fmt.Println(a, z)
}

```

‍

## 5. 15 错误

Go 程序使用 `error`​ 值来表示错误状态。

与 `fmt.Stringer`​ 类似，`error`​ 类型是一个内建接口：

```
type error interface {
    Error() string
}
```

（与 `fmt.Stringer`​ 类似，`fmt`​ 包在打印值时也会满足 `error`​。）

通常函数会返回一个 `error`​ 值，调用的它的代码应当判断这个错误是否等于 `nil`​ 来进行错误处理。

```
i, err := strconv.Atoi("42")
if err != nil {
    fmt.Printf("couldn't convert number: %v\n", err)
    return
}
fmt.Println("Converted integer:", i)
```

`error`​ 为 nil 时表示成功；非 nil 的 `error`​ 表示失败

```go
package main

import (
	"fmt"
	"time"
)

type MyError struct {
	When time.Time
	What string
}

func (e *MyError) Error() string {
	return fmt.Sprintf("at %v, %s",
		e.When, e.What)
}

func run() error {
	return &MyError{
		time.Now(),
		"it didn't work",
	}
}

func main() {
	if err := run(); err != nil {
		fmt.Println(err)
	}
}

```



## 5. 16 Reader

`io`​ 包指定了 `io.Reader`​ 接口，它表示从数据流的末尾进行读取。

Go 标准库包含了该接口的[许多实现](https://go-zh.org/search?q=Read#Global)，包括文件、网络连接、压缩和加密等等。

`io.Reader`​ 接口有一个 `Read`​ 方法：

```
func (T) Read(b []byte) (n int, err error)
```

`Read`​ 用数据填充给定的字节切片并返回填充的字节数和错误值。在遇到数据流的结尾时，它会返回一个 `io.EOF`​ 错误。

示例代码创建了一个 [strings.Reader](https://go-zh.org/pkg/strings/#Reader)``​ 并以每次 8 字节的速度读取它的输出。

```go
package main

import (
	"fmt"
	"io"
	"strings"
)

func main() {
	r := strings.NewReader("Hello, Reader!")

	b := make([]byte, 8)
	for {
		n, err := r.Read(b)
		fmt.Printf("n = %v err = %v b = %v\n", n, err, b)
		fmt.Printf("b[:n] = %q\n", b[:n])
		if err == io.EOF {
			break
		}
	}
}

输出结果是：
n = 8 err = <nil> b = [72 101 108 108 111 44 32 82]
b[:n] = "Hello, R"
n = 6 err = <nil> b = [101 97 100 101 114 33 32 82]
b[:n] = "eader!"
n = 0 err = EOF b = [101 97 100 101 114 33 32 82]
b[:n] = ""
```

‍

‍

## 5.17 图像

[image](https://go-zh.org/pkg/image/#Image)``​ 包定义了 `Image`​ 接口：

```
package image

type Image interface {
    ColorModel() color.Model
    Bounds() Rectangle
    At(x, y int) color.Color
}
```

**注意:** `Bounds`​ 方法的返回值 `Rectangle`​ 实际上是一个 [image.Rectangle](https://go-zh.org/pkg/image/#Rectangle)``​，它在 `image`​ 包中声明。

（请参阅[文档](https://go-zh.org/pkg/image/#Image)了解全部信息。）

`color.Color`​ 和 `color.Model`​ 类型也是接口，但是通常因为直接使用预定义的实现 `image.RGBA`​ 和 `image.RGBAModel`​ 而被忽视了。这些接口和类型由 [image/color](https://go-zh.org/pkg/image/color/)``​ 包定义。

```go
package main

import (
	"fmt"
	"image"
)

func main() {
	m := image.NewRGBA(image.Rect(0, 0, 100, 100))
	fmt.Println(m.Bounds())
	fmt.Println(m.At(0, 0).RGBA())
}

```

# 6.  并发编程

## 6.1  Go 协程

Go 协程（goroutine）是由 Go 运行时管理的轻量级线程。

```
go f(x, y, z)
```

会启动一个新的 Go 程并执行

```
f(x, y, z)
```

`f`​, `x`​, `y`​ 和 `z`​ 的求值发生在当前的 Go 程中，而 `f`​ 的执行发生在新的 Go 程中。

Go 程在相同的地址空间中运行，因此在访问共享的内存时必须进行同步。[sync](https://go-zh.org/pkg/sync/)``​ 包提供了这种能力，不过在 Go 中并不经常用到。

```go
package main

import (
	"fmt"
	"time"
)

func say(s string) {
	for i := 0; i < 5; i++ {
		time.Sleep(100 * time.Millisecond)
		fmt.Println(s)
	}
}

func main() {
	go say("world")
	say("hello")
}
```

‍

## 6.2 信道

信道是带有类型的管道，你可以通过它用信道操作符 `<-`​ 来发送或者接收值。

```
ch <- v    // 将 v 发送至信道 ch。
v := <-ch  // 从 ch 接收值并赋予 v。
```

（“箭头”就是数据流的方向。）

和映射与切片一样，信道在使用前必须创建，也是使用make的形式创建

```
ch := make(chan int)
```

默认情况下，发送和接收操作在另一端准备好之前都会阻塞。这使得 Go 程可以在没有显式的锁或竞态变量的情况下进行同步。

以下示例对切片中的数进行求和，将任务分配给两个 Go 程。一旦两个 Go 程完成了它们的计算，它就能算出最终的结果。

```go
package main

import "fmt"

func sum(s []int, c chan int) {
	sum := 0
	for _, v := range s {
		sum += v
	}
	c <- sum // 将和送入 c
}

func main() {
	s := []int{7, 2, 8, -9, 4, 0}

	c := make(chan int)
	go sum(s[:len(s)/2], c)
	go sum(s[len(s)/2:], c)
	x, y := <-c, <-c // 从 c 中接收

	fmt.Println(x, y, x+y)
}

结果显示为：
-5 17 12
```

**同时也可以知道 信道的结构是队列类型，先进先出**

‍

‍

## 6.3 项目带缓冲的信道

信道可以是 *带缓冲的*。将缓冲长度作为第二个参数提供给 `make`​ 来初始化一个带缓冲的信道：

```
ch := make(chan int, 100)
```

仅当信道的缓冲区填满后，向其发送数据时才会阻塞。当缓冲区为空时，接受方会阻塞。

修改示例填满缓冲区，然后看看会发生什么。

```go
package main

import "fmt"

func main() {
	ch := make(chan int, 2)
	ch <- 1
	ch <- 2
	fmt.Println(<-ch)
	fmt.Println(<-ch)
}
```

‍

## 6. 4 信道使用 range 和 close

发送者可通过 `close`​ 关闭一个信道来表示没有需要发送的值了。接收者可以通过为接收表达式分配第二个参数来测试信道是否被关闭：若没有值可以接收且信道已被关闭，那么在执行完

```
v, ok := <-ch
```

之后 `ok`​ 会被设置为 `false`​。

循环 `for i := range c`​ 会不断从信道接收值，直到它被关闭。

*注意：* 只有发送者才能关闭信道，而接收者不能。向一个已经关闭的信道发送数据会引发程序恐慌（panic）。

*还要注意：* 信道与文件不同，通常情况下无需关闭它们。只有在必须告诉接收者不再有需要发送的值时才有必要关闭，例如终止一个 `range`​ 循环。

```go
package main

import (
	"fmt"
)

func fibonacci(n int, c chan int) {
	x, y := 0, 1
	for i := 0; i < n; i++ {
		c <- x
		x, y = y, x+y
	}
	close(c)
}

func main() {
	c := make(chan int, 10)
	go fibonacci(cap(c), c)
	for i := range c {
		fmt.Println(i)
	}
}

结果显示为：
0
1
1
2
3
5
8
13
21
34
```

‍

## 6.5 Go 語言如何從 Channel 讀取資料

> 参考文献：
>
> [Chan的读取方式](https://blog.wu-boy.com/2022/05/read-data-from-channel-in-go/)

‍

## 6.6 select 语句

`select`​ 语句使一个 Go 程可以等待多个通信操作。

`select`​ 会阻塞到某个分支可以继续执行为止，这时就会执行该分支。当多个分支都准备好时会随机选择一个执行。

```go
package main

import "fmt"

func fibonacci(c, quit chan int) {
	x, y := 0, 1
	for {
		select {
		case c <- x:
			x, y = y, x+y
		case <-quit:
			fmt.Println("quit")
			return
		}
	}
}

func main() {
	c := make(chan int)
	quit := make(chan int)
	go func() {
		for i := 0; i < 10; i++ {
			fmt.Println(<-c)
		}
		quit <- 0
	}()
	fibonacci(c, quit)
}
```

‍

## 6.7 默认选择

当 `select`​ 中的其它分支都没有准备好时，`default`​ 分支就会执行。

为了在尝试发送或者接收时不发生阻塞，可使用 `default`​ 分支：

```
select {
case i := <-c:
    // 使用 i
default:
    // 从 c 中接收会阻塞时执行
}
```

```go
package main

import (
	"fmt"
	"time"
)

func main() {
	tick := time.Tick(100 * time.Millisecond)
	boom := time.After(500 * time.Millisecond)
	for {
		select {
		case i := <-tick:
			fmt.Println(i)
			fmt.Println("tick.")
		case <-boom:
			fmt.Println("BOOM!")
			return
		default:
			fmt.Println("    .")
			time.Sleep(50 * time.Millisecond)
		}
	}
}
```

输出为：

```go
    .
    .
2009-11-10 23:00:00.1 +0000 UTC m=+0.100000001
tick.
    .
    .
    .
2009-11-10 23:00:00.2 +0000 UTC m=+0.200000001
tick.
    .
2009-11-10 23:00:00.3 +0000 UTC m=+0.300000001
tick.
    .
    .
2009-11-10 23:00:00.4 +0000 UTC m=+0.400000001
tick.
    .
    .
BOOM!
```

‍

## 6.8 sync.Mutex

我们已经看到信道非常适合在各个 Go 程间进行通信。

但是如果我们并不需要通信呢？比如说，若我们只是想保证每次只有一个 Go 程能够访问一个共享的变量，从而避免冲突？

这里涉及的概念叫做 *互斥（mutual*exclusion）* ，我们通常使用 *互斥锁（Mutex）* 这一数据结构来提供这种机制。

Go 标准库中提供了 [sync.Mutex](https://go-zh.org/pkg/sync/#Mutex)``​ 互斥锁类型及其两个方法：

* `Lock`​
* `Unlock`​

我们可以通过在代码前调用 `Lock`​ 方法，在代码后调用 `Unlock`​ 方法来保证一段代码的互斥执行。参见 `Inc`​ 方法。

我们也可以用 `defer`​ 语句来保证互斥锁一定会被解锁。参见 `Value`​ 方法。

```go
package main

import (
	"fmt"
	"sync"
	"time"
)

// SafeCounter 的并发使用是安全的。
type SafeCounter struct {
	v   map[string]int
	mux sync.Mutex
}

// Inc 增加给定 key 的计数器的值。
func (c *SafeCounter) Inc(key string) {
	c.mux.Lock()
	// Lock 之后同一时刻只有一个 goroutine 能访问 c.v
	c.v[key]++
	c.mux.Unlock()
}

// Value 返回给定 key 的计数器的当前值。
func (c *SafeCounter) Value(key string) int {
	c.mux.Lock()
	// Lock 之后同一时刻只有一个 goroutine 能访问 c.v
	defer c.mux.Unlock()
	return c.v[key]
}

func main() {
	c := SafeCounter{v: make(map[string]int)}
	for i := 0; i < 1000; i++ {
		go c.Inc("somekey")
	}

	time.Sleep(time.Second)
	fmt.Println(c.Value("somekey"))
}

```

‍

# 练习题目（自己答案系列）

## 练习：Stringer

通过让 `IPAddr`​ 类型实现 `fmt.Stringer`​ 来打印点号分隔的地址。

例如，`IPAddr{1, 2, 3, 4}`​ 应当打印为 `"1.2.3.4"`​。

```go
package main

import "fmt"

type IPAddr [4]byte

// TODO: 给 IPAddr 添加一个 "String() string" 方法
func (ip *IPAddr) String() string{
	ipAddr:= fmt.Sprintf("%d.%d.%d.%d",ip[0],ip[1],ip[2],ip[3])
	return string(ipAddr)

}


func main() {
	hosts := map[string]IPAddr{
		"loopback":  {127, 0, 0, 1},
		"googleDNS": {8, 8, 8, 8},
	}
	for name, ip := range hosts {
		fmt.Printf("%v: %v\n", name, ip.String())
	}
}
```

```go
loopback: 127.0.0.1
googleDNS: 8.8.8.8
```

‍