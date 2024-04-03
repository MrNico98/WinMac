
Set-PSReadlineKeyHandler -Chord Tab -Function ForwardWord

function prompt {
    $prompt = Write-Prompt "$(Get-Date -f "HH:mm:ss") " -ForegroundColor ([ConsoleColor]::Blue)
    $userName = 'Adams'
    $folder = Split-Path -Leaf $pwd

    if ($folder -eq $env:USERNAME)
    {
        $prompt += Write-Prompt $userName -ForegroundColor ([ConsoleColor]::Magenta)
        $prompt += Write-Prompt ' @' 
        $prompt += Write-Prompt ' ~ ' -ForegroundColor ([ConsoleColor]::Green)
        $prompt += Write-Prompt '>' -ForegroundColor ([ConsoleColor]::Red)
    }
    else
    {
        $prompt += Write-Prompt $userName -ForegroundColor ([ConsoleColor]::Magenta)
        $prompt += Write-Prompt ' @'
        $prompt += Write-Prompt " $folder " -ForegroundColor ([ConsoleColor]::Green)
        $prompt += Write-Prompt '>' -ForegroundColor ([ConsoleColor]::Red)
    }
    
    if ($prompt) { "$prompt " } else { " " }
}

function touch {
    $file = $args[0]
    if($null -eq $file) 
    {
        $file = "touch_" + (Get-Date -Format "yyyy-MM-ddTHHmmss") + ".txt"
        Write-Output $null > $file
        Write-Host "File created: $file" -ForegroundColor Green
    }
    elseif(Test-Path $file)
    {
        Write-Host "File already exists" -ForegroundColor Red
    }
    else
    {
        Write-Output $null > $file
        Write-Host "File created: $file" -ForegroundColor Green
    }
}

function ditto {
    $source = $args[0]
    $destination = $args[1]
    if($null -eq $source -or $null -eq $destination) 
    {
        Write-Host "Source does not exist or destination already exists"  -ForegroundColor Red
    }
    elseif((Test-Path $source) -and -not (Test-Path $destination)) 
    {
        Copy-Item -Path $source -Destination $destination -Recurse
    }
    else 
    {
        Write-Host "Source does not exist or destination already exists" -ForegroundColor Red
    }
}

function top {
    $process = Get-Process | Sort-Object -Property CPU -Descending | Select-Object -First 10
    $process | Format-Table -AutoSize
}

function killall {
    $procName = $args[0]
    $process = Get-Process | Where-Object { $_.ProcessName -eq $procName }
    if ($null -eq $procName -or $null -eq $process) 
    {
        Write-Host "Process is not running or not found" -ForegroundColor Red
    } 
    else 
    {
        $process | Stop-Process -Force
        WRite-Host "Process $procName stopped" -ForegroundColor Green
    }
}

function of {
    param (
        [Parameter(Mandatory=$false, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Path
    )

    if (Test-Path $Path) {
        $fullPath = Get-Item -Path $Path | Select-Object -ExpandProperty FullName
        if ((Test-Path $fullPath) -and (Get-Item $fullPath).PSIsContainer) 
        {
            explorer.exe $fullPath
        }
        else 
        {
            $folderPath = Split-Path -Path $fullPath
            explorer.exe $folderPath
        }
    }
    elseif (-not (Test-Path $Path)) {
        Invoke-Item .
    }
    else
    {
        Write-Host "File or directory does not exist" -ForegroundColor Red
    }
}

function ll { Get-ChildItem -Force }
function la { Get-ChildItem -Force -Attributes !D }

set-alias -name np -value notepad
set-alias -name open -value of
set-alias -name whatis -value man
set-alias -name tree -value PSTree
set-alias -name history -value 'Get-History'
set-alias -name hist -value 'Get-History'

