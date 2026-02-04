---
layout: post
title: Oracle删除Date日期后的时分秒
categories: Oracle
tags: [Oracle]
---

#### 问题

想将1997/1/8 10:30:27变为1997/1/8，但又不想使用to_char再to_date这样两次转换。

#### 解决方案

```sql
--trunc一下即可
select trunc(sysdate) from dual
```

参考资料：

1. [Oracle删除Date日期后的时分秒](https://blog.csdn.net/grace_cxj/article/details/115732263)
