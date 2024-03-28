#################################################################################
#                                                                               #
#                                                                               #
#                           WinMac deployment script                            #
#                                                                               #
#                               Version: 0.0.9                                  #
#                           Author: Adam Kamienski                              #
#                               GitHub: Asteski                                 #
#                                                                               #
#                                                                               #
#################################################################################

# TODO:
# !! Force Taskbar to go on top in StartAllBack
# ! Modify desktop.ini Programs and User folder to change icon
# ! Add winget plugin to PowerToys
# TODO: shift+righ-click to open Run, win+shift to open Shutdown
# TODO: hide righ-click OSH menu
# TODO: winget plugin to PowerToys
# TODO: hide Windows Terminal from Start Menu
# * Update $profile
# * Configure Terminal with Pwsh, Bash and Zsh and apply OhMyPosh and OhMyZsh
# * Create WinMac Control Panel UWP app:
#   * Add setting to modify middle-mouse button behaviour on taskbar (close app, open new window)
#   * Add setting to modify Start Menu options
#   * Taskbar Position (top, bottom, left, right)
#   * Taskbar Alignment (left, center, start button on left with app icons centered)
#   * Taskbar Size (small, medium, large)
#   * Taskbar Transparency (dynamic, static, off)
#   * Explorer Mode (modern - Win11 mode, classic - Win7 mode)
#   * Explorer Status Bar (on, off)
# ? Gestures in Explorer
# Disable Classic Explorer Bar & Icons
# Disable Status Bar (in both Open-Shell and StartAllBack)
# Disable ClassicExplorer toolbar using keyboard input from install.ps1 script (Alt + V, →, Enter)
# Modify Start menu/Win key actions to emulate MacOS behaviour

# Clear-Host
Write-Host @"

------------------------ WinMac Deployment ------------------------ 

Welcome to WinMac Deployment!

Author: Adam Kamienski
GitHub: Asteski
Version: 0.0.9

This is Work in Progress.

"@ -ForegroundColor Cyan

## WinGet

Write-Host "Checking for Windows Package Manager (WinGet)" -ForegroundColor Yellow

$progressPreference = 'silentlyContinue'
Write-Information "Downloading WinGet and its dependencies..."
$wingetUrl = "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
$installPath = "$env:TEMP\winget.msixbundle"
Invoke-WebRequest -Uri $wingetUrl -OutFile $installPath
Write-Information "Installing WinGet..."
Add-AppxPackage -Path $installPath
Remove-Item -Path $installPath
Write-Information "WinGet installation completed."
Write-Host "Installing Packages:"
$winget = @(
# "RamenSoftware.7+TaskbarTweaker", # Manage middle-mouse click on taskbar
"Armin2208.WindowsAutoNightMode",
"JanDeDobbeleer.OhMyPosh",
"Microsoft.PowerToys",
"Voidtools.Everything",
"lin-ycv.EverythingPowerToys"
)
foreach ($app in $winget) {winget install --id $app --no-upgrade --silent}
Write-Host "Installing Packages completed." -ForegroundColor Green

# PowerToys

Write-Host "Configuring PowerToys..." -ForegroundColor Yellow

$plugins1 = $env:LOCALAPPDATA + '\Microsoft\PowerToys\'
$plugins2 = "C:\Program Files\PowerToys"
$winget = 'https://github.com/bostrot/PowerToysRunPluginWinget/releases/download/v1.2.3/winget-powertoys-1.2.3.zip'
$prockill = 'https://github.com/8LWXpg/PowerToysRun-ProcessKiller/releases/download/v1.0.1/ProcessKiller-v1.0.1-x64.zip'
Invoke-WebRequest -uri $winget -Method "GET" -Outfile 'winget.zip'
Invoke-WebRequest -uri $prockill -Method "GET" -Outfile 'prockill.zip'
Expand-Archive 'winget.zip' -DestinationPath $pwd\Winget -Force
Expand-Archive 'prockill.zip' -DestinationPath $pwd -Force
Copy-item $pwd\Winget -Destination "$($plugins1)\RunPlugins\" -Recurse -Force
Copy-item $pwd\ProcessKiller -Destination "$($plugins1)\Plugins\" -Recurse -Force
Copy-item $pwd\Winget -Destination "$($plugins2)\Plugins\" -Recurse -Force
Copy-item $pwd\ProcessKiller -Destination "$($plugins2)\Plugins\" -Recurse -Force
Remove-Item -Recurse -Force Winget
Remove-Item -Recurse -Force ProcessKiller
Get-ChildItem * -Include *.zip -Recurse | Remove-Item -Force
$PowerToysProc = Get-Process -Name PowerToys*
ForEach ($proc in $PowerToysProc) {
    $proc.WaitForExit(10000)
    $proc.Kill()
}
Start-Sleep -Seconds 5
Start-Process -FilePath "C:\Program Files\PowerToys\PowerToys.exe" # -ArgumentList "--settings-folder $($plugins)\settings --no-admin --no-startup" -Wait

