---
layout: post
title: 解决Visual Studio扩展项目生成失败的问题
categories: [Visual Studio]
tags: [Visual Studio, 扩展]
---

##### 问题：

Visual Studio扩展项目生成失败，报如下错误：

```
Extension '扩展项目名.扩展Guid' could not be found. Please make sure the extension has been installed.
```



##### 解决方法：

1. 打开我的电脑，进入 **C:\Users\XXX\AppData\Local\Microsoft\VisualStudio** 目录，找到Exp结尾的目录名 **16.0_46e311f3Exp** (可能有多个这种目录，找到对应自己编译扩展的Visual Studio版本的那个)
2. 打开cmd，进入 **VS版本安装目录\VSSDK\VisualStudioIntegration\Tools\Bin** 目录，例如 **C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VSSDK\VisualStudioIntegration\Tools\Bin**
3. 输入命令 **CreateExpInstance.exe /Reset /VSInstance=16.0_46e311f3 /RootSuffix=Exp** 后回车即可



##### 参考资料：

1. [Extension could not be found. Please make sure the extension has been installed](https://stackoverflow.com/questions/32870002/extension-could-not-be-found-please-make-sure-the-extension-has-been-installed)
