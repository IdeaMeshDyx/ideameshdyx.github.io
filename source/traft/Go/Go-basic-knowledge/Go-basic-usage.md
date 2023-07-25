---
title: Go basic examples
catalog: true
date: 2023-05-5 01:16:19
subtitle:
header-img:
tags:
categories: 
	- Basic
---

> 记录 Golang  的基础使用例子

## 输入输出例子

> 输入输出也是处理的关键部分，包括从cmd 、文件、网络 等对象中读入，读入写入触发中断，会在意想不到的地方影响性能，尤其是acm形式下要注意

### 从控制台读入数据

一共有两种方法，一种是使用bufio中的newReader方法，一种是使用bufio中的NewScanner方法

使用 NewReader() 方法，通过返回值err判断是否是io.EOF来判断控制台的输出是否已经结束。

```go
//处理流数据，NewReader读取到所有的命令行数据，但是，newReader解出来数据需要有split。
reader := bufio.NewReader(os.stdout)

//实时循环读取输出流中的一行内容
for {
	line, err := reader.ReadString('\n') //使用换行符作为切割。
	if err != nil || io.EOF == err {
        fmt.Println("err occured! err = ", err)
		break
	}
	fmt.Printf(line)
}

```

NewScanner方法使用时，使用Scan()方法判断控制台的输出是否已经结束。使用Bytes()方法读取数据时不指定分隔符，但也可以使用其他读取函数使用分隔符进行分割。

```go
scanner := bufio.NewScanner(os.Stdin)

//循环读取控制台数据
for scanner.Scan() {
	data := scanner.Bytes()
	fmt.Println(string(data))
}

```

针对 写入数据类型来做读入处理

1. 用 fmt 包实现简单读取数字

   * 知道每行输入的信息个数，但不知道有多少行

     ```go
     // 一直循环读取 cmd 输入的数据
     for {
         	// n 记录的是成功读取每行的数字个数
     		n, _ := fmt.Scanln(&a, &b)  //也可以用 fmt.Scan
         	
     	}
     ```

   * 先输入行数，再输入信息

     ``` go
     fmt.Scanln(&t)
     for i:=0 ; i<t ; i++{
        fmt.Scanln(&a,&b)
     }
     ```

     > fmt.Scanln 一次只能读取一行数据，而且得提前创建好对应的结构

   * 读取一整行数据，但不确定行数和一行内的数据量

     ``` go
     inputs := bufio.NewScanner(os.Stdin)
     for inputs.Scan() {  //每次读入一行
         data := strings.Split(inputs.Text(), " ")  //通过空格将他们分割，并存入一个字符串切片
         for i := range data {// 遍历一行内的数据
             val, _ := strconv.Atoi(data[i])   //将字符串转换为int 或者是根据实际要求转化
         }
     }
     ```

   * 读一行字符串

     ```go
     // 输入描述:
     // 输入有两行，第一行n
     // 第二行是n个字符串，字符串之间用空格隔开
     in := bufio.NewScanner(os.Stdin)
     for in.Scan(){
         n := in.Text()
     }
     for in.Scan(){
        str := in.Text()
        s := strings.Split(str, " ")
        fmt.Println(strings.Join(s," "))  //将切片连接成字符串
     }
     
     ```

   * 读多行字符串

     ```go
     input := bufio.NewScanner(os.Stdin)
     for input.Scan(){
        data := strings.Split(input.Text()," ")
        fmt.Println(strings.Join(data, " "))
     }
     ```

   * 一次性读入字符串数据

     ```go
     func scanT() {
         scanner := bufio.NewScanner(os.Stdin)
         for scanner.Scan() {
             fmt.Println(scanner.Text())
         }
     }
     ```

依据不同的场景来选择不同的读入函数，一般考虑的时候主要是性能相关的，这部分还没有统一的一个套路，所以为了方便，整理出以下套路：

* 先读入数据
* 在将数据转化为需要的数据类型



## 字符串处理例子

### 字符数据据类型

在 Go 中字符相关的类型一共三类：

