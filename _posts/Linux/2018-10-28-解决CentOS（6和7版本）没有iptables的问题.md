---
layout: post
title: 解决CentOS（6和7版本），/etc/sysconfig/下没有iptables的问题
categories: Linux
tags: [Linux, CentOS]
---

### 一、Centos 6版本解决办法：

1.任意运行一条iptables防火墙规则配置命令：

```bash
iptables -P OUTPUT ACCEPT
```

2.对iptables服务进行保存：

```bash
service iptables save
```

3.重启iptables服务：

```bash
service iptables restart
```

### 二、Centos 7版本解决办法：

1.停止并屏蔽firewalld服务

```bash
systemctl stop firewalld
systemctl mask firewalld
```

2.安装iptables-services软件包

```bash
yum install iptables-services
```

3.在引导时启用iptables服务

```bash
systemctl enable iptables
```

4.启动iptables服务

```bash
systemctl start iptables
```

5.保存防火墙规则

```bash
service iptables save
或
/usr/libexec/iptables/iptables.init save
```

另外：管理iptables服务

```bash
systemctl [stop|start|restart] iptables
```



参考资料：

1. [解决CentOS（6和7版本），/etc/sysconfig/下没有iptables的问题](https://blog.csdn.net/csdn_lqr/article/details/53885808)

