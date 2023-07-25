---
title: Go Pratical knowledge
catalog: true
date: 2023-04-10 01:18:26
subtitle:
header-img:
tags:
categories:
published: false
---

# 

``` golang
CNI_COMMAND=ADD CNI_CONTAINERID=lab-ns CNI_NETNS=/var/run/netns/lab-ns CNI_IFNAME=eth0 CNI_PATH=`pwd` ./bridge <../conf/lab-br0.conf

cat > lab-br0.conf <<"EOF"
{
    "cniVersion": "0.4.0",
    "name": "lab-br0",
    "type": "bridge",
    "bridge": "lab-br0",
    "isGateway": true,
    "ipMasq": true,
    "ipam": {
        "type": "host-local",
        "subnet": "10.15.10.0/24",
        "routes": [
            { "dst": "0.0.0.0/0" }
        ],
        "rangeStart": "10.15.10.100",
        "rangeEnd": "10.15.10.200",
        "gateway": "10.15.10.99"
    }
}
EOF

CNI_COMMAND=ADD CNI_CONTAINERID=e992e95204096b5f22dd4a8b0b5a3348a503c928d5eca71e84eac4fa96379011 CNI_NETNS=/var/run/docker/netns/ab1949fd7d3d CNI_IFNAME=eth0 CNI_PATH=`pwd` ./bridge <../conf/lab-br1.conf
```