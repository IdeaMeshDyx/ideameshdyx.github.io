---
title: 2023 ospp fighting
catalog: true
date: 2023-04-19 05:02:23
subtitle:
header-img:
tags: ospp, edgemesh
categories: CNI Plugins
---

# CNI Plugins 调研

## 1. 通用 CNI 插件

> 主要基于 [containernetworking/plugins: Some reference and example networking plugins, maintained by the CNI team. (github.com)](https://github.com/containernetworking/plugins) ，[CNI](https://www.cni.dev/plugins/current/)

由CNI 官方社区维护的 CNI plugins 主要分为三类：

* `Main: interface-creating`: 主进程 CNI ,直接与 Linux 交流，创建接口、网络空间、对象等
* `IPAM: IP address allocation`:  地址管理插件，主要负责 IP 地址管理和分配
* `Meta: other plugins`: 其他的功能插件



### Main: interface-creating  主进程 CNI 

### [`bridge`](https://www.cni.dev/plugins/current/main/bridge/) 

​	创建虚拟网桥，并把本机（host）和容器（更准确说是network namespace）添加到其中

### [`macvlan`](https://www.cni.dev/plugins/current/main/macvlan/)

​	创建一个新的 MAC 地址，将相关容器的所有流量都转发到该地址

### [`ipvlan`](https://www.cni.dev/plugins/current/main/ipvlan/) 

​	类似于 `macvlan`创建虚拟局域网连接，给容器增加 [ipvlan ](https://www.kernel.org/doc/Documentation/networking/ipvlan.txt)接口，他主要有两种模式：

- L2 模式： 这个模式创建的容器网络与本机共享同一个 L2 设备，也就是说本机的广播数据包能够到达容器网络
- L3 模式：

这个模式创建对象的例子

``` c
  +=============================================================+
  |  Host: host1                                                |
  |                                                             |
  |   +----------------------+      +----------------------+    |
  |   |   NS:ns0             |      |  NS:ns1              |    |
  |   |                      |      |                      |    |
  |   |                      |      |                      |    |
  |   |        ipvl0         |      |         ipvl1        |    |
  |   +----------#-----------+      +-----------#----------+    |
  |              #                              #               |
  |              ################################               |
  |                              # eth0                         |
  +==============================#==============================+
（a） 创建两个网络命名空间 - ns0、ns1
		IP 网络添加 NS0
		IP 网络添加 NS1

（b） 在 eth0（主设备）上创建两个 ipvlan 从站。
		IP 链路添加链路 eth0 IPvl0 类型 IPvlan 模式 L2
		IP 链路添加链路 eth0 IPvl1 类型 IPvlan 模式 L2

（c） 将从属服务器分配到相应的网络命名空间
		IP link set dev ipvl0 netns ns0
		IP link set dev ipvl1 netns ns1

（d） 现在切换到命名空间（ns0 或 ns1）以配置从属设备
		- 对于 ns0
			（1） IP netns exec ns0 bash
			（2） IP 链路设置开发 IPvl0 向上
			（3） IP 链路设置开发
			（4） IP -4 地址添加 127.0.0.1 开发 LO
			（5） IP -4 地址添加 $IPADDR 开发 IPvl0
			（6） IP -4 路由通过$ROUTER开发 IPvl0 添加默认值
		- 对于 ns1
			（1） IP Netns exec NS1 Bash
			（2） IP 链路设置开发 IPvl1 向上
			（3） IP 链路设置开发
			（4） IP -4 地址添加 127.0.0.1 开发 LO
			（5） IP -4 地址添加 $IPADDR 开发 IPvl1
			（6） IP -4 路由通过$ROUTER开发 IPvl1 添加默认值
```



- [`ptp`](https://www.cni.dev/plugins/current/main/ptp/) : Creates a veth pair
- [`host-device`](https://www.cni.dev/plugins/current/main/host-device/) : Moves an already-existing device into a container
- [`vlan`](https://www.cni.dev/plugins/current/main/vlan/) : Creates a vlan interface off a master

#### Windows: windows specific 

- [`win-bridge`](https://www.cni.dev/plugins/current/main/win-bridge/) : Creates a bridge, adds the host and the container to it
- [`win-overlay`](https://www.cni.dev/plugins/current/main/win-overlay/) : Creates an overlay interface to the container