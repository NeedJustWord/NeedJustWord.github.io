# BookmarkMergeTool

#### 工具名称：

谷歌浏览器书签合并工具



#### 背景：

公司和家里的谷歌浏览器书签需要同步，但是由于总所周知的原因，谷歌浏览器自带的书签同步功能不能使用，而手工合并费时费力。



#### 源码：

[https://github.com/NeedJustWord/BookmarkMergeTool](https://github.com/NeedJustWord/BookmarkMergeTool)



#### [v2.0.1](https://github.com/NeedJustWord/BookmarkMergeTool/blob/master/Exes/BookmarkMergeTool%20v2.0.1.rar)更新日志：

1. 提高程序的健壮性
2. 同一文件夹下的书签去重
3. 设置控制台标题并显示程序版本号
4. 将书签和文件夹的时间戳更新到最新值
5. 书签顺序的调整也能体现在合并后的书签里
6. 同时添加同一书签时，合并后只保留先添加的那个
7. 同时更新同一书签的图标时，合并后只保留后更新的那个



#### [v2.0.0](https://github.com/NeedJustWord/BookmarkMergeTool/blob/master/Exes/BookmarkMergeTool%20v2.0.0.rar)使用方法：

1. 打开BookmarkMergeTool.exe.config文件
2. 将basedFilePath设置成基准书签文件所在路径(相对路径或绝对路径)
3. 将待合并书签放到mergeDirectoryPath所指目录
4. 运行BookmarkMergeTool.exe程序，按任意键退出
5. mergeFilePath所指文件即是合并后的书签文件

>如果mergeFilePath和basedFilePath配置一样，则以后合并时只需将待合并书签放到mergeDirectoryPath目录下即可运行BookmarkMergeTool.exe程序合并，不需要再修改配置文件或者重命名待合并书签文件

```xml
<!--BookmarkMergeTool.exe.config文件内容-->
<?xml version="1.0" encoding="utf-8" ?>
<configuration>
  <appSettings>
    <!--基准书签文件-->
    <add key="basedFilePath" value="based.html"/>
    <!--合并书签所在目录-->
    <add key="mergeDirectoryPath" value="MergeFiles"/>
    <!--合并后的书签文件-->
    <add key="mergeFilePath" value="based.html"/>
    <!--是否备份基准书签文件-->
    <add key ="backupBasedFile" value="true"/>
  </appSettings>
</configuration>
```



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

