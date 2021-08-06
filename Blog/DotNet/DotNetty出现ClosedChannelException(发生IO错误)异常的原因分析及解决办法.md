# DotNetty出现ClosedChannelException(发生IO错误)异常的原因分析及解决办法

## 症状

​		同一份代码，在控制台程序下没有问题，在网站上出错，出错日志及出错位置如下

```c#
//出错日志
连接服务端(ip:port)失败，3秒后重试，发生 I/O 错误。
DotNetty.Transport.Channels.ClosedChannelException: 发生 I/O 错误。
   在 System.Runtime.CompilerServices.TaskAwaiter.ThrowForNonSuccess(Task task)
   在 System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   在 DotNetty.Transport.Bootstrapping.Bootstrap.<DoResolveAndConnectAsync>d__15.MoveNext()
--- 引发异常的上一位置中堆栈跟踪的末尾 ---
   在 System.Runtime.CompilerServices.TaskAwaiter.ThrowForNonSuccess(Task task)
   在 System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   在 System.Runtime.CompilerServices.ConfiguredTaskAwaitable`1.ConfiguredTaskAwaiter.GetResult()

//出错位置
channel = await bootstrap.ConnectAsync(remoteEndPoint).ConfigureAwait(false);
```



## 调试

​		调试网站，发现以下代码出现异常

```c#
//代码
bootstrap.Group(workGroup)
    .Channel<TcpSocketChannel>()
    .Option(ChannelOption.TcpNodelay, true)
    .Option(ChannelOption.ConnectTimeout, TimeSpan.FromMilliseconds(5000))
    .Handler(new ActionChannelInitializer<ISocketChannel>(c =>
    {
        var pipeline = c.Pipeline;
        //下面这句代码出现异常
        pipeline.AddLast(
           new HttpClientCodec(),
           new HttpObjectAggregator(8192),
           WebSocketClientCompressionHandler.Instance,
           handler);
    }));

//异常
System.TypeInitializationException
  HResult=0x80131534
  Message=“DotNetty.Codecs.Http.HttpObjectAggregator”的类型初始值设定项引发异常。

内部异常 1:
FileLoadException: 未能加载文件或程序集“System.Runtime.CompilerServices.Unsafe, Version=4.0.4.1, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a”或它的某一个依赖项。找到的程序集清单定义与程序集引用不匹配。 (异常来自 HRESULT:0x80131040)
```

​		在监视窗口输入以下代码查看程序集加载的System.Runtime.CompilerServices.Unsafe版本信息

```c#
//代码
AppDomain.CurrentDomain.GetAssemblies().Where(t=>t.FullName.Contains("System.Runtime.CompilerServices.Unsafe")).ToList()

//网站查到的版本信息
FullName:System.Runtime.CompilerServices.Unsafe, Version=4.0.4.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a
CodeBase:网站根目录
Location:一个临时目录
    
//控制台查到的版本信息
FullName:System.Runtime.CompilerServices.Unsafe, Version=4.0.4.1, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a
CodeBase:控制台根目录
Location:控制台根目录
```

​		使用dnSpy反编译上面3个目录下的System.Runtime.CompilerServices.Unsafe.dll文件，发现网站根目录和临时目录的该文件确实是4.0.4.0版本



## 原因

​		网站生成的System.Runtime.CompilerServices.Unsafe.dll文件不对导致的



## 验证

​		将控制台的System.Runtime.CompilerServices.Unsafe.dll文件复制到网站根目录，重启网站，问题解决



## 分析

​		System.Runtime.CompilerServices.Unsafe组件是DotNetty引入的，DotNetty是通过NuGet安装的。但是DotNetty是封装在一个公共类库给网站和控制台使用，按理说不会出现生成文件不一样的问题。

​		于是我在所有csproj文件里搜索System.Runtime.CompilerServices.Unsafe，最终让我发现了问题的根本原因。原来网站项目和控制台项目都通过NuGet各自安装了System.Runtime.CompilerServices.Unsafe，不过控制台安装的是4.5.2版本，而网站安装的是4.5.0版本，生成时最终使用的是网站和控制台里安装的版本。



## 解决办法

​		在NuGet可以看到使用的DotNetty版本依赖的是4.5.2版本的System.Runtime.CompilerServices.Unsafe，至此，有以下两种办法解决：

​		方法一：网站把System.Runtime.CompilerServices.Unsafe改成4.5.2版本

​		方法二：网站不通过NuGet安装System.Runtime.CompilerServices.Unsafe

