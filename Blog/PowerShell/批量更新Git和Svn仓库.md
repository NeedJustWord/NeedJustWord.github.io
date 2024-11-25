# 批量更新Git和Svn仓库

##### 问题：

代码仓库一多，一个个更新的话麻烦



##### PowerShell脚本内容：

```powershell
function Start-BatchUpdate{
    param(
        [ValidateNotNullOrEmpty()]
        [string]$Path=($pwd).Path,
        [switch]$Git,
        [switch]$Svn,
        [switch]$Always
    )

    $CurrentRoot=($pwd).Path

    Start-BatchUpdateInternal $Path $Git $Svn $Always

    cd $CurrentRoot
}

function Start-BatchUpdateInternal{
    param(
        [ValidateNotNullOrEmpty()]
        [string]$Path=($pwd).Path,
        [bool]$Git,
        [bool]$Svn,
        [bool]$Always
    )
    
    if(Test-GitDir $Path){
        Write-Output "找到Git目录，是否更新：$Git，$Path"
        if($Git){
            cd $Path
            if($Always){
                do{
                    git pull
                }while (!($?))
            }
            else{
                git pull
            }
        }
    }
    elseif(Test-SvnDir $Path){
        Write-Output "找到Svn目录，是否更新：$Svn，$Path"
        if($Svn){
            cd $Path
            if($Always){
                do{
                    svn update
                }while (!($?))
            }
            else{
                svn update
            }
        }
    }
    else {
       Get-ChildItem $Path -Directory | ForEach-Object -Process{
            Start-BatchUpdateInternal $_.FullName $Git $Svn
       }
    }
}

function Test-GitDir{
    param(
        [ValidateNotNullOrEmpty()]
        [string]$Path=($pwd).Path
    )
    
    return (Test-Path "$Path\.git")
}

function Test-SvnDir{
    param(
        [ValidateNotNullOrEmpty()]
        [string]$Path=($pwd).Path
    )
    
    return (Test-Path "$Path\.svn")
}

Export-ModuleMember -Function Start-BatchUpdate
```



##### PowerShell创建自定义模块：

```powershell
#打开PowerShell，执行以下命令（只需执行一次，以后更新Git和Svn仓库时也不用执行了）

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
#修改当前用户的执行策略为RemoteSigned，输入a回车确定更改执行策略

Write-Output $env:PSModulePath
#打印模块路径，打印内容如下：
#F:\系统文件夹\文档\WindowsPowerShell\Modules;C:\Program Files\WindowsPowerShell\Modules;C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules

mkdir F:\系统文件夹\文档\WindowsPowerShell\Modules\GitSvn
#在打印模块路径中选择一个模块路径创建GitSvn模块

cd F:\系统文件夹\文档\WindowsPowerShell\Modules\GitSvn
#进入GitSvn模块路径

#将上一节PowerShell脚本内容使用gb2312编码保存成GitSvn.psm1文件，放到GitSvn模块路径

New-ModuleManifest -Path .\GitSvn.psd1 -ModuleVersion "1.0" -Author "NeedJustWord" -RootModule GitSvn
#创建GitSvn模块清单，此命令还指定版本号为1.0，作者为NeedJustWord

Add-Content $PROFILE.CurrentUserAllHosts 'Import-Module GitSvn'
#当前用户导入GitSvn模块
```



##### PowerShell批量更新Git和Svn仓库：

```powershell
Start-BatchUpdate -Path E:\GitHub -Git -Svn
#命令功能：
#批量更新指定目录下的Git仓库和Svn仓库。仓库所在目录没有要求，此命令会遍历查找所有仓库并按需更新

#参数说明：
#-Path E:\GitHub
#更新目录指定为E:\GitHub，省略此参数时更新目录为当前目录

#-Git
#开关参数，有此参数表示批量更新-Path指定目录下的Git仓库

#-Svn
#开关参数，有此参数表示批量更新-Path指定目录下的Svn仓库
```



##### 其他问题：

1. 更新Svn仓库时报错，错误消息：无法将“svn”项识别为 cmdlet、函数、脚本文件或可运行程序的名称

   解决方案：

   1. 点击TortoiseSVN安装包，双击安装包 > Next > Modify
   2. 将command line client tools选中为安装到本地（默认该tools是不安装的）
   3. 结束安装



##### 参考资料：

1. [开始使用PowerShell](https://learn.microsoft.com/zh-cn/powershell/scripting/learn/ps101/01-getting-started?view=powershell-5.1)
2. [自定义供日常使用的PowerShell脚本模块](https://zhuanlan.zhihu.com/p/429002760)
3. [通过命令行无法使用svn](https://blog.csdn.net/qq_39025293/article/details/119564394)