Write-Host "Configuring PowerToys completed." -ForegroundColor Green

## StartAllBack

Write-Host "Configuring StartAllBack..." -ForegroundColor Yellow

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Taskbar {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
}
"@
$taskbarHandle = [Taskbar]::FindWindow("Shell_TrayWnd", "")
$HWND_TOP = [IntPtr]::Zero
$SWP_SHOWWINDOW = 0x0040
[Taskbar]::SetWindowPos($taskbarHandle, $HWND_TOP, 0, 0, 0, 0, $SWP_SHOWWINDOW) | Out-Null
winget install --id "StartIsBack.StartAllBack" --silent --no-upgrade | Out-Null

$sabRegPath = "HKCU:\Software\StartIsBack"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{645FF040-5081-101B-9F08-00AA002F954E}" -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowStatusBar" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "EnableSnapAssistFlyout" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "EnableSnapBar" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons" -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSi" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "UseCompactMode" -Value 1
Set-ItemProperty -Path $sabRegPath -Name "WinBuild" -Value 22759
Set-ItemProperty -Path $sabRegPath -Name "WinLangID" -Value 2064
Set-ItemProperty -Path $sabRegPath -Name "ModernIconsColorized" -Value 0
Set-ItemProperty -Path $sabRegPath -Name "SettingsVersion" -Value 5
Set-ItemProperty -Path $sabRegPath -Name "WelcomeShown" -Value 3
Set-ItemProperty -Path $sabRegPath -Name "UpdateCheck" -Value ([byte[]](160, 224, 8, 201, 49, 125, 218, 1))
Set-ItemProperty -Path $sabRegPath -Name "FrameStyle" -Value 2
Set-ItemProperty -Path $sabRegPath -Name "WinkeyFunction" -Value 1
Set-ItemProperty -Path $sabRegPath -Name "TaskbarOneSegment" -Value 0
Set-ItemProperty -Path $sabRegPath -Name "TaskbarCenterIcons" -Value 1
Set-ItemProperty -Path $sabRegPath -Name "TaskbarTranslucentEffect" -Value 0
Set-ItemProperty -Path $sabRegPath -Name "TaskbarLargerIcons" -Value 0
Set-ItemProperty -Path $sabRegPath -Name "TaskbarSpacierIcons" -Value (-1)
Set-ItemProperty -Path $sabRegPath -Name "UpdateInfo" -Value ([byte[]](60, 63, 120, 109, 108, 32, 118, 101, 114, 115, 105, 111, 110, 61, 34, 49, 46, 48, 34, 63, 62, 10, 60, 85, 112, 100, 97, 116, 101, 32, 78, 97, 109, 101, 61, 34, 83, 116, 97, 114, 116, 65, 108, 108, 66, 97, 99, 107, 32, 51, 46, 55, 46, 55, 34, 32, 68, 101, 115, 99, 114, 105, 112, 116, 105, 111, 110, 61, 34, 34, 32, 68, 111, 119, 110, 108, 111, 97, 100, 85, 82, 76, 61, 34, 104, 116, 116, 112, 115, 58, 47, 47, 115, 116, 97, 114, 116, 105, 115, 98, 97, 99, 107, 46, 115, 102, 111, 51, 46, 99, 100, 110, 46, 100, 105, 103, 105, 116, 97, 108, 111, 99, 101, 97, 110, 115, 112, 97, 99, 101, 115, 46, 99, 111, 109, 47, 83, 116, 97, 114, 116, 65, 108, 108, 66, 97, 99, 107, 95, 51, 46, 55, 46, 55, 95, 115, 101, 116, 117, 112, 46, 101, 120, 101, 34, 32, 76, 101, 97, 114, 110, 77, 111, 114, 101, 85, 82, 76, 61, 34, 104, 116, 116, 112, 115, 58, 47, 47, 119, 119, 119, 46, 115, 116, 97, 114, 116, 97, 108, 108, 98, 97, 99, 107, 46, 99, 111, 109, 47, 34, 47, 62, 10))
Set-ItemProperty -Path $sabRegPath -Name "UpdateInfoHash" -Value 805441044
Set-ItemProperty -Path $sabRegPath -Name "SysTrayActionCenter" -Value 0
Set-ItemProperty -Path $sabRegPath -Name "TaskbarControlCenter" -Value 1
Set-ItemProperty -Path $sabRegPath -Name "SysTrayStyle" -Value 1
Set-ItemProperty -Path $sabRegPath\DarkMagic -Name "(default)" -Value "1"
Set-ItemProperty -Path $sabRegPath\DarkMagic -Name "Unround" -Value 0
Set-ItemProperty -Path $sabRegPath\DarkMagic -Name "DarkMode" -Value 1

