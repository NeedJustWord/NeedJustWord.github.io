# Windows命令计算文件哈希值

1. 打开cmd或者PowerShell

2. 输入如下命令计算文件哈希值

   ```bash
   #计算md5
   certutil -hashfile yourfilename.ext MD5
   ```

3. 命令说明

   ```bash
   C:\Users\user>certutil -hashfile -?
   用法:
     CertUtil [选项] -hashfile InFile [HashAlgorithm]
     通过文件生成并显示加密哈希
   
   选项:
     -Unicode          -- 以 Unicode 编写重定向输出
     -gmt              -- 将时间显示为 GMT
     -seconds          -- 用秒和毫秒显示时间
     -v                -- 详细操作
     -privatekey       -- 显示密码和私钥数据
     -pin PIN                  -- 智能卡 PIN
     -sid WELL_KNOWN_SID_TYPE  -- 数字 SID
               22 -- 本地系统
               23 -- 本地服务
               24 -- 网络服务
   
   哈希算法: MD2 MD4 MD5 SHA1 SHA256 SHA384 SHA512
   
   CertUtil -?              -- 显示动词列表(命名列表)
   CertUtil -hashfile -?    -- 显示 "hashfile" 动词的帮助文本
   CertUtil -v -?           -- 显示所有动词的所有帮助文本
   ```
