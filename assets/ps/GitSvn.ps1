function Start-BatchUpdate {
    param(
        [ValidateNotNullOrEmpty()]
        [string]$Path = ($pwd).Path,
        [switch]$Git,
        [switch]$Svn,
        [switch]$Always
    )

    $CurrentRoot = ($pwd).Path

    Start-BatchUpdateInternal $Path $Git $Svn $Always

    Set-Location $CurrentRoot

    Write-Output ""

    <#
    .SYNOPSIS
    批量更新Git项目和Svn项目

    .DESCRIPTION
    查找Path参数指定目录下所有Git项目和Svn项目，并进行更新，支持只更新一次或循环更新直到更新成功为止

    .PARAMETER Path
    查找根目录，默认当前路径

    .PARAMETER Git
    更新找到的Git项目

    .PARAMETER Svn
    更新找到的Svn项目

    .PARAMETER Always
    循环更新直到更新成功为止
    #>
}

function Get-GitUrl {
    param(
        [ValidateNotNullOrEmpty()]
        [string]$Path = ($pwd).Path,
        [string]$OutputPath = ($pwd).Path,
        [string]$FileName = "GitUrl.txt",
        [switch]$WriteFile,
        [switch]$OverWrite,
        [switch]$GitClone,
        [switch]$CreateSameDir
    )

    $CurrentRoot = ($pwd).Path

    $WriteFile = $CreateSameDir -or $WriteFile
    if ($WriteFile -and (-not (Test-Path $OutputPath))) {
        New-Item -Path $OutputPath -ItemType Directory
    }

    $OutputFile = "$OutputPath\$FileName"
    if ($WriteFile -and $OverWrite -and (Test-Path $OutputFile)) {
        Clear-Content -Path $OutputFile
    }

    $Path = (Resolve-Path $Path).Path
    Get-GitUrlInternal $Path $Path $OutputFile $WriteFile $GitClone $CreateSameDir

    Set-Location $CurrentRoot

    Write-Output ""

    <#
    .SYNOPSIS
    批量获取本地Git项目的Url地址

    .DESCRIPTION
    批量获取Path参数指定目录下所有Git项目的Url地址，支持输出到指定文件里

    .PARAMETER Path
    查找根目录，默认当前路径

    .PARAMETER OutputPath
    输出目录，默认当前路径

    .PARAMETER FileName
    输出文件名，默认GitUrl.txt

    .PARAMETER WriteFile
    是否写文件

    .PARAMETER OverWrite
    是否覆盖文件

    .PARAMETER GitClone
    是否生成Git克隆命令

    .PARAMETER CreateSameDir
    是否创建相同的目录结构，设置此参数时表示写文件
    #>
}

#以下是内部函数
function Get-GitUrlInternal {
    param(
        [string]$Root,
        [string]$Path,
        [string]$OutputFile,
        [bool]$WriteFile,
        [bool]$GitClone,
        [bool]$CreateSameDir
    )

    if (Test-GitDir $Path) {
        Write-GitUrl $Path $OutputFile $WriteFile $GitClone
    }
    else {
        $HaveGitDir = $false
        $RelativeRoot = $Root
        if ($CreateSameDir) {
            Get-ChildItem $Path -Directory | Where-Object { -not $HaveGitDir } | ForEach-Object -Process {
                if (Test-GitDir $_.FullName) {
                    $HaveGitDir = $true
                }
            }

            if ($HaveGitDir) {
                $RelativeRoot = $Path
                if ($Root -ne $Path) {
                    Write-CreateAndEnterDirCmd $Root $Path $OutputFile
                }
            }
        }

        Get-ChildItem $Path -Directory | ForEach-Object -Process {
            Get-GitUrlInternal $RelativeRoot $_.FullName $OutputFile $WriteFile $GitClone $CreateSameDir
        }

        if ($HaveGitDir -and ($Root -ne $Path)) {
            Write-GoBackDirCmd $Root $Path $OutputFile
        }
    }
}

function Get-RelativeDir {
    param (
        [string]$Root,
        [string]$Path
    )

    return $Path.Substring($Root.Length + 1, $Path.Length - $Root.Length - 1)
}

function Write-CreateAndEnterDirCmd {
    param(
        [string]$Root,
        [string]$Path,
        [string]$OutputFile
    )

    $RelativeDir = Get-RelativeDir $Root $Path

    $Cmd = ""
    Write-Output $Cmd
    Add-Content -Path $OutputFile -Value $Cmd

    $Cmd = "if(-not (Test-Path ""$RelativeDir"")) {md ""$RelativeDir""}"
    Write-Output $Cmd
    Add-Content -Path $OutputFile -Value $Cmd

    $Cmd = "cd ""$RelativeDir"""
    Write-Output $Cmd
    Add-Content -Path $OutputFile -Value $Cmd
}

function Write-GoBackDirCmd {
    param(
        [string]$Root,
        [string]$Path,
        [string]$OutputFile
    )

    $RelativeDir = Get-RelativeDir $Root $Path
    $DirCount = $RelativeDir.Split('\').Length

    $Cmd = "cd .."
    for ($i = 1; $i -lt $DirCount; $i++) {
        $Cmd = "$Cmd/.."
    }

    Write-Output "$Cmd"
    Add-Content -Path $OutputFile -Value $Cmd
}

function Write-GitUrl {
    param(
        [string]$Path,
        [string]$OutputFile,
        [bool]$WriteFile,
        [bool]$GitClone
    )

    $GitDir = "$Path\.git"
    $ConfigFile = "$GitDir\config"
    $NotBreak = $True

    Set-Location $GitDir

    Get-Content -Path $ConfigFile | Where-Object { $NotBreak } | ForEach-Object -Process {
        if ($_ -like "*url = *") {
            $NotBreak = $False
            $Index = $_.IndexOf("=")
            $Value = $_.Substring($Index + 1, $_.Length - $Index - 1).Trim()
            if ($GitClone) {
                $Value = "git clone $Value"
            }
            Write-Output $Value
            if ($WriteFile) {
                Add-Content -Path $OutputFile -Value $Value
            }
        }
    }
}

function Start-BatchUpdateInternal {
    param(
        [ValidateNotNullOrEmpty()]
        [string]$Path = ($pwd).Path,
        [bool]$Git,
        [bool]$Svn,
        [bool]$Always
    )
    
    if (Test-GitDir $Path) {
        Write-Output ""
        Write-Output "找到Git目录，是否更新：$Git，是否更新成功为止：$Always，$Path"
        if ($Git) {
            Set-Location $Path
            if ($Always) {
                do {
                    git pull
                }until ($?)
            }
            else {
                git pull
            }
        }
    }
    elseif (Test-SvnDir $Path) {
        Write-Output ""
        Write-Output "找到Svn目录，是否更新：$Svn，是否更新成功为止：$Always，$Path"
        if ($Svn) {
            Set-Location $Path
            if ($Always) {
                do {
                    svn update
                }until ($?)
            }
            else {
                svn update
            }
        }
    }
    else {
        Get-ChildItem $Path -Directory | ForEach-Object -Process {
            Start-BatchUpdateInternal $_.FullName $Git $Svn $Always
        }
    }
}

function Test-GitDir {
    param(
        [ValidateNotNullOrEmpty()]
        [string]$Path = ($pwd).Path
    )
    
    return (Test-Path "$Path\.git")
}

function Test-SvnDir {
    param(
        [ValidateNotNullOrEmpty()]
        [string]$Path = ($pwd).Path
    )
    
    return (Test-Path "$Path\.svn")
}
