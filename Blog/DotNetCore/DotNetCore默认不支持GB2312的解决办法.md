# DotNetCore默认不支持GB2312的解决办法

第一步：通过NuGet安装**System.Text.Encoding.CodePages**包。

第二步：在启动函数Main的第一行加上如下代码。

```c#
Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
```


