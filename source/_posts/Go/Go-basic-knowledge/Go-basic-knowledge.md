---
title: Go basic knowledge
catalog: true
date: 2023-04-10 01:16:19
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

## 路径

每个 Go 程序都是由包构成的。

程序从 `main` 包开始运行。

比如通过导入路径 `"fmt"` 和 `"math/rand"` 来使用这两个包。

按照约定，包名与导入路径的最后一个元素一致。例如，`"math/rand"` 包中的源码均以 `package rand` 语句开始。


## 导入包

圆括号组合了导入，这是“分组”形式的导入语


# 2. 变量

注意类型在变量名之后 

```go
y int
```



`var` 语句用于声明一个变量列表，跟函数的参数列表一样，类型在最后

```go
var a ,b c, d int
```

变量声明可以包含初始值，每个变量对应一个， 逗号隔开，如果初始化值已存在，则可以省略类型；变量会从初始值中获得类型。

```go
var i, j int = 1, 2
var c, python, java = true, false, "no!"
```


简洁赋值语句 `:=` 可在类型明确的地方代替 `var` 声明。

函数外的每个语句都必须以关键字开始（`var`, `func` 等等），因此 ​`:=`​ 结构不能在函数外使用[相较之下 var 可以写到函数外面，在包层级]

```go
	k := 3
	c, python, java := true, false, "no!"
```


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

`int`, `uint` 和 `uintptr` 在 32 位系统上通常为 32 位宽，在 64 位系统上则为 64 位宽。 当你需要一个整数值时应使用 `int` 类型，除非你有特殊的理由使用固定大小或无符号的整数类型。


没有明确初始值的变量声明会被赋予它们的 **零值**。

零值是：

* 数值类型为 `0`，
* 布尔类型为 `false`，
* 字符串为 `""`（空字符串）。


表达式 `T(v)` 将值 `v` 转换为类型 `T`。

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


## 常量

常量的声明与变量类似，只不过是使用 `const` 关键字。

常量可以是字符、字符串、布尔值或数值。

常量不能用 `:=` 语法声明。

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


## 类型推导

在声明一个变量而不指定其类型时（即使用不带类型的 `:=` 语法或 `var =` 表达式语法），变量的类型由右值推导得出。

当右值声明了类型时，新变量的类型与其相同：

```
var i int
j := i // j 也是一个 int
```

不过当右边包含未指明类型的数值常量时，新变量的类型就可能是 `int`, `float64` 或 `complex128` 了，这取决于常量的精度：

```
i := 42           // int
f := 3.142        // float64
g := 0.867 + 0.5i // complex128
```


## 数值常量

数值常量是高精度的 **值**。

一个未指定类型的常量由上下文来决定其类型。

再尝试一下输出 `needInt(Big)` 吧。

（`int` 类型最大可以存储一个 64 位的整数，有时会更小。）

（`int` 可以存放最大64位的整数，根据平台不同有时会更少。）

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

## if

Go 的 `if` 语句与 `for` 循环类似，表达式外无需小括号 `( )` ，而大括号 `{ }` 则是必须的。

```go
if x < 0 {
	return sqrt(-x) + "i"
}
```

## for

Go 只有一种循环结构：`for` 循环。

基本的 `for` 循环由三部分组成，它们用分号隔开：

* 初始化语句：在第一次迭代前执行
* 条件表达式：在每次迭代前求值
* 后置语句：在每次迭代的结尾执行

初始化语句通常为一句短变量声明，该变量声明仅在 `for` 语句的作用域中可见。

一旦条件表达式的布尔值为 `false`，循环迭代就会终止。

初始化语句和后置语句是可选的，也就是说完全可以只有一个条件，其含义也变成了wihle语句，但是go里面没有while只有for

**注意**：和 C、Java、JavaScript 之类的语言不同，**Go 的 for 语句后面的三个构成部分外没有小括号**， 而包围函数主体的大括号 `{ }` 则是必须的。

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


## if 的简短语句

同 `for` 一样， `if` 语句可以在条件表达式前执行一个简单的语句。

**该语句声明的变量作用域仅在 ​****`if`****​ 之内。**也就是说出了if语句，这个变量就没有了

```go
func pow(x, n, lim float64) float64 {
	if v := math.Pow(x, n); v < lim {
		return v
	}
	return lim
}
```


## if 和 else

在 `if` 的简短语句中声明的变量同样可以在任何对应的 `else` 块中使用。

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



## switch

`switch` 是编写一连串 `if - else` 语句的简便方法。它运行第一个值等于条件表达式的 case 语句。

Go 的 switch 语句类似于 C、C++、Java、JavaScript 和 PHP 中的，不过 Go 只运行选定的 case，而非之后所有的 case。 实际上，Go 自动提供了在这些语言中每个 case 后面所需的 `break` 语句。 除非以 `fallthrough` 语句结束，否则分支会自动终止。 Go 的另一点重要的不同在于 switch 的 case 无需为常量，且取值不必为整数。

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


## switch 的求值顺序

switch 的 case 语句从上到下顺次执行，直到匹配成功时停止。

（例如，

```
switch i {
case 0:
case f():
}
```

在 `i==0` 时 `f` 不会被调用。

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

## 没有条件的 switch

没有条件的 switch 同 `switch true` 一样。

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


## defer

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


## defer 栈

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


## 函数返回

函数可以返回任意数量的返回值, 但是结构上需要结合函数形式

```go
func swap(x, y string) (string, string) {
	return y, x
}
```


Go 的返回值可被命名，它们会被视作定义在函数顶部的变量。

返回值的名称应当具有一定的意义，它可以作为文档使用。