# 使用AdoNetCore.AseClient连接Sybase数据库时报不支持cp936字符集的解决方法

第一步：通过NuGet安装**System.Text.Encoding.CodePages**包。

第二步：扩展EncodingProvider以将“cp936”映射到编码。

```C#
class Cp936EncodingProvider : EncodingProvider
{
    public override Encoding GetEncoding(int codepage)
    {
        return null; // we're only matching on name, not codepage
    }

    public override Encoding GetEncoding(string name)
    {
        if (string.Equals("cp936", name, StringComparison.OrdinalIgnoreCase))
        {
            return Encoding.GetEncoding(936); // this will load an encoding from theCodePagesEncodingProvider
        }
        return null;
    }
}
```

第三步：在启动函数Main的第一行加上如下代码。

```c#
Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
Encoding.RegisterProvider(new Cp936EncodingProvider());
```