- ```go
  byte // 一般用于强调数值是原始数据，代表ASCII码的一个字符（占一个字节）
  ```

  - byte是`uint8`的别名，在所有方面都等同于`uint8`

  - 按惯例，它用于区分**字节值**和**8位无符号整数值**。

    一般形式：是基础类型

    ```go
    //使用单引号 表示一个字符
    var ch byte = 'A'
    //在 ASCII 码表中，A 的值是 65,也可以这么定义
    var ch byte = 65
    //65使用十六进制表示是41，所以也可以这么定义 \x 总是紧跟着长度为 2 的 16 进制数
    var ch byte = '\x41'
    //65的八进制表示是101，所以使用八进制定义 \后面紧跟着长度为 3 的八进制数
    var ch byte = '\101'
    ```

- ```
  rune
  ```

  - `rune`是`int32`的别名，在所有方面都等同于`int32`， 用于标识Unicode字符，代表一个UTF-8字符

    主要价值在于 非英文字符的计算和标识使用

  - 按惯例，它用于区分**字符值**和**整数值**。

    ```go
    var ch rune = '\u0041'
    var ch1 int64 = '\U00000041'
    //格式化说明符%c用于表示字符，%v或%d会输出用于表示该字符的整数，%U输出格式为 U+hhhh 的字符串。
    fmt.Printf("%c,%c,%U",ch,ch1,ch)
    ```

