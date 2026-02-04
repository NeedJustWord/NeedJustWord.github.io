---
layout: post
title: 手动添加Git Bash Here到右键菜单
categories: Git
tags: [Git, 右键菜单]
---

##### 问题：

安装Git的时候，没有勾选安装Git Bash Here到右键菜单



##### 解决方法：

1. Win+R键，弹出命令行输入框，输入：**regedit**，打开注册表
2. 找到路径：**计算机\HKEY_CLASSES_ROOT\Directory\Background**
3. 在[Background]下如果没有[shell]，则**在[Background]下右键-新建-项[shell]**
4. **在[shell]下右键-新建-项[Open in Git]**，其默认值为**Git Bash Here**，此为右键菜单显示名称
5. **在[Open in Git]下右键-新建-字符串值[Icon]**，双击编辑，其值为**C:\Program Files\Git\mingw64\share\git\git-for-windows.ico**，此为右键菜单图标
6. **在[Open in Git]下右键-新建-项[command]**，其默认值为**C:\Program Files\Git\git-bash.exe**

> 路径按Git实际安装路径填写




##### 参考资料：

1. [手动添加git 到 右键菜单](https://www.cnblogs.com/whm-blog/p/7525903.html)
