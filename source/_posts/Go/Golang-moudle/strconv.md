---
title: strconv
catalog: true
date: 2023-04-10 01:47:36
subtitle:
header-img:
tags:
categories: index
published: false
---

# Strconv 常用方法汇总
> 主要参考官方文章：[strconv](https://pkg.go.dev/strconv#pkg-index)
> 
## 类型转换

``` golang
// 字符串到整数的转换
    fmt.Println(strconv.Atoi("123")) // 123
        // 整数到字符串的转换
    fmt.Println(strconv.Itoa(12345)) // "12345"

    // 字符串转其他进制的整数
    fmt.Println(strconv.ParseInt("1100100", 2, 0))  // 100
    fmt.Println(strconv.ParseInt("7D0", 16, 0))    // 2000
    fmt.Println(strconv.ParseInt("2147483648", 10, 64))   // 2147483648
    fmt.Println(strconv.ParseUint("FFFFFFFFFFFFFFFF", 16, 64)) // 18446744073709551615

    // 其他进制的整数转字符串
    fmt.Println(strconv.FormatInt(100, 2)) // "1100100"
    fmt.Println(strconv.FormatInt(2000, 16)) // "7d0"
    fmt.Println(strconv.FormatUint(2147483648, 10)) // "2147483648"

    // 字符串到浮点数的转换
    fmt.Println(strconv.ParseFloat("3.1415", 64)) // 3.1415

    // 浮点数到字符串的转换
    fmt.Println(strconv.FormatFloat(3.1415, 'E', -1, 64)) // 3.141500E+00

    // 输出类型为 bool 的数值字符串
    fmt.Println(strconv.ParseBool("true"))  // true
    fmt.Println(strconv.ParseBool("False")) // false

    // 布尔型到字符串的转换
    fmt.Println(strconv.FormatBool(true)) // "true"
    fmt.Println(strconv.FormatBool(false)) // "false"
```

## 进制转化

``` golang
    // 十进制转二进制
    fmt.Printf("%b", 17) // 10001

    // 十进制转十六进制
    fmt.Printf("%x", 17) // 11

    // 十六进制转十进制
    i, _ := strconv.ParseInt("11", 16, 0)
    fmt.Println(i) // 17

    // 十六进制转二进制
    i, _ = strconv.ParseInt("11", 16, 0)
    fmt.Printf("%b", i) // 10001

    // 二进制转十进制
    i, _ = strconv.ParseInt("10001", 2, 0)
    fmt.Println(i) // 17

    // 二进制转十六进制
    i, _ = strconv.ParseInt("10001", 2, 0)
    fmt.Printf("%x", i) // 11
```