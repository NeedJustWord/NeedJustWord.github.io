# 解决Typora的测试版已过期问题

##### 问题：

Typora开始收费了，之前的测试版打开会报如下错误：

```
This beta version of Typora is expired,please download and install a newer version.
```



##### 解决方法：

1. Win+R键，弹出命令行输入框，输入：**regedit**，打开注册表
2. 在注册表的输入框输入：**计算机\HKEY_CURRENT_USER\SOFTWARE\Typora**
3. 找到 **Typora**，然后 **右键**，选择 **权限**
4. 把权限里 **每个用户** 的 **权限** 都选择 **拒绝** ，然后 **应用+确认**，应用如果是灰色就单点确认
5. 然后会弹出一个标题为《Windows 安全中心》的提示，选择 **是**
6. 最后测试，现在可以打开Typora了



参考资料：

1. [解决Typora的测试版已过期问题](https://www.cnblogs.com/XYH-Learning/p/16515578.html)
