# Unity埋坑记

### 坑一：

1. 背景：

   参考[C# Unity依赖注入](https://www.cnblogs.com/wwj1992/p/6728370.html)这篇博客学习Unity的**配置文件注册**。

2. 问题描述：

   使用配置文件注册时报异常，异常信息：**创建 unity 的配置节处理程序时出错: 未能加载文件或程序集“Microsoft.Practices.Unity.Configuration”或它的某一个依赖项。系统找不到指定的文件。**

3. 问题复现：

   a. 通过nuget安装Unity5.8.6

   b. 配置文件

   ```c#
   <?xml version="1.0" encoding="utf-8" ?>
   <configuration>
     <configSections>
       <section name="unity" type="Microsoft.Practices.Unity.Configuration.UnityConfigurationSection, Microsoft.Practices.Unity.Configuration" />
     </configSections>
     <unity xmlns="http://schemas.microsoft.com/practces/2010/unity">
       <containers>
         <!--MyContainer为自定义名称 只需要和调用时名称保持一致即可-->
         <container name="MyContainer">
           <!--type为对象的名称,mapTo为注入对象的名称 写法为用逗号隔开两部分，一是类的全部，包括命名空间，二是程序集名称-->
           <register type="ThreadDemo.Bll.IUserBll,ThreadDemo" mapTo="ThreadDemo.Bll.impl.UserBll,ThreadDemo">
             <lifetime type="singleton" />
           </register>
           <register type="ThreadDemo.Dal.IUserDal,ThreadDemo" mapTo="ThreadDemo.Dal.impl.UserDal,ThreadDemo"/>
         </container>
       </containers>
     </unity>
     <!--startup必须放在<configSections>节点下面，否则报错-->
     <startup>
       <supportedRuntime version="v4.0" sku=".NETFramework,Version=v4.5.2" />
     </startup>
   </configuration>
   ```

   c. 程序代码

   ```c#
   class Program
   {
   	public IUserBll UserBll { get; set; }
   
   	public static void Main(string[] args)
   	{
   		UnityContainer container = new UnityContainer();
   		UnityConfigurationSection config = (UnityConfigurationSection)ConfigurationManager.GetSection(UnityConfigurationSection.SectionName);//这里报异常
   
   		config.Configure(container, "MyContainer");
   
   		IUserBll IUser = container.Resolve<IUserBll>();
   
   		IUser.Display("test");
   		Console.ReadLine();
   	}
   }
   ```

4. 问题出现的原因：

   博客里使用的Unity是4.0.1版本，这个版本的Unity文件如下：

   ```c#
   //4.0.1
   Microsoft.Practices.Unity.Configuration.dll
   Microsoft.Practices.Unity.dll
   Microsoft.Practices.Unity.RegistrationByConvention.dll
   Microsoft.Practices.ServiceLocation.dll
   ```

   但是从5.0.0开始，Unity的文件变成如下：

   ```c#
   //5.0.0
   Unity.Abstractions.dll
   Unity.Container.dll
   
   //5.0.1
   Unity.Abstractions.dll
   Unity.Container.dll
   Unity.Configuration.dll
   ......
   ```

   所以如果照搬4.0.1版的配置文件，就会出现系统找不到指定的文件的异常。

   > 4.0.1配置的section是找Microsoft.Practices.Unity.Configuration程序集

5. 解决方案：

   知道了问题的原因，解决问题那就简单了，只需将配置文件里的section配置改成如下即可：

   ```c#
   <section name="unity" type="Microsoft.Practices.Unity.Configuration.UnityConfigurationSection, Unity.Configuration" />
   ```

   > 5.0.1开始，Microsoft.Practices.Unity.Configuration.UnityConfigurationSection类定义在Unity.Configuration程序集。

   > 我推测5.0.0不能使用配置文件的方式注册。

6. 花絮：



### 坑二：

