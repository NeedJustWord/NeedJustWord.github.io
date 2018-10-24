## 如何删除一个CSDN上自己上传的资源

原文地址：http://www.xuebuyuan.com/1875216.html



找到你想删除的资源，其URL举例为：

```
http://download.csdn.net/detail/ssergsw/1234567
```

则删除的get请求为：

```
http://download.csdn.net/index.php/user_console/del_my_source/1234567
```

删除成功返回：

```
{"succ":1,"msg":""}
```

如果是因为没有权限，删除失败返回：

```
{"succ":0,"msg":"\u4f60\u6ca1\u6709\u6743\u9650\u64cd\u4f5c"}
```

即：

```
{"succ":0,"msg":"你没有权限操作"}
```


