# ReadmeGenerator

#### 工具名称：

[Readme生成器](https://github.com/NeedJustWord/ReadmeGenerator)



#### 作用：

根据目录信息生成readme文件，其中目录名当作分类，文件名当作超链接

> 只支持一级目录



#### [v1.0.0](https://github.com/NeedJustWord/ReadmeGenerator/blob/master/Exes/ReadmeGenerator%20v1.0.0.rar)使用方法：

2. 按注释修改config配置文件
3. 运行exe程序，按任意键退出

```xml
<?xml version="1.0" encoding="utf-8" ?>
<configuration>
  <appSettings>
    <!--readme标题-->
    <add key="Heading" value="NeedJustWord的个人博客"/>

    <!--文件搜索字符串-->
    <add key="SearchPattern" value="*.md"/>

    <!--配置内容根目录，支持绝对路径和相对路径(相对执行程序的路径)-->
    <add key="Root" value="..\..\..\..\..\..\NeedJustWord.github.io\Blog"/>

    <!--readme.md文件所在目录，支持绝对路径和相对路径(相对执行程序的路径)-->
    <add key="ReadMeFilePath" value="..\..\..\..\..\..\NeedJustWord.github.io"/>
  </appSettings>
</configuration>
```

