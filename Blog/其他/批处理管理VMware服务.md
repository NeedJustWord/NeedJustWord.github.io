# 批处理管理VMware服务

1. 打开服务管理界面，将VMware打头的服务全部设置成手动启动。
2. 将下面的批处理脚本保存成bat格式的文件。
3. 用管理员权限启动脚本。

```bash
::关闭回显，有@包括自己，没@不包括自己
@echo off

goto color

::color 2f
::设置背景色(前)和前景色(后)
::0 = 黑色   8 = 灰色
::1 = 蓝色   9 = 淡蓝色
::2 = 绿色   A = 淡绿色
::3 = 浅绿色 B = 淡浅绿色
::4 = 红色   C = 淡红色
::5 = 紫色   D = 淡紫色
::6 = 黄色   E = 淡黄色
::7 = 白色   F = 亮白色

:color
color 2f

::清屏
cls

echo.
echo 1——VMware安装在默认路径
echo.
echo 2——VMware没有安装在默认路径
echo.
echo 3——退出
echo.

:choosePath
set /p t=请选择(1/2/3):

if /i '%t%'=='1' goto defaultPath
if /i '%t%'=='2' goto nonDefaultPath
if /i '%t%'=='3' goto exit

echo.
echo 选择错误
echo.
goto :choosePath

:defaultPath
echo %PROCESSOR_ARCHITECTURE% | findstr "64" && (set v_path="C:\Program Files (x86)\VMware\VMware Workstation") || (set v_path="C:\Program Files\VMware\VMware Workstation")
goto existPath

:nonDefaultPath
set /p v_path=请输入VMware的安装路径(两头不要带引号),输入1表示默认路径,输入3退出:
set v_path="%v_path%"

:existPath
if /i '%v_path%'=='"1"' goto defaultPath
if /i '%v_path%'=='"3"' goto exit

if not exist %v_path% (
echo.
echo 路径不存在:%v_path%
echo.
goto nonDefaultPath
)

cd /d %v_path%
cls

:menu
echo ======= VMware服务管理脚本 =======
echo.
echo 1――打开VMware服务和启动相关程序
echo.
echo 2――停止VMware服务和关闭相关程序
echo.
echo 3——退出
echo.

:choose
set /p t=请选择(1/2/3):

if /i '%t%'=='1' goto start
if /i '%t%'=='2' goto stop
if /i '%t%'=='3' goto exit

echo.
echo 选择错误
echo.
goto :choose

:start
echo.&&echo 正在打开VMWare服务和启动相关程序,请稍候...

::>nul表示不输出成功信息
net start VMAuthdService
net start VMnetDHCP
net start "VMware NAT Service"
net start VMUSBArbService
net start VMwareHostd

echo.
if exist hqtray.exe (
echo 开始启动hqtray.exe
start hqtray.exe
) else (
echo hqtray.exe不存在
)

echo.
if exist vmware-tray.exe (
echo 开始启动vmware-tray.exe
start vmware-tray.exe
) else (
echo vmware-tray.exe不存在
)

echo.
if exist vmware.exe (
echo 开始启动vmware.exe
start vmware.exe
) else (
echo vmware.exe不存在
)

echo.
echo done.
echo.
goto menu

:stop
echo.&&echo 正在停止VMWare服务和关闭相关程序,请稍候...
net stop VMwareHostd
net stop VMAuthdService
net stop VMnetDHCP
net stop "VMware NAT Service"
net stop VMUSBArbService

if exist hqtray.exe (
echo.
echo 开始终止hqtray.exe
taskkill /f /t /im hqtray.exe
)

if exist vmware-tray.exe (
echo.
echo 开始终止vmware-tray.exe
taskkill /f /t /im vmware-tray.exe
)

if exist vmware.exe (
echo.
echo 开始终止vmware.exe
taskkill /f /t /im vmware.exe
)

echo.
echo done.
echo.
goto menu

:exit
exit
```


