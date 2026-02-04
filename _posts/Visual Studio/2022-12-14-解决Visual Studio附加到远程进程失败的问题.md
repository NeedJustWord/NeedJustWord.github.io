---
layout: post
title: 解决Visual Studio附加到远程进程失败的问题
categories: [Visual Studio]
tags: [Visual Studio, 远程调试]
---

##### 问题：

Visual Studio 2019附加到远程进程时失败，报如下错误：

```
无法附加到进程。RPC服务器不可用。
```



##### 解决方法：

1. 打开菜单栏 **工具>选项**
2. 找到 **调试>常规>使用托管兼容模式** ，取消其勾选



参考资料：

1. [远程调试不起作用.无法附加到进程.RPC 服务器不可用.](https://www.it1352.com/2374842.html)
