# ReadmeGenerator

#### 工具名称：

[Readme生成器](https://github.com/NeedJustWord/ReadmeGenerator)



#### 作用：

根据目录信息生成readme文件



#### [v2.0.0](https://github.com/NeedJustWord/ReadmeGenerator/blob/master/Exes/ReadmeGenerator%20v2.0.0.rar)更新日志：

1. 支持多级目录生成层级结构的readme文件
2. 目录生成能跳转到对应目录的超链接
3. 文件超链接显示文件名后缀
4. 生成后自动退出程序



#### [v1.0.0](https://github.com/NeedJustWord/ReadmeGenerator/blob/master/Exes/ReadmeGenerator%20v1.0.0.rar)使用方法：

1. 按注释修改config配置文件
2. 运行exe程序，按任意键退出

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

