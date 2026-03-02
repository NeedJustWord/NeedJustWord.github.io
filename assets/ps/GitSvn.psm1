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
        [switch]$GitClone
    )

    $CurrentRoot = ($pwd).Path
    if ($WriteFile -and (-not (Test-Path $OutputPath))) {
        New-Item -Path $OutputPath -ItemType Directory
    }

    $OutputFile = "$OutputPath\$FileName"
    if ($WriteFile -and $OverWrite -and (Test-Path $OutputFile)) {
        Clear-Content -Path $OutputFile
    }

    Get-GitUrlInternal $Path $OutputFile $WriteFile $GitClone

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
    #>
}

#以下是内部函数
function Get-GitUrlInternal {
    param(
        [string]$Path,
        [string]$OutputFile,
        [bool]$WriteFile,
        [bool]$GitClone
    )

    if (Test-GitDir $Path) {
        Write-GitUrl $Path $OutputFile $WriteFile $GitClone
    }
    else {
        Get-ChildItem $Path -Directory | ForEach-Object -Process {
            Get-GitUrlInternal $_.FullName $OutputFile $WriteFile $GitClone
        }
    }
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
            $Value = $_.Substring($Index + 2, $_.Length - $Index - 2)
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

Export-ModuleMember -Function Start-BatchUpdate, Get-GitUrl