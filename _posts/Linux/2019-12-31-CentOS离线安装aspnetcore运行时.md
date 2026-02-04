---
layout: post
title: CentOS离线安装aspnetcore运行时
categories: Linux
tags: [Linux, CentOS, aspnetcore]
---

1. #### [官网](https://dotnet.microsoft.com/download/dotnet-core)下载自己需要的aspnetcore运行时

2. #### 通过工具将下载的运行时文件传到linux系统

3. #### 解压

   ```bash
   #创建dotnet目录
   mkdir /usr/local/bin/dotnet
   
   #进入压缩包所在目录，这里是/home
   cd /home
   
   #将文件解压到dotnet目录
   tar -zvxf aspnetcore-runtime-2.2.8-linux-x64.tar.gz -C /usr/local/bin/dotnet
   ```

4. #### 配置环境变量

   ```bash
   #修改profile文件
   vi /etc/profile
   
   #在文件末尾加上如下两行
   export DOTNET_ROOT=/usr/local/bin/dotnet
   export PATH=$DOTNET_ROOT:$PATH
   
   #按Esc，执行如下命令保存退出
   :wq
   
   #执行如下命令使改动生效
   source /etc/profile
   ```

5. #### 验证dotnetcore环境

   ```bash
   #查看运行时版本信息
   dotnet --info
   ```
