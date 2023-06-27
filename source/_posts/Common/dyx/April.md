---
title: Searching List
catalog: true
date: 2023-03-02 00:46:21
subtitle:
header-img:
tags: Searching List， April
categories: Common
published: false
---

# Github 

[Git - git-remote Documentation (git-scm.com)](https://git-scm.com/docs/git-remote)

### 添加github 远程仓库

```shell
git remote add origin <REMOTE_URL>
```

[About remote repositories - GitHub Docs](https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories)

### 同步远程仓库内容：

```shell
//在本地新建一个temp分支，并将远程origin仓库的master分支代码下载到本地
git fetch origin master:temp
//比较本地仓库与下载的temp分支
git diff temp
//合并temp分支到本地的master分支对比区别之后，如果觉得没有问题，可以使用如下命令进行代码合并
git merge temp
```

### 强制覆盖远程仓库

```shell
// 查看本地仓库配置
git config --local --list
 
// 如果有本地与远程关联，保留(多仓库关联)/不保留，看实际需要
// 此处我选择不保留，即单仓库关联
git remote remove origin
 
// 添加本地仓库与远程仓库关联
git remote add origin XXX.git
 
// 强制推送到远程仓库，且覆盖远程代码库
git push -f --set-upstream origin master:master
```

> [如何将本地的项目一键同步到GitHub - 尹鹏宇的博客 | Yean's Blog (wdblink.github.io)](https://wdblink.github.io/2019/03/24/如何将本地的项目一键同步到GitHub/#:~:text=在github中新建一个repository，复制仓库地址： 同步本地仓库到远程仓库 执行命令： %2F%2F新建一个repository时会出现下面的代码，直接复制即可 %24,git remote add origin https%3A%2F%2Fgithub.com%2FCongliYin%2FCSS.git)
>
> [git 本地与远程仓库同步操作 - 简书 (jianshu.com)](https://www.jianshu.com/p/b37ff443de15)

### 在一台电脑上创建两个github账号

#### 1. 生成新的ssh-key

保存的时候，输入一个新的文件名，如：id_rsa_second

```
ssh-keygen -t rsa -C "your_email@example.com"    # Creates a new ssh key, using the provided email as a label    # Generating public/private rsa key pair.    # Enter file in which to save the key (/Users/you/.ssh/id_rsa_second): [Press enter] 
```

#### 2. 添加到ssh-agent（每次重启之后都需要调用这句）

```
    $ssh-add ~/.ssh/id_rsa_second 
```

#### 3. 添加ssh key到github

见[配置ssh-key](https://help.github.com/articles/generating-ssh-keys)。

#### 4. 配置多个ssh-key

修改`~/.ssh/config`文件，如下：

```
    #default github    Host github.com      HostName github.com      IdentityFile ~/.ssh/id_rsa     Host github_second      HostName github.com      IdentityFile ~/.ssh/id_rsa_second 
```

#### 5. 使用别名pull/push代码

如：

```
    git clone git@github_second:username/reponame 
```

#### 6. 为每个账号对应的项目配置email/name

```
    1.取消global    git config --global --unset user.name    git config --global --unset user.email     2.设置每个项目repo的自己的user.email    git config  user.email "xxxx@xx.com"    git config  user.name "xxxx" 
```

这样，以后每次在相应的repo下提交更改，都会自动匹配相应的ssh-key了。

### 查看本地 git 配置

config 配置有system级别 global（用户级别） 和local（当前仓库）三个 设置先从system-》global-》local  底层配置会覆盖顶层配置 分别使用--system/global/local 可以定位到配置文件

```shell
# 查看系统config
git config --system --list
# 查看当前用户（global）配置
git config --global  --list
# 查看当前仓库配置信息
git config -- local    --list

```

### rebase

[图解 Git 基本命令 merge 和 rebase - Michael翔 - 博客园 (cnblogs.com)](https://www.cnblogs.com/michael-xiang/p/13179837.html)

[关于 Git 变基 - GitHub 文档](https://docs.github.com/zh/get-started/using-git/about-git-rebase)





```shell
git branch -m main master
git fetch origin
git branch -u origin/master master
git remote set-head origin -a
```

## 缩短 ubuntu 文件目录的长度

```shell

```