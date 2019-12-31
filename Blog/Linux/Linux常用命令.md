# Linux常用命令

### shutdown:

```bash
#立即关机
shutdown -h now

#立即重启
shutdown -r now
```

### tar:

```bash
#解压到当前目录
tar -zvxf fileName.tar.gz

#解压到指定目录test
tar -zvxf fileName.tar.gz -C /usr/local/bin/test
```

### mkdir:

```bash
#在当前目录下创建test目录
mkdir test

#在父目录/home/a下创建b目录，父目录不存在则创建失败
mkdir /home/a/b

#在父目录/home/c下创建d目录，父目录不存在则自动创建，然后创建d目录
mkdir -p /home/c/d
```

