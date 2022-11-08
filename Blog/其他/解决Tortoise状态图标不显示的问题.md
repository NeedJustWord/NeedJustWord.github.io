# 解决Tortoise状态图标不显示的问题

##### 正常情况：

git和svn目录下的文件和文件夹会显示状态图标，绿色图标表示提交成功，红色图标表示已修改但还未提交。



##### 问题：

状态图标不显示，无法直观的知道文件和文件夹的状态。



##### 解决方法：

1. Win+R键，弹出命令行输入框，输入：**regedit**，打开注册表
2. 找到路径：**计算机\HKEY_LOCAL_MACHINE\Software\Microsoft\windows\CurrentVersion\Explorer**
3. 修改键名 **Max Cached Icons** (最大缓存图标)的值为 **2000** ，如果不存在，新建->字符串值，输入键名和键值
4. 找到路径：**计算机\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers**
3. 将Tortoise相关的项都提到靠前的位置(**重命名，在名称之前加空格**)，完成之后 **点击菜单栏->查看->刷新** ，检查是否在最前面
6. **重启电脑** 或者 **任务管理器中重启windows资源管理器**



参考资料：

1. [解决git文件夹不显示图标问题](https://blog.csdn.net/Aaron_King/article/details/126153694)
1. [Git 状态图标不显示的解决办法](https://www.cnblogs.com/chenjin2136/p/16551321.html)
