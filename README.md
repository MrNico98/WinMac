# WinMac: The Ultimate Windows and macOS Hybrid

**WinMac** is a revolutionary modification that brings together the best of both Windows and macOS operating systems, offering users a unique and seamless computing experience.

## Dark

![winmac_dark_01](https://github.com/Asteski/WinMac/blob/main/img/winmac_dark_01.png)

![winmac_dark_02](https://github.com/Asteski/WinMac/blob/main/img/winmac_dark_02.png)

![winmac_dark_03](https://github.com/Asteski/WinMac/blob/main/img/winmac_dark_03.png)

## Light

![winmac_light_01](https://github.com/Asteski/WinMac/blob/main/img/winmac_light_01.jpg)

![winmac_light_02](https://github.com/Asteski/WinMac/blob/main/img/winmac_light_02.jpg)

## Features

- **Spotlight-like quick launcher**

PowerToys brings a macOS Spotlight-like functionality to Windows with PowerToys Run. It allows users to quickly search for files, applications, and settings on your system. 

By pressing a customizable hotkey combination (alt+space by default), a search bar appears, enabling users to type their query and quickly launch or access the desired item without navigating through menus or directories. Besides PowerToys Run, this utility allows for many OS customizations, like *FancyZones, Always On Top, Peek, File Explorer add-ons, Color Picker or Find My Mouse*, improving your workflow in many different ways.

- **Revamped and decluttered Start Menu**

Open-Shell is a customizable Start Menu replacement for Windows that provides users with possiblity to completely replace traditional Start Menu with customized WinX menu, to resemble MacOS main menu.

- **Enhanced Taskbar**

StartAllBack enhances the functionality of the Windows Taskbar by introducing features inspired by earlier versions of Windows, such as Windows 7 and Windows 10. It brings back familiar elements like colored title bars and customizable Start buttons. 

Additionally, StartAllBack offers options for customizing the appearance and behavior of the Taskbar to suit individual user preferences.

- **Enhanced Explorer**

StartAllBack extends its enhancements beyond the Taskbar to the Windows Explorer, providing users with a more streamlined and efficient file browsing experience, by bringing back older versions of Explorer from Windows 7 or Windows 10. 

Utility introduces features such as ribbons, tabs, customizable toolbar buttons, enhanced file previews, and improved navigation options. With StartAllBack and PowerToys, you can personalize your Explorer interface to better suit your workflow and access files and folders more efficiently.

Additionally, deployment script includes pinning User folder and Start Menu\Programs folder to Quick Access.

- **Revamped Terminal**

WinMac provides you with debloated prompt with addition of completion functions and most commonly used commands in macOS/Linux, like *vim, grep, touch, ditto, top, whatis, killall, ll, la, tree* with additional commands like:

- *np* or *note* opens notepad with or without provided file name,
- *open* or *of* to open current or specific directory in Explorer,
- *history* or *hist* to list commands history from current and older sessions,
- *ntop* is a htop-like system-monitor for Windows with Vi-keybindings,
- *backup* as an alias of [wbadmin - Backup command-line tool for Windows](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/wbadmin),
- *rcopy* as an alias of [robocopy - Robust File Copy for Windows](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy),
- *psversion, psver* or *version* to show current Powershell version.

Examples: 

- *open $profile* or *open C:\Users\username\file.txt* opens folder, where specified file is stored
- *open foldername* opens specific folder that is stored in current folder
- *open C:\Users* or *open 'C:\Program Files'* opens specific folder directory
- *open* opens current folder
- *history* shows the list of commands from current and older sessions
- *history wsl* or *history grep winmac* searches through commands history by specific string or set of strings

## Benefits

- **Unified Computing Experience:** WinMac provides a cohesive blend of Windows and macOS elements, ensuring a smooth and efficient workflow for all users.
- **Enhanced Productivity:** Take advantage of the versatility and compatibility of WinMac to maximize productivity across various tasks and applications.
- **Privacy and Security:** Rest assured knowing that your data is protected by the advanced security features as part of Windows 11 Defender Security services.

## Experience WinMac Today!

Discover the future of computing with WinMac, where the power of Windows meets the elegance of macOS in perfect harmony. Upgrade to WinMac and elevate your computing experience to new heights!

Please be informed that this is a beta version - you're deploying it at your own risk!!

## Recommendations

For the most reliable deployment process, I recommend to install latest version of [Powershell Core](https://github.com/PowerShell/PowerShell) and run deployment script from the script directory and run it as an Administrator. Everything else will be deployed automatically for you (including Winget if not already installed).

## Planned features

- Dock - Give a choice between Dock or Taskbar experience before deployment,
- Force Taskbar to go automatically on top upon deployment,
- Win + Q to run Shutdown prompt,
- quicknote and computerinfo functions,
- Create WinMac Control Panel UWP app to manage UI settings.

## Credit

List of utilities and their creators, used with WinMac deployment script:

- [PowerToys](https://learn.microsoft.com/en-us/windows/powertoys/) by Microsoft
- [StartAllBack](https://www.startallback.com/) by Stanislav Zinukhov
- [Open-Shell](https://open-shell.github.io/Open-Shell-Menu/) by Ivo Beltchev
- [Everything](https://www.voidtools.com/) by David Carpenter
- [PSTree](https://github.com/santisq/PSTree) by santisq

Please support creators however you can for their wonderful work!

Keep in mind that StartAllBack is not a free software and requires license to run permanently. Free version will stop working after 100 days.

WinMac is not planned to be used for business/earning purposes. If you're not okay with me using your software by installing it (using Winget) with Powershell deployment script, please let me know!

Enjoy and support my work by giving feedback and contributing to the project!