Stop-Process -Name Explorer -Force

Write-Host "Configuring StartAllBack completed." -ForegroundColor Green

## Shell & Explorer tweeks

Write-Host "Configuring Shell..." -ForegroundColor Yellow

Remove-Item -Path "C:\Users\Public\Desktop\Everything.lnk" -Force | Out-Null
$shellRegPath = "Registry::HKEY_CURRENT_USER\Software\OpenShell"
$shellExePath = Join-Path $env:PROGRAMFILES "Open-Shell\startmenu.exe"

$homeDir = "C:\Users\$env:USERNAME"
$homeIniFilePath = "$($homeDir)\desktop.ini"
$homeIcon = @"
[.ShellClassInfo]
IconResource=C:\Windows\System32\SHELL32.dll,160
"@
$programsDir = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs"
$programsIniFilePath = "$($programsDir)\desktop.ini"
$programsIcon = @"
[.ShellClassInfo]
IconResource=C:\WINDOWS\System32\imageres.dll,187
"@

if (Test-Path -Path $homeIniFilePath) {
    $homeIni = Get-Content $homeIniFilePath -Raw
    if ($homeIni -match 'Icon') {
        $homeIni -replace '(Icon.*)', 'IconResource=C:\Windows\System32\SHELL32.dll,160' | Set-Content $homeIniFilePath
    }
    else {
        $homeIni + "`n$homeIcon" | Set-Content $homeIniFilePath   
    }
} else {
    New-Item -Path $homeIniFilePath -ItemType File -Force
    Set-ItemProperty -Path $homeIniFilePath -Name "Attributes" -Value ([System.IO.FileAttributes]::Hidden)
    $homeIni + "`n$homeIcon" | Set-Content $homeIniFilePath 
    # Set-ItemProperty -Path $programsIniFilePath -Name "Attributes" -Value ([System.IO.FileAttributes]::ReadOnly)
}

$homePin = new-object -com shell.application
$homePin.Namespace($homeDir).Self.InvokeVerb("pintohome")

