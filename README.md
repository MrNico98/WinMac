# WinMac: The Ultimate Windows and macOS Hybrid

**WinMac** is a revolutionary modification that brings together the best of both Windows and macOS operating systems, offering users a unique and seamless computing experience.

## Dark:

![winmac_dark_01](https://github.com/Asteski/WinMac/assets/163755955/e857e2b7-97cc-4d70-b3a9-816f03bb6a7d)

## Light:

![winmac_light_01](https://github.com/Asteski/WinMac/assets/163755955/c2be00bb-07f2-46ed-bccd-9456dde5bcc7)

![winmac_light_02](https://github.com/Asteski/WinMac/assets/163755955/7e455ebe-91fd-4fd9-a104-c24e8d4858b4)

## Features:

- **Spotlight-like quick launcher**

PowerToys brings a MacOS Spotlight-like functionality to Windows with PoweToys Run. It allows users to quickly search for files, applications, and settings on your system. 

By pressing a customizable hotkey combination (alt+space by default), a search bar appears, enabling users to type their query and quickly launch or access the desired item without navigating through menus or directories. Besides PowerToys run, this utility allows for many customization, improving your workflow in many different ways.

- **Revamped and decluttered Start Menu**

Open-Shell is a customizable Start Menu replacement for Windows that provides users with possiblity to completely replace traditional Start Menu with customized WinX menu, resembling MacOS main menu.

- **Enhanced Taskbar**

StartAllBack enhances the functionality of the Windows Taskbar by introducing features inspired by earlier versions of Windows, such as Windows 7 and Windows 10. It brings back familiar elements like colored title bars and customizable Start buttons. 

Additionally, StartAllBack offers options for customizing the appearance and behavior of the Taskbar to suit individual user preferences.

- **Enhanced Explorer**

StartAllBack extends its enhancements beyond the Taskbar to the Windows Explorer, providing users with a more streamlined and efficient file browsing experience, by bringing back older versions of Explorer from Windows 7 or Windows 10. 

Utility introduces features such as tabs, customizable toolbar buttons, enhanced file previews, and improved navigation options. With StartAllBack and PowerToys, users can personalize their Explorer interface to better suit their workflow and access files and folders more efficiently.

Additionally, deployment script includes pinning User folder and Programs folder to Quick Access.

- **Revamped Terminal**

*[Not working in current WinMac version]* OhMyPosh is a prompt theme engine for Powershell, enabling you to use the full color set of your terminal by using colors or predefined themes to define and render the prompt. 

WinMac provides you with addition of most commonly used commands in MacOS/Linux, like *touch, ditto, top, whatis, killall, ll, la, tree* with additional commands like:

- *np* which opens notepad with or without provided file name,
- *of* or *open*, which is used to open current Powershell directory in Explorer, or opening folder where specific file resides.

Examples: 

*of $profile* or *open $profile* opens folder, where $profile file resides

*of foldername* or *open foldername* opens specific folder that is placed in current folder

*of folderdir* or *open folderdir* opens specific folder directory

*of* or *open* opens current folder

*tree* lists all subdirectories and their content

*tree --all* or *tree -a* lists all subdirectories and their content including hidden folders and files

## Benefits:

- **Unified Computing Experience:** WinMac provides a cohesive blend of Windows and macOS elements, ensuring a smooth and efficient workflow for all users.
- **Enhanced Productivity:** Take advantage of the versatility and compatibility of WinMac to maximize productivity across various tasks and applications.
- **Privacy and Security:** Rest assured knowing that your data is protected by the advanced security features as part of Windows 11 Security services.

## Experience WinMac Today!

Discover the future of computing with WinMac, where the power of Windows meets the elegance of macOS in perfect harmony. Upgrade to WinMac and elevate your computing experience to new heights!

Please be informed that this is a beta version - you're installing it at your own risk!!

## Recommendation:

For the most reliable deployment process, I recommend to install latest Powershell Core and run deployment script from the script directory and run is as an administrator. Everything else will be deployed automatically for you (including Winget if not already installed).

## Planned features:

- Create WinMac Control Panel UWP app to manage UI settings
- Force Taskbar to go automatically on top upon deployment
- Hide Windows Terminal options from Start Menu
- Deploy OhMyPosh configuration for Powershell
- Improve *tree* output and parameters
- Add option to close taskbar tasks with middle mouse button
- Replace Programs directory with Applications Shell object to show all installed apps, instead of a shortcut to Start Menu programs folder

## Credit:

List of utilities used with WinMac deployment script:

- Microsoft: [PowerToys](https://learn.microsoft.com/en-us/windows/powertoys/)

- Stanislav Zinukhov: [StartAllBack](https://www.startallback.com/)

- Ivo Beltchev: [Open-Shell](https://open-shell.github.io/Open-Shell-Menu/)

- Jan Doebbler: [OhMyPosh](https://ohmyposh.dev/)

Please support creators however you can for their wonderful work!

Keep in mind that StartAllBack is not a free software and requires license to run permanently. Free version will stop working after 100 days.

WinMac is not planned to be used for business/earning purposes. If you're not okay with me installing your software with WinMac deployment script, please let me know!

Enjoy!
