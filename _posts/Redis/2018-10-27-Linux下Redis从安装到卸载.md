---
layout: post
title: Linux下Redis从安装到卸载
categories: Redis
tags: [Redis, Linux]
---

1. 下载安装包

   ```bash
   wget http://download.redis.io/releases/redis-5.0.0.tar.gz
   ```

   > 也可以去[官网](https://redis.io/)下载安装包后，通过文件传输工具传到Linux下。

2. 解压

   ```bash
   tar zxvf redis-5.0.0.tar.gz
   ```

3. 安装gcc

   ```bash
   yum install gcc
   ```

4. 编译

   ```bash
   cd redis-5.0.0
   make
   ```

   > 如果出现如下错误：
   >
   > ```bash
   > zmalloc.h:50:31: 致命错误：jemalloc/jemalloc.h：没有那个文件或目录
   > ```
   >
   > 则输入如下命令：
   >
   > ```bash
   > make MALLOC=libc
   > ```

5. 安装

   ```bash
   make install
   ```

   > 默认安装在/usr/local/bin目录下

   也可以通过如下命令指定安装目录

   ```bash
   make install PREFIX=/usr/redis
   ```

6. 简单配置

   执行如下命令将配置文件复制到安装目录下

   ```bash
   ## 假设安装在/usr/redis/bin下
   cp redis.conf /usr/redis/bin
   ```

   使用vi命令对配置文件进行如下修改

   ```bash
   ## 为了redis客户端远程能够访问
   1.将`bind 127.0.0.1`改为`#bind 127.0.0.1`
   2.将`protected-mode yes`改为`protected-mode no`,
   
   ## 指定日志文件目录，如果`/var/log/redis`目录不存在可使用`mkdir /var/log/redis`命令创建目录
   logfile "/var/log/redis/server-out.log"
   
   ## 默认启动时为后台启动
   daemonize yes
   ```

   > 此配置文件比较大，用vi修改不太方便，建议将配置文件复制到windows下修改好再复制回去

7. 启动

   加入环境变量

   ```bash
   ln -s /usr/redis/bin/* /usr/sbin
   ```

   启动redis

   ```bash
   redis-server redis.conf
   ```

   检查启动情况

   ```bash
   ps -ef | grep redis
   ```

   看到类似下面的一行，表示启动成功

   ```bash
   root     13456     1  0 21:59 ?        00:00:01 redis-server *:6379
   ```

   也可以用客户端测试是否启动成功 

   ```bash
   [root@localhost bin]# redis-cli 
   127.0.0.1:6379> set key test
   OK
   127.0.0.1:6379> get key
   "test"
   127.0.0.1:6379> exit
   [root@localhost bin]#
   ```

8. 停止

   ```bash
   ## 方法一（推荐方法）
   redis-cli shutdown
   
   ## 方法二
   [root@localhost bin]# ps -ef | grep redis
   root     13580     1  0 22:22 ?        00:00:00 redis-server *:6379
   root     13585  1283  0 22:22 pts/0    00:00:00 grep --color=auto redis
   [root@localhost bin]# kill -9 13580
   [root@localhost bin]# 
   ```

9. 设置开机启动

   ```bash
   echo "/usr/redis/bin/redis-server /usr/redis/bin/redis.conf" >>/etc/rc.local
   ```

   如果发现redis开机启动失败，则说明`/etc/rc.local没有启动`，执行以下命令后重启即可

   ```bash
   chmod +x /etc/rc.d/rc.local
   ```

   > 设置redis开机启动的方法有很多种，这只是其中一种

10. 开放端口

    开放redis监听的6379端口

    ```bash
    ## 编辑/etc/sysconfig/iptables文件：
    vi /etc/sysconfig/iptables
    
    ## 在22端口的下面加入内容并保存：
    ...
    -A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
    -A INPUT -p tcp -m state --state NEW -m tcp --dport 6379 -j ACCEPT
    ...
    
    ## CentOS6下重启服务：
    service iptables restart
    ## CentOS7下重启服务：
    systemctl restart iptables
    
    ## 查看端口是否开放：
    /sbin/iptables -L -n
    ```

    > 如果/etc/sysconfig/下没有iptables，请参考[解决CentOS（6和7版本）没有iptables的问题](../Linux/解决CentOS（6和7版本）没有iptables的问题.md)


11. 详细配置

    [Redis的详细配置](./Redis的详细配置.md)

12. 卸载

    关闭redis服务：客户端里输入shutdown命令即可

    退出客户端：exit

    卸载redis服务：删除redis的安装文件夹、编译文件夹及相关配置文件即可