if (Test-Path -Path $programsIniFilePath) {
    $programsIni = Get-Content $programsIniFilePath -Raw
    if ($programsIni -match 'Icon') {
        Remove-ItemProperty -Path $programsIniFilePath -Name "Attributes" -Value ([System.IO.FileAttributes]::ReadOnly)
        $programsIni -replace '(Icon.*)', 'IconResource=C:\Windows\System32\SHELL32.dll,160' | Set-Content $programsIniFilePath
        Set-ItemProperty -Path $programsIniFilePath -Name "Attributes" -Value ([System.IO.FileAttributes]::ReadOnly)
    }
    else {
        Remove-ItemProperty -Path $programsIniFilePath -Name "Attributes" -Value ([System.IO.FileAttributes]::ReadOnly)
        $programsIni + "`n$programsIcon" | Set-Content $programsIniFilePath
        Set-ItemProperty -Path $programsIniFilePath -Name "Attributes" -Value ([System.IO.FileAttributes]::ReadOnly)
    }
} else {
    New-Item -Path $programsIniFilePath -ItemType File -Force
    Set-ItemProperty -Path $programsIniFilePath -Name "Attributes" -Value ([System.IO.FileAttributes]::Hidden)
    $programsIni + "`n$programsIcon" | Set-Content $programsIniFilePath
    Set-ItemProperty -Path $programsIniFilePath -Name "Attributes" -Value ([System.IO.FileAttributes]::ReadOnly)
}

$programsPin = new-object -com shell.application
$programsPin.Namespace($programsDir).Self.InvokeVerb("pintohome")

#!
#! FIXME: Could not find item/attribute
#!

New-Item -Path 'C:\' -Name 'QuickAccessObjects' -ItemType Directory -Force
New-Item -Path 'C:\QuickAccessObjects' -Name 'Recycle Bin.{645FF040-5081-101B-9F08-00AA002F954E}' -ItemType Directory
(Get-Item -Path 'C:\QuickAccessObjects').attributes = 'Hidden' # ! could not find item/attribute
($TargetShellObject = (Get-ChildItem -Path 'C:\QuickAccessObjects' -Filter 'Recycle*').FullName)
$Shell = New-Object -ComObject Shell.Application
$Shell.Namespace(("$TargetShellObject").Self.InvokeVerb("PinToHome")) # ! error null output value?

Copy-Item -Path "$pwd\config\blank.ico" -Destination "C:\Windows" -Force | Out-Null
New-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" -Name "29" -Value "C:\Windows\blank.ico" -Type String

winget install --id "Open-Shell.Open-Shell-Menu" --no-upgrade | Out-Null
Start-Sleep -Seconds 5

