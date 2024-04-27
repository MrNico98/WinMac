Write-Host "Configuring Nexus Dock..." -ForegroundColor Yellow

$downloadUrl = "https://www.winstep.net/nexus.zip"
$downloadPath = "dock.zip"
if (-not (Test-Path $downloadPath)) {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadPath
}
Expand-Archive -Path $downloadPath -DestinationPath $pwd -Force
Start-Process -FilePath ".\NexusSetup.exe" -ArgumentList "/silent"
start-sleep 60
Stop-Process -n Nexus
Remove-Item .\dock.zip -Force
Remove-Item .\ReadMe.txt -Force
Remove-Item .\NexusSetup.exe -Force
$winStep = 'C:\Users\Public\Documents\WinStep'
Remove-Item -Path "$winStep\Themes\*" -Recurse -Force
Copy-Item -Path "config\dock\themes\*" -Destination "$winStep\Themes\" -Recurse -Force
Remove-Item -Path "$winStep\NeXus\Indicators\*" -Force -Recurse
Copy-Item -Path "config\dock\indicators\*" -Destination "$winStep\NeXus\Indicators\" -Recurse -Force
#TODO explorer tasmgr controlpanel terminal downloads recyclebin settings
New-Item -ItemType Directory -Path "$winStep\Icons" -Force | Out-Null
Copy-Item config\dock\icons "$winStep" -Recurse -Force | Out-Null


$roundedOrSquared = Read-Host "Enter 'R' for rounded dock or 'S' for squared dock"
if ($roundedOrSquared -eq "R" -or $roundedOrSquared -eq "r") {
    Write-Host "Setting rounded dock..." -ForegroundColor Yellow
    $regFile = "$pwd\config\dock\winstepR.reg"
} elseif ($roundedOrSquared -eq "S" -or $roundedOrSquared -eq "s") {
    Write-Host "Setting squared dock..." -ForegroundColor Yellow
    $regFile = "$pwd\config\dock\winstepS.reg"
} else {
    Write-Host "Invalid input. Defaulting to rounded dock." -ForegroundColor Yellow
    $regFile = "$pwd\config\dock\winstepR.reg"
}

reg import $regFile

Start-Sleep 2
Start-Process 'C:\Program Files (x86)\Winstep\Nexus.exe' | Out-Null
Remove-Item "C:\Users\$env:USERNAME\Desktop\Nexus.lnk" -Force -ErrorAction SilentlyContinue | Out-Null
Remove-Item "C:\Users\$env:USERNAME\OneDrive\Desktop\Nexus.lnk" -Force -ErrorAction SilentlyContinue | Out-Null

Write-Host "Configuring Nexus Dock completed." -ForegroundColor Green

Write-Host
Write-Host "------------------------ WinMac Deployment completed ------------------------" -ForegroundColor Cyan
Write-Host @"

Enjoy and support by giving feedback and contributing to the project!

For more information please visit my GitHub page: github.com/Asteski/WinMac

If you have any questions or suggestions, please contact me on GitHub.

"@ -ForegroundColor Green

Write-Host "-----------------------------------------------------------------------------"  -ForegroundColor Cyan
Write-Host
$restartConfirmation = Read-Host "Restart computer now? It's recommended to fully apply all the changes. (y/n)"
if ($restartConfirmation -eq "Y" -or $restartConfirmation -eq "y") {
    Write-Host "Restarting computer in" -ForegroundColor Red
    for ($a=9; $a -ge 0; $a--) {
        Write-Host -NoNewLine "`b$a" -ForegroundColor Red
        Start-Sleep 1
    }
    Restart-Computer -Force
} else {
    Write-Host "Computer will not be restarted." -ForegroundColor Green
}




# $regEntries = @"
# "BitmapsFolder"="C:\\Users\\Public\\Documents\\WinStep\\Themes\\WinMac Light Opaque Squared\\"
# "GlobalBitmapFolder"="C:\\Users\\Public\\Documents\\WinStep\\Themes\\WinMac Light Opaque Squared\\"
# "NeXuSBitmapFolder"="C:\\Users\\Public\\Documents\\WinStep\\Themes\\WinMac Light Opaque Squared\\"
# "NeXuSImage3"="C:\\Users\\Public\\Documents\\WinStep\\Themes\\WinMac Light Opaque Squared\\NxBack.png"
# "ClockVoiceFolder"="C:\\Users\\Public\\Documents\\WinStep\\Themes\\Female Voice\\"
# "ClockSoundFolder"="C:\\Users\\Public\\Documents\\WinStep\\Themes\\WinstepSamples\\"
# "ClockBitmapFolder"="C:\\Users\\Public\\Documents\\WinStep\\Themes\\WinMac Light Opaque Squared\\"
# "TrashBitmapFolder"="C:\\Users\\Public\\Documents\\WinStep\\Themes\\WinMac Light Opaque Squared\\"
# "CPUBitmapFolder"="C:\\Users\\Public\\Documents\\WinStep\\Themes\\WinMac Light Opaque Squared\\"
# "POP3BitmapFolder"="C:\\Users\\Public\\Documents\\WinStep\\Themes\\WinMac Light Opaque Squared\\"
# "METARBitmapFolder"="C:\\Users\\Public\\Documents\\WinStep\\Themes\\WinMac Light Opaque Squared\\"
# "@

# $regEntries | ForEach-Object {
#     $key = $_.Split("=")[0].Trim()
#     $value = $_.Split("=")[1].Trim()
#     Set-ItemProperty -Path "HKCU:\Software\WinSTEP2000\NeXuS" -Name $key -Value $value
# }

# Set-ItemProperty -Path "HKCU:\Software\WinSTEP2000\NeXuS\Docks" -Name "DockBitmapFolder1" -Value "C:\\Users\\Public\\Documents\\WinStep\\Themes\\WinMac Light Opaque Squared\\"
# Set-ItemProperty -Path "HKCU:\Software\WinSTEP2000\NeXuS\Docks" -Name "DockBack3Image1" -Value "C:\\Users\\Public\\Documents\\WinStep\\Themes\\WinMac Light Opaque Squared\\NxBack.png"

# Set-ItemProperty -Path "HKCU:\Software\WinSTEP2000\NeXuS\Shared" -Name "IconBrowserPath" -Value "C:\\Users\\Adams\\OneDrive\\Utilities\\icons\\System App Icons\\Windows System\\SEO\\Explorer\\"
# Set-ItemProperty -Path "HKCU:\Software\WinSTEP2000\NeXuS\Shared" -Name "BackupPath" -Value "C:\\Users\\Adams\\OneDrive\\Utilities\\Nexus Dock\\"
# Set-ItemProperty -Path "HKCU:\Software\WinSTEP2000\NeXuS\Shared" -Name "TaskIcon1" -Value "C:\\Users\\Adams\\OneDrive\\Utilities\\icons\\System App Icons\\Windows System\\SEO\\Explorer\\Settings.ico"

