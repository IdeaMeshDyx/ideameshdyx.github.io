---
title: ACM 模式输入输出总结
catalog: true
date: 2023-03-26 03:38:52
subtitle: 解决牛客网输入输出问题
header-img:
tags: Golang
categories:
---

# 输入格式归纳记录

由于牛客网采用的是 acm 形式编写代码，所以需要在做题时候需要自行处理输入输出的数据格式，以 Golang 作为主要例子归纳如下：


## 读取多行数据，每一行数据是多个空格隔开的元素
``` golang
package main
import(
    "bufio"
    "fmt"
    "strings"
    "strconv"
    "os"
)

func main(){
    scanner := bufio.NewScanner(os.Stdin)
    scanner.Split(bufio.ScanLines)
    var sum int
    for scanner.Scan(){
        line := scanner.Text()
        fields := strings.Fields(line)
        for _, field := range fields{
            num, err := strconv.Atoi(field)
            if err == nil{
                sum += num
            }
        }
        fmt.Println(sum)
        sum = 0
    }
}
```



# 输入数值的进制转换

## 十进制数字转换为其他进制数字

```golang
    i := 255
    // 将int类型的i转化为二进制字符串并输出
    s := strconv.FormatInt(int64(i), 2)
    fmt.Println(s) // "11111111"
    // 将int类型的i转化为八进制字符串并输出
    s = strconv.FormatInt(int64(i), 8)
    fmt.Println(s) // "377"
    // 将int类型的i转化为十六进制字符串并输出
    s = strconv.FormatInt(int64(i), 16)
    fmt.Println(s) // "ff"
```

## 其他进制转换为10进制

```golang
    s := "377"
    i, err := strconv.ParseInt(s, 8, 0)
    if err != nil {
        fmt.Println(err)
    } else {
        fmt.Println(i) // 255
    }
```