New-Item -Path "Registry::HKEY_CURRENT_USER\Software\OpenShell" -Force | Out-Null
New-Item -Path "Registry::HKEY_CURRENT_USER\Software\OpenShell\OpenShell" -Force | Out-Null
New-Item -Path "Registry::HKEY_CURRENT_USER\Software\OpenShell\StartMenu" -Force | Out-Null
New-Item -Path "Registry::HKEY_CURRENT_USER\Software\OpenShell\ClassicExplorer" -Force | Out-Null
New-Item -Path "Registry::HKEY_CURRENT_USER\Software\OpenShell\OpenShell\Settings" -Force | Out-Null
New-Item -Path "Registry::HKEY_CURRENT_USER\Software\OpenShell\StartMenu\Settings" -Force | Out-Null
New-Item -Path "Registry::HKEY_CURRENT_USER\Software\OpenShell\ClassicExplorer\Settings" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\Software\OpenShell\ClassicExplorer" -Name "ShowedToolbar" -Value 0
Set-ItemProperty -Path "HKCU:\Software\OpenShell\ClassicExplorer" -Name "NewLine" -Value 0
Set-ItemProperty -Path "HKCU:\Software\OpenShell\ClassicExplorer" -Name "CSettingsDlg" -Value ([byte[]](0,0,0,0,103,0,0,0,0,0,0,0,0,0,0,0,170,15,0,0,1,0,185,115,0,0,0,0))
Set-ItemProperty -Path "HKCU:\Software\OpenShell\ClassicExplorer\Settings" -Name "Version" -Value 10741631
Set-ItemProperty -Path "HKCU:\Software\OpenShell\ClassicExplorer\Settings" -Name "ShowStatusBar" -Value 0
Set-ItemProperty -Path "HKCU:\Software\OpenShell\ClassicExplorer\Settings" -Name "TreeStyle" -Value "Vista"
Set-ItemProperty -Path "HKCU:\Software\OpenShell\ClassicExplorer\Settings" -Name "HScrollbar" -Value "Default"
Set-ItemProperty -Path "HKCU:\Software\OpenShell\ClassicExplorer\Settings" -Name "NoFadeButtons" -Value 1  | Out-Null
Set-ItemProperty -Path "HKCU:\Software\OpenShell\ClassicExplorer\Settings" -Name "HideSearch" -Value 0
Set-ItemProperty -Path "HKCU:\Software\OpenShell\ClassicExplorer\Settings" -Name "UseBigButtons" -Value 0
Set-ItemProperty -Path "HKCU:\Software\OpenShell\ClassicExplorer\Settings" -Name "AltEnter" -Value 0
Set-ItemProperty -Path "HKCU:\Software\OpenShell\ClassicExplorer\Settings" -Name "DisableBreadcrumbs" -Value 0
Set-ItemProperty -Path "HKCU:\Software\OpenShell\OpenShell" -Name "LastUpdateTime" -Value 0x161cde38
Set-ItemProperty -Path "HKCU:\Software\OpenShell\OpenShell\Settings" -Name "Nightly" -Value 0x00000001
Set-ItemProperty -Path "HKCU:\Software\OpenShell\StartMenu" -Name "ShowedStyle2" -Value 0x00000000
Set-ItemProperty -Path "HKCU:\Software\OpenShell\StartMenu" -Name "CSettingsDlg" -Value ([byte[]](0xaf, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xe4, 0x02, 0x00, 0x00, 0xb4, 0x00, 0x00, 0x00, 0xd7, 0x0b, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00))
Set-ItemProperty -Path "HKCU:\Software\OpenShell\StartMenu\Settings" -Name "Version" -Value 0x040400bf
Set-ItemProperty -Path "HKCU:\Software\OpenShell\StartMenu\Settings" -Name "DisablePinExt" -Value 1
Set-ItemProperty -Path "HKCU:\Software\OpenShell\StartMenu\Settings" -Name "EnableContextMenu" -Value 0
Set-ItemProperty -Path "HKCU:\Software\OpenShell\StartMenu\Settings" -Name "MouseClick" -Value "Command"
Set-ItemProperty -Path "HKCU:\Software\OpenShell\StartMenu\Settings" -Name "ShiftClick" -Value "Command"
Set-ItemProperty -Path "HKCU:\Software\OpenShell\StartMenu\Settings" -Name "WinKey" -Value "Command"
Set-ItemProperty -Path "HKCU:\Software\OpenShell\StartMenu\Settings" -Name "MouseClickCommand" -Value "$pwd\bin\start.exe"
Set-ItemProperty -Path "HKCU:\Software\OpenShell\StartMenu\Settings" -Name "ShiftClickCommand" -Value "$pwd\bin\power.exe"
Set-ItemProperty -Path "HKCU:\Software\OpenShell\StartMenu\Settings" -Name "WinKeyCommand" -Value "$pwd\bin\start.exe"
Set-ItemProperty -Path "HKCU:\Software\OpenShell\StartMenu\Settings" -Name "ShiftWin" -Value "Nothing"
Set-ItemProperty -Path "HKCU:\Software\OpenShell\StartMenu\Settings" -Name "SearchBox" -Value "Hide"
Set-ItemProperty -Path "HKCU:\Software\OpenShell\StartMenu\Settings" -Name "SkinW7" -Value "Immersive"
Set-ItemProperty -Path "HKCU:\Software\OpenShell\StartMenu\Settings" -Name "SkinVariationW7" -Value ""
Set-ItemProperty -Path "HKCU:\Software\OpenShell\StartMenu\Settings" -Name "SkinOptionsW7" -Value ([byte[]](0x4c, 0x00, 0x49, 0x00, 0x47, 0x00, 0x48, 0x00, 0x54, 0x00, 0x3d, 0x00, 0x30, 0x00, 0x00, 0x00, 0x44, 0x00, 0x41, 0x00, 0x52, 0x00, 0x4b, 0x00, 0x3d, 0x00, 0x30, 0x00, 0x00, 0x00, 0x41, 0x00, 0x55, 0x00, 0x54, 0x00, 0x4f, 0x00, 0x3d, 0x00, 0x31, 0x00, 0x00, 0x00, 0x55, 0x00, 0x53, 0x00, 0x45, 0x00, 0x52, 0x00, 0x5f, 0x00, 0x49, 0x00, 0x4d, 0x00, 0x41, 0x00, 0x47, 0x00, 0x45, 0x00, 0x3d, 0x00, 0x30, 0x00, 0x00, 0x00, 0x55, 0x00, 0x53, 0x00, 0x45, 0x00, 0x52, 0x00, 0x5f, 0x00, 0x4e, 0x00, 0x41, 0x00, 0x4d, 0x00, 0x45, 0x00, 0x3d, 0x00, 0x30, 0x00, 0x00, 0x00, 0x43, 0x00, 0x45, 0x00, 0x4e, 0x00, 0x54, 0x00, 0x45, 0x00, 0x52, 0x00, 0x5f, 0x00, 0x4e, 0x00, 0x41, 0x00, 0x4d, 0x00, 0x45, 0x00, 0x3d, 0x00, 0x30, 0x00, 0x00, 0x00, 0x53, 0x00, 0x4d, 0x00, 0x41, 0x00, 0x4c, 0x00, 0x4c, 0x00, 0x5f, 0x00, 0x49, 0x00, 0x43, 0x00, 0x4f, 0x00, 0x4e, 0x00, 0x53, 0x00, 0x3d, 0x00, 0x30, 0x00, 0x00, 0x00, 0x4f, 0x00, 0x50, 0x00, 0x41, 0x00, 0x51, 0x00, 0x55, 0x00, 0x45, 0x00, 0x3d, 0x00, 0x30, 0x00, 0x00, 0x00, 0x44, 0x00, 0x49, 0x00, 0x53, 0x00, 0x41, 0x00, 0x42, 0x00, 0x4c, 0x00, 0x45, 0x00, 0x5f, 0x00, 0x4d, 0x00, 0x41, 0x00, 0x53, 0x00, 0x4b, 0x00, 0x3d, 0x00, 0x30, 0x00, 0x00, 0x00, 0x42, 0x00, 0x4c, 0x00, 0x41, 0x00, 0x43, 0x00, 0x4b, 0x00, 0x5f, 0x00, 0x54, 0x00, 0x45, 0x00, 0x58, 0x00, 0x54, 0x00, 0x3d, 0x00, 0x30, 0x00, 0x00, 0x00, 0x42, 0x00, 0x4c, 0x00, 0x41, 0x00, 0x43, 0x00, 0x4b, 0x00, 0x5f, 0x00, 0x46, 0x00, 0x52, 0x00, 0x41, 0x00, 0x4d, 0x00, 0x45, 0x00, 0x53, 0x00, 0x3d, 0x00, 0x30, 0x00, 0x00, 0x00, 0x54, 0x00, 0x52, 0x00, 0x41, 0x00, 0x4e, 0x00, 0x53, 0x00, 0x50, 0x00, 0x41, 0x00, 0x52, 0x00, 0x45, 0x00, 0x4e, 0x00, 0x54, 0x00, 0x5f, 0x00, 0x4c, 0x00, 0x45, 0x00, 0x53, 0x00, 0x53, 0x00, 0x3d, 0x00, 0x30, 0x00, 0x00, 0x00, 0x54, 0x00, 0x52, 0x00, 0x41, 0x00, 0x4e, 0x00, 0x53, 0x00, 0x50, 0x00, 0x41, 0x00, 0x52, 0x00, 0x45, 0x00, 0x4e, 0x00, 0x54, 0x00, 0x5f, 0x00, 0x4d, 0x00, 0x4f, 0x00, 0x52, 0x00, 0x45, 0x00, 0x3d, 0x00, 0x31, 0x00, 0x00, 0x00))
Stop-Process -Name startmenu -Force
Start-Process Explorer
Start-Sleep -Seconds 5
Start-Process $shellExePath
$winexePath = Join-Path $pwd\bin "menu.exe"
$process = Start-Process -FilePath $winexePath -WindowStyle Minimized -PassThru
Start-Sleep -Seconds 3
$process.CloseMainWindow() | Out-Null
$process.WaitForExit() | Out-Null
taskkill /IM explorer.exe /F | Out-Null
Start-Sleep -Seconds 2
Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\WinX" -Recurse -Force
Copy-Item -Path "$pwd\config\WinX\" -Destination "$env:LOCALAPPDATA\Microsoft\Windows\" -Recurse -Force
Start-Process explorer
Start-Sleep -Seconds 3
Start-Process explorer # starts explore windows necessary to turn off classic explorer
Start-Sleep -Seconds 3

Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;

    public class Keyboard {
        [DllImport("user32.dll", SetLastError = true)]
        public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

        [DllImport("user32.dll")]
        public static extern bool SetForegroundWindow(IntPtr hWnd);

        [DllImport("user32.dll", SetLastError = true)]
        public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, int dwExtraInfo);
    }
