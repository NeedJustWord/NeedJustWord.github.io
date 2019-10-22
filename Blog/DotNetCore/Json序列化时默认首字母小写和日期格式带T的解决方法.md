# Json序列化时默认首字母小写和日期格式带T的解决方法

打开Startup.cs文件，在ConfigureServices方法添加如下代码

```c#
services.AddMvc()
    .AddJsonOptions(option =>
    {
        //配置大小写问题，默认是首字母小写
        option.SerializerSettings.ContractResolver = new Newtonsoft.Json.Serialization.DefaultContractResolver();
        //配置序列化的时间格式为yyyy-MM-dd HH:mm:ss
        option.SerializerSettings.DateFormatString = "yyyy-MM-dd HH:mm:ss";
    })
```

