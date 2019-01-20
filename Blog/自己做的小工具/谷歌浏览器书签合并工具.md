# BookmarkMergeTool

#### 工具名称：

谷歌浏览器书签合并工具



#### 背景：

公司和家里的谷歌浏览器书签需要同步，但是由于总所周知的原因，谷歌浏览器自带的书签同步功能不能使用，而手工合并费时费力。



#### [v1.0.0](https://github.com/NeedJustWord/BookmarkMergeTool/blob/master/Exes/BookmarkMergeTool%20v1.0.0.rar)使用方法：

1. 打开BookmarkMergeTool.exe.config文件
2. 按注释修改value的值为对应文件的路径(相对路径或绝对路径)
3. 运行BookmarkMergeTool.exe程序，按任意键退出
4. mergeFilePath所指文件即是合并后的书签文件

```xml
<!--BookmarkMergeTool.exe.config文件内容-->
<?xml version="1.0" encoding="utf-8" ?>
<configuration>
  <appSettings>
    <!--基准书签文件-->
    <add key="basedFilePath" value="based.html"/>
    <!--家里的书签文件-->
    <add key="homeFilePath" value="home.html"/>
    <!--公司的书签文件-->
    <add key="companyFilePath" value="company.html"/>
    <!--合并后的书签文件，程序稳定后设置成和basedFilePath的一样-->
    <add key="mergeFilePath" value="merge.html"/>
  </appSettings>
</configuration>
```