"@
$explorerHandle = [Keyboard]::FindWindow("CabinetWClass", $null)
[Keyboard]::SetForegroundWindow($explorerHandle)
$KEYEVENTF_KEYUP = 0x2
$VK_MENU = 0x12 # Alt key
$VK_V = 0x56 # V key
$VK_RETURN = 0x0D # Enter key
$VK_F4 = 0x73 # F4 key
[Keyboard]::keybd_event($VK_MENU, 0, 0, 0) # Alt key press
[Keyboard]::keybd_event($VK_V, 0, 0, 0) # V key press
[Keyboard]::keybd_event($VK_V, 0, $KEYEVENTF_KEYUP, 0) # V key release
[Keyboard]::keybd_event($VK_MENU, 0, $KEYEVENTF_KEYUP, 0) # Alt key release
Start-Sleep -Milliseconds 100
[Keyboard]::keybd_event($VK_RETURN, 0, 0, 0) # Enter key press
[Keyboard]::keybd_event($VK_RETURN, 0, $KEYEVENTF_KEYUP, 0) # Enter key release
Start-Sleep -Milliseconds 100
[Keyboard]::keybd_event($VK_RETURN, 0, 0, 0) # Enter key press
[Keyboard]::keybd_event($VK_RETURN, 0, $KEYEVENTF_KEYUP, 0) # Enter key release
Start-Sleep -Milliseconds 100