- ```
  string
  ```

  - string是所有**8位字节字符串**的集合，通常但不一定代表UTF-8编码的文本

  - 字符串可能为空，但是不能为 `nil`

  - 字符串类型的值是不可变的:  **本质是**只读的字符型数组

    所以这行代码是不可以执行的：`str1[3] = 'l'`, 但是读取的操作是可以执行的： `fmt.Println(str1[3])`，这个也不是golang的独创，很多语言当中都有这个限制，因为会将字符串作为const类型存储在专门的区域。

  string 类型详述：[Golang基础教程——字符串篇 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/143352497) [go底层系列-string底层实现原理与使用 - 掘金 (juejin.cn)](https://juejin.cn/post/7111953294469267493)

  string 变量本质上是一个指向字符串首地址的指针加上字符串长度的量，二者均为8字节，所以使用SizoOf的时候所获得的大小一直为16，其源码对应的是：

  ```go
  type stringStruct struct {
  	str unsafe.Pointer		//字符串首地址，指向底层字节数组的指针
  	len int					//字符串长度
  }
  ```

  说到这里关于字符串长度的统计有几处误区需要辨明：

  1. 使用 len 来获取字符串长度时候计算的是 Byte 数量，这对于英文字符来说一个字母就对应一个Byte，len所获取的长度就是字符串的长度，还有 ` bytes.Count() ` 也是类似的

     但对于中文等语言，使用utf-8编码，一个**汉字需要3个字节**编码，这个时候使用len 就会把一个中文字符计算为长度 3

     ```go
     // 获取长度
     l := len(str)
     // 如果是获取string 中的字符串数量
     l1 := strings.Count(str,"") - 1
     l2 := bytes.Count([]byte(str),nil) - 1 
     // strings.Count函数和bytes.Count函数,这两个函数的用法是相同，只是一个作用在字符串上，一个作用在字节上
     ```

  2. 将 string 数组转化为 rune 数组之后来计算长度，常用的方法是：

     ```go
     // 将字符串转换为 []rune 后调用 len 函数进行统计
     l := len([]rune(str))
     // 使用 utf8.RuneCountInString() 统计
     l := utf8.RuneCountInString(str)
     ```

  那么回顾总结，目前对于 string 量以下操作是明确的：



### 1. string  初始化

```go
// 第一种形式最简洁，但只能用在函数内部，不能用在包变量。
// 当函数传入 string 类型或者说，使用 cmd 或者 bufio 读取了数值时候在函数内需要进行微操的时候使用
s := ""

// 第二种形式依赖于字符串的默认初始化值，被初始化为""。
var s string

// 第三种形式用得很少，除非同时声明多个变量。
var s = ""

// 第四种形式显式地标明变量的类型，当变量类型与初值类型相同时，类型冗余，但如果两者类型不同，变量类型就必须了。
var s string = ""
```



### 2. string 拼接操作

仅对于 string 是可以用的， rune和byte操作的是一个值或者切片，相互之间需要转化

```go
// 简单的 + ，一共存在两种用法：
// s = a + b 则 s 会被赋值为一个新的由ab组成的字符串
s = a + b
// s += a + b , += 连接原字符串和下个参数，产生新字符串, 并把它赋值给s(ab)
s += a + b
```

这样的方式更新，s 原来的内容都将不再会使用，Go 会在适当的时机对他进行垃圾回收，这方面的机制将在 enhanced 文章当中提及

为改进这方面的问题，一种简单且高效的解决方案是使用strings包的Join函数

```go
// 使用拼接函数
strings.Join([]string{a,b...}, " ")
```

一个实例如下

```go
func main() {
	a := "=this=is="
	b := "=your=word="
	fmt.Printf("%s\n", a+b)
	var d string
	d += a + b
	fmt.Printf("%s\n", d)
	fmt.Printf("%s\n", strings.Join([]string{a, b}, ""))
}
// 结果是：
=this=is==your=word=
=this=is==your=word=
=this=is==your=word=
```



### 3. string 求长度

``` go
// 英文字符用 len()  , 中文字符先转换为 []rune，再计算len()
```

以下为一个实例，计算长度时候是把空格也计算在内了

```go
func main() {
	a := "this is a string" // 16
	b := "这是一个字符串"      // 7
	c := "this is a 字符串"  // 13
	d := "this is 11 字符串 @@#"  // 18
	fmt.Printf("%d\n", len(a))
	fmt.Printf("%d\n", len([]rune(b)))
	fmt.Printf("%d\n", len([]rune(c)))
	fmt.Printf("%d\n", len([]rune(d)))
}
// 输出结果为：
16
7 
13
18
```



大部分情况下，上述的操作已经满足了需求，但在面对输入输出的时候，还需要将字符串转化为有效的数据，比如读取 Docker 输出之后，需要将其中的数据转化为可以计算的其他数据，这个时候就涉及到类型转化。

### 4. 以字符串为核心的类型转换

#### 4.1 string To int and Reverse

使用：

* `strconv.ParseInt(a,10,64)`
* `strconv.Atoi(a)`

``` go
func main() {
	a := "1056"
	b := "1056"
	vala, _ := strconv.ParseInt(a, 10, 64)
	valb, _ := strconv.Atoi(b)
	fmt.Printf("ParseInt is : %d\n", vala)
	fmt.Printf("Atoi is :%d\n", valb)
}
// 结果是：
ParseInt is : 1056
Atoi is :1056
```

二者在遍历字符串的时候，如果遇到了非数值型字符就会把整个数值置为零，但使用ParseInt对应16进制时候，a-f（A-F）会被识别为对应的进制数

这里有一点是Atoi， Go 从str 转化为 int 类型读取时候只能默认是10进制的，也就是说上述进制转化的逻辑是：

string ---> 10进制 int ---> 其他进制 int

反过来将Int类型转化为string时候使用 Format 函数

```go
strconv.FormatInt(int64(num), 10)
strconv.Itoa(num)
```

传入的是一个64位的Int型数字，将其转化为10进制数（也可以将10换为8，16）

#### 4.2 string to float

`strconv.ParseFloat(a,64)`  对于浮点数来说就没有进制的区别了

```go
value, err := strconv.ParseFloat("1056.56", 64)
```

浮点数的转化就有些麻烦，但依旧是使用FormatFloat来实现的

```go
num := 23423134.323422
fmt.Println(strconv.FormatFloat(float64(num), 'f', -1, 64))
fmt.Println(strconv.FormatFloat(float64(num), 'b', -1, 64))
fmt.Println(strconv.FormatFloat(float64(num), 'e', -1, 64))
fmt.Println(strconv.FormatFloat(float64(num), 'E', -1, 64))
fmt.Println(strconv.FormatFloat(float64(num), 'g', -1, 64))
fmt.Println(strconv.FormatFloat(float64(num), 'G', -1, 64))
// 结果是：
23423134.323422
6287599743057036p-28
2.3423134323422e+07 
2.3423134323422E+07 
2.3423134323422e+07 
2.3423134323422E+07 

```

FormatFloat接受4个参数，第一个参数就是待转换的浮点数，第二个参数表示我们希望转换之后得到的格式。一共有'f', 'b', 'e', 'E', 'g', 'G'这几种格式。

* 'f' 表示普通模式：（-ddd.dddd）
* 'b' 表示指数为二进制：（-ddddp±ddd）
* 'e' 表示十进制指数，也就是科学记数法的模式：(-d.dddde±dd)
* 'E' 和'e'一样，都是科学记数法的模式，只不过字母e大写：(-d.ddddE±dd)
* 'g' 表示指数很大时用'e'模式，否则用‘f'模式
* 'G' 表示指数很大时用’E'模式，否则用'f'模式

#### 4.3 string to []byte and Revese

使用强制转化就行

``` go
s := "abc"
b := []byte(s)
s2 := string(b)
```


#### 4.4 string to []rune and Reverse

强制转化就行 

```go
s := "你是谁"
r := []rune(s)
s2 := string(r)
```



> 回顾： ASCII 码：
>
> 记住十进制表示中 1 --> 48, A --> 65, a --> 97
>
> ​							  9 --> 57, Z --> 90, z --> 122

> 数字部分：
>
> | [Binary](https://en.wikipedia.org/wiki/Binary_numeral_system) | [Oct](https://en.wikipedia.org/wiki/Octal) | [Dec](https://en.wikipedia.org/wiki/Decimal) | [Hex](https://en.wikipedia.org/wiki/Hexadecimal) | Glyph                                         |
> | ------------------------------------------------------------ | ------------------------------------------ | -------------------------------------------- | ------------------------------------------------ | --------------------------------------------- |
> | 011 0000                                                     | 060                                        | 48                                           | 30                                               | [0](https://en.wikipedia.org/wiki/0_(number)) |
> | 011 0001                                                     | 061                                        | 49                                           | 31                                               | [1](https://en.wikipedia.org/wiki/1_(number)) |
> | 011 0010                                                     | 062                                        | 50                                           | 32                                               | [2](https://en.wikipedia.org/wiki/2_(number)) |
> | 011 0011                                                     | 063                                        | 51                                           | 33                                               | [3](https://en.wikipedia.org/wiki/3_(number)) |
> | 011 0100                                                     | 064                                        | 52                                           | 34                                               | [4](https://en.wikipedia.org/wiki/4_(number)) |
> | 011 0101                                                     | 065                                        | 53                                           | 35                                               | [5](https://en.wikipedia.org/wiki/5_(number)) |
> | 011 0110                                                     | 066                                        | 54                                           | 36                                               | [6](https://en.wikipedia.org/wiki/6_(number)) |
> | 011 0111                                                     | 067                                        | 55                                           | 37                                               | [7](https://en.wikipedia.org/wiki/7_(number)) |
> | 011 1000                                                     | 070                                        | 56                                           | 38                                               | [8](https://en.wikipedia.org/wiki/8_(number)) |
> | 011 1001                                                     | 071                                        | 57                                           | 39                                               | [9](https://en.wikipedia.org/wiki/9_(number)) |

> 大写字母部分
>
> | [Binary](https://en.wikipedia.org/wiki/Binary_numeral_system) | [Oct](https://en.wikipedia.org/wiki/Octal) | [Dec](https://en.wikipedia.org/wiki/Decimal) | [Hex](https://en.wikipedia.org/wiki/Hexadecimal) | Glyph                                |
> | ------------------------------------------------------------ | ------------------------------------------ | -------------------------------------------- | ------------------------------------------------ | ------------------------------------ |
> | 100 0001                                                     | 101                                        | 65                                           | 41                                               | [A](https://en.wikipedia.org/wiki/A) |
> | 100 0010                                                     | 102                                        | 66                                           | 42                                               | [B](https://en.wikipedia.org/wiki/B) |
> | 100 0011                                                     | 103                                        | 67                                           | 43                                               | [C](https://en.wikipedia.org/wiki/C) |
> | 100 0100                                                     | 104                                        | 68                                           | 44                                               | [D](https://en.wikipedia.org/wiki/D) |
> | 100 0101                                                     | 105                                        | 69                                           | 45                                               | [E](https://en.wikipedia.org/wiki/E) |
> | 100 0110                                                     | 106                                        | 70                                           | 46                                               | [F](https://en.wikipedia.org/wiki/F) |
> | 100 0111                                                     | 107                                        | 71                                           | 47                                               | [G](https://en.wikipedia.org/wiki/G) |
> | 100 1000                                                     | 110                                        | 72                                           | 48                                               | [H](https://en.wikipedia.org/wiki/H) |
> | 100 1001                                                     | 111                                        | 73                                           | 49                                               | [I](https://en.wikipedia.org/wiki/I) |
> | 100 1010                                                     | 112                                        | 74                                           | 4A                                               | [J](https://en.wikipedia.org/wiki/J) |
> | 100 1011                                                     | 113                                        | 75                                           | 4B                                               | [K](https://en.wikipedia.org/wiki/K) |
> | 100 1100                                                     | 114                                        | 76                                           | 4C                                               | [L](https://en.wikipedia.org/wiki/L) |
> | 100 1101                                                     | 115                                        | 77                                           | 4D                                               | [M](https://en.wikipedia.org/wiki/M) |
> | 100 1110                                                     | 116                                        | 78                                           | 4E                                               | [N](https://en.wikipedia.org/wiki/N) |
> | 100 1111                                                     | 117                                        | 79                                           | 4F                                               | [O](https://en.wikipedia.org/wiki/O) |
> | 101 0000                                                     | 120                                        | 80                                           | 50                                               | [P](https://en.wikipedia.org/wiki/P) |
> | 101 0001                                                     | 121                                        | 81                                           | 51                                               | [Q](https://en.wikipedia.org/wiki/Q) |
> | 101 0010                                                     | 122                                        | 82                                           | 52                                               | [R](https://en.wikipedia.org/wiki/R) |
> | 101 0011                                                     | 123                                        | 83                                           | 53                                               | [S](https://en.wikipedia.org/wiki/S) |
> | 101 0100                                                     | 124                                        | 84                                           | 54                                               | [T](https://en.wikipedia.org/wiki/T) |
> | 101 0101                                                     | 125                                        | 85                                           | 55                                               | [U](https://en.wikipedia.org/wiki/U) |
> | 101 0110                                                     | 126                                        | 86                                           | 56                                               | [V](https://en.wikipedia.org/wiki/V) |
> | 101 0111                                                     | 127                                        | 87                                           | 57                                               | [W](https://en.wikipedia.org/wiki/W) |
> | 101 1000                                                     | 130                                        | 88                                           | 58                                               | [X](https://en.wikipedia.org/wiki/X) |
> | 101 1001                                                     | 131                                        | 89                                           | 59                                               | [Y](https://en.wikipedia.org/wiki/Y) |
> | 101 1010                                                     | 132                                        | 90                                           | 5A                                               | [Z](https://en.wikipedia.org/wiki/Z) |

> 小写字母部分：
>
> | [Binary](https://en.wikipedia.org/wiki/Binary_numeral_system) | [Oct](https://en.wikipedia.org/wiki/Octal) | [Dec](https://en.wikipedia.org/wiki/Decimal) | [Hex](https://en.wikipedia.org/wiki/Hexadecimal) | Glyph |                                      |
> | ------------------------------------------------------------ | ------------------------------------------ | -------------------------------------------- | ------------------------------------------------ | ----- | ------------------------------------ |
> | 110 0001                                                     | 141                                        | 97                                           | 61                                               |       | [a](https://en.wikipedia.org/wiki/A) |
> | 110 0010                                                     | 142                                        | 98                                           | 62                                               |       | [b](https://en.wikipedia.org/wiki/B) |
> | 110 0011                                                     | 143                                        | 99                                           | 63                                               |       | [c](https://en.wikipedia.org/wiki/C) |
> | 110 0100                                                     | 144                                        | 100                                          | 64                                               |       | [d](https://en.wikipedia.org/wiki/D) |
> | 110 0101                                                     | 145                                        | 101                                          | 65                                               |       | [e](https://en.wikipedia.org/wiki/E) |
> | 110 0110                                                     | 146                                        | 102                                          | 66                                               |       | [f](https://en.wikipedia.org/wiki/F) |
> | 110 0111                                                     | 147                                        | 103                                          | 67                                               |       | [g](https://en.wikipedia.org/wiki/G) |
> | 110 1000                                                     | 150                                        | 104                                          | 68                                               |       | [h](https://en.wikipedia.org/wiki/H) |
> | 110 1001                                                     | 151                                        | 105                                          | 69                                               |       | [i](https://en.wikipedia.org/wiki/I) |
> | 110 1010                                                     | 152                                        | 106                                          | 6A                                               |       | [j](https://en.wikipedia.org/wiki/J) |
> | 110 1011                                                     | 153                                        | 107                                          | 6B                                               |       | [k](https://en.wikipedia.org/wiki/K) |
> | 110 1100                                                     | 154                                        | 108                                          | 6C                                               |       | [l](https://en.wikipedia.org/wiki/L) |
> | 110 1101                                                     | 155                                        | 109                                          | 6D                                               |       | [m](https://en.wikipedia.org/wiki/M) |
> | 110 1110                                                     | 156                                        | 110                                          | 6E                                               |       | [n](https://en.wikipedia.org/wiki/N) |
> | 110 1111                                                     | 157                                        | 111                                          | 6F                                               |       | [o](https://en.wikipedia.org/wiki/O) |
> | 111 0000                                                     | 160                                        | 112                                          | 70                                               |       | [p](https://en.wikipedia.org/wiki/P) |
> | 111 0001                                                     | 161                                        | 113                                          | 71                                               |       | [q](https://en.wikipedia.org/wiki/Q) |
> | 111 0010                                                     | 162                                        | 114                                          | 72                                               |       | [r](https://en.wikipedia.org/wiki/R) |
> | 111 0011                                                     | 163                                        | 115                                          | 73                                               |       | [s](https://en.wikipedia.org/wiki/S) |
> | 111 0100                                                     | 164                                        | 116                                          | 74                                               |       | [t](https://en.wikipedia.org/wiki/T) |
> | 111 0101                                                     | 165                                        | 117                                          | 75                                               |       | [u](https://en.wikipedia.org/wiki/U) |
> | 111 0110                                                     | 166                                        | 118                                          | 76                                               |       | [v](https://en.wikipedia.org/wiki/V) |
> | 111 0111                                                     | 167                                        | 119                                          | 77                                               |       | [w](https://en.wikipedia.org/wiki/W) |
> | 111 1000                                                     | 170                                        | 120                                          | 78                                               |       | [x](https://en.wikipedia.org/wiki/X) |
> | 111 1001                                                     | 171                                        | 121                                          | 79                                               |       | [y](https://en.wikipedia.org/wiki/Y) |
> | 111 1010                                                     | 172                                        | 122                                          | 7A                                               |       | [z](https://en.wikipedia.org/wiki/Z) |



## 数字处理例子

### 1.  高低位的处理

> 核心是： 
>
> * 取模得低位
> * 除数/右移得高位集合，或者说是去除最低位

以10进制数 x 为例子， x%10得到最低位的数字，如果想要得到高位的数字，可以 for 循环 x/10 然后再使用x%10，这个取位值的方式是通用的，10可以换成其他的进制数。

典型场景：

给你一个整数 `x` ，如果 `x` 是一个回文整数，返回 `true` ；否则，返回 `false` ，回文数是指正序（从左向右）和倒序（从右向左）读都是一样的整数。

> [9. 回文数 - 力扣（LeetCode）](https://leetcode.cn/problems/palindrome-number/)

* 排除所有的负数和个位为0且不是0的数

* 获取高低位数来进行比较

  

```go
// 由于数字是整体具有大小的定义，不需要像是字符串那样需要按位比较，两数相同必定代表每一位的数字都相同，所以这个场景就可以换成取出整个数字的前半部分高位数和后半部分低位数，比较而这是否相同
front, back := x,0
// 如果是要比较回文数，那么低位数字需要倒序，执行逻辑是： %10获取该位数字，在下一轮使用*10将这个位数往左移一位（变成高位）
for front > back{
	//先把当前地位数字向左移，然后在新的低位上加上新的数值
	back = back*10 + front%10
    // 高位数字右移，直接丢弃最低位数字
	front = front/10
}
// 要注意的是如果原数 x 有偶数位，那么循环后 back 和 front  的长度相同；如果x 是奇数位，那么循环后 back 会比 front 多一位，此时 back 的最低位是原数 x 的中间数，这个性质在求数位二分特征的时候可能有用
```

题目的解题代码为：

``` golang
func isPalindrome(x int) bool {
    if x < 0 || ( x%10 == 0 && x != 0 ){
        return false
    }
    front, back := x,0
    for front > back{
        back = back*10 + front%10
        front = front/10
    }
    // 最后比较二者是否相同
    return back == front || front == back/10
}
```



### 2. 进制转化

已有调用可以借助 strconv 转化为 string 然后进行操作(比如16进制本来也只能string表示)

```go
// 10进制转化为其他进制   
var v int64 = 12              //默认10进制
   s2 := strconv.FormatInt(v, 2) //10 转2进制
   fmt.Printf("%v\n", s2)
 //10 转8进制
   s8 := strconv.FormatInt(v, 8)
   fmt.Printf("%v\n", s8)
 
   s10 := strconv.FormatInt(v, 10)
   fmt.Printf("%v\n", s10)
 //10 转16进制
   s16 := strconv.FormatInt(v, 16) //10 yo 16
   fmt.Printf("%v\n", s16)
 
// 其他进制转化为10进制
   var sv = "11"
   fmt.Println(strconv.ParseInt(sv, 16, 32)) // 16 to 10
   fmt.Println(strconv.ParseInt(sv, 10, 32)) // 10 to 10
   fmt.Println(strconv.ParseInt(sv, 8, 32))  // 8 to 10
   fmt.Println(strconv.ParseInt(sv, 2, 32))  // 2 to 10

```

### 3. 数字表示转化

> 本质是字符匹配然后拼接，问题就在于需要有一个可以匹配的字典以及对应的值
>
> 难点在于 []byte, int, string类型转化，数值计算与字符拆分拼接的等价关系，以及是否能够把组合类型元素全部枚举完毕

一般常用的思路就是：

* 从数字转字符 --> 数字做减法，字符做拼接

* 从字符转数字 --> 数字做加法，字符做拆分

一般根据各自的数特征来选择从高位还是低位开始，数值类型从低位加减，也就意味着字符从右到左遍历。

比如将罗马数字转化位10进制整数，首先建立罗马数字与10进制数的对应关系map，然后从右到左遍历低位进行加数，期间注意罗马数字的特点："小数在大数左边表示减法"

> [13. 罗马数字转整数 - 力扣（LeetCode）](https://leetcode.cn/problems/roman-to-integer/)

``` go
// 匹配的关键在于生成一张 字符和数字对应的表
m := map[byte]int {'I':1,'V':5,'X':10,'L':50,'C':100,'D':500,'M':1000}
// 开始遍历罗马数字，并从表中找到它对应的数值，判断左右之后加在结果上
// 注意点1 ： 初始赋值为最右边的罗马数，因为他不可能为零
res := m[s[len(s)-1]]
for i := len(s)-2; i >= 0 ; i--{
    // 注意点2 ： 大于等于条件，前后位罗马符号相同是加同一个值，不能漏了等号
     if m[s[i]] >= m[s[i+1]] {
        res = res + m[s[i]]
     }
     if m[s[i]] < m[s[i+1]] {
        res = res - m[s[i]]
     }
}
return res
```

反过来要将一个10进制整数转化位罗马数字，遍历的就是10进制数，然后找他对应的罗马数字；

> [12. 整数转罗马数字 题解 - 力扣（LeetCode）](https://leetcode.cn/problems/integer-to-roman/solution/)

但前一问运算简便是因为 10 进制加减覆盖了罗马数字的所有计算可排列组合，但是反过来的时候 10 进制数的每一位计算不一定都能找到罗马数字标识，比如 9 在罗马数字当中就存在非顺序的表达方式。由于这个特性就需要像是拼接组件一样去凑（说成贪心也可以）这个数字，也就是从左到右，先找大数再找小数，先从目标数字里面剪出所有的大数，然后找大数对应的罗马数字表示，逐个拼接。

```go
var m = []int{1000,900,500,400,100,90,50,40,10,9,5,4,1}
var v = []string{"M","CM","D","CD","C","XC","L","XL","X","IX","V","IV","I"}
// 从左到右来遍历先减去大数，加上罗马数字
func intToRoman(num int) string {
    var res string
    for i := 0; i < len(v); i++{
        for num >= m[i] {
            num = num-m[i]
            res = res + v[i]
        }
    }
    return res
}
```

这里唯一要注意的应该就是 Golang 当中字符串的拼接处理了，详情看

同样的逻辑可以用到其他的转化情况，比如随意字符串转数字，一定先确认数字映射关系的字典，然后来做字符串的匹配，然后转化为数字的计算。