## ! FIXME: Define ps subfolder in the project and use it to copy the function to the profile
# function WinMac {    
#     $sab = (winget show --id StartIsBack.StartAllBack | Select-String -Pattern "Version").ToString().Split(":")[1].Trim()
#     $pt = (winget show --id Microsoft.PowerToys | Select-String -Pattern "Version").ToString().Split(":")[1].Trim()
#     $ev = (winget show --id Voidtools.Everything | Select-String -Pattern "Version").ToString().Split(":")[1].Trim()
#     $output = @{
#         'Version' = $version
#         'StartAllBackVersion' = $sab
#         'PowerToysVersion' = $pt
#         'EverythingVersion' = $ev
#     }
#     return $output
# }
# $funcContent = Get-Content -Path $funcPath -Raw
# $filePath = Split-Path -Path $profile -Parent
# $profilePath = Split-Path -Path $filePath -Parent
# $fileName = Split-Path -Path $profile -Leaf
# if (-not (Test-Path -Path $profile)){
#     New-Item -Path $profilePath -Name 'WindowsPowershell' -ItemType Directory
#     New-Item -Path $filePath -Name $fileName -ItemType File
# }
# Add-Content -Path $profile -Value `n$funcContent

Write-Host "Configuring Shell completed." -ForegroundColor Green

Write-Host "Clean up..."
# TODO: cleanup?
Write-Host "Clean up completed."

Write-Host @"
------------------------ WinMac Deployment completed ------------------------

Enjoy and support work in progress by giving feedback and contributing to the project!

WinMac function have been added to PowerShell profile. 
Use 'winmac' command to get the version of WinMac.

"@ -ForegroundColor Cyan

Start-Sleep 1
Write-Host "This is Work in Progress. Use at your own risk!" -ForegroundColor Magenta

# ! Restart Computer after deployment - Recommened for full effect
# Start-Sleep 2
# Write-Host "Windows will re start in:" -ForegroundColor Red
# for ($i = 10; $i -ge 1; $i--) {
#     Write-Host $i -ForegroundColor Red
#     Start-Sleep 1
# }
# Restart-Computer -Force
# EOF