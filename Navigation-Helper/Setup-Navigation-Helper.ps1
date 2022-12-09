<#
.DESCRIPTION
Script to setup my nav helper

.EXAMPLE
PS> .\Setup-Navigation-Helper -alias goto
#>

param(
    #Specify the alias to reference the command.
    [string]$alias
)

#Requires -RunAsAdministrator

$ErrorActionPreference = 'Stop'

# Check if the user has provided a value for the 'alias' param and, if not, prompt the user to input a value
while ([string]::IsNullOrWhiteSpace($alias)) {

    $alias = Read-Host -Prompt "Input alias to be used (e.g. 'goto')"
}

# Resolve the current path where the scripts are stored
$currentPath = Resolve-Path -Path $PSScriptRoot

# Get the system home directory (i.e. C:\Users\[user]\)
$homePath = Resolve-Path -Path ~

# Get the directory for the PowerShell profile script
$psProfileDir = Split-Path $profile

# Check for existing config file
if (Test-Path -Path $currentPath\config.json -PathType Leaf) {

    Write-Warning ("Config file already exists!")

    $continue = $false
    while (-not $continue) {

        $response = Read-Host -Prompt "Do you wish to overwrite the existing file? (y\n)"

        switch ($response) {

            { "y", "Y" -eq $_ } {
                $continue = $true
                Break
            }

            { "n", "N" -eq $_ } {
                Write-Host "Quitting setup"
                exit
            }

            Default {
                Write-Warning "Invalid input!"
                $continue = $false
                Break
            }
        }
    }
}
else {
    Write-Host "Config file does not exist. Creating new file."
}

$paths = @()
$key = ""
$dir = ""

# Setup initial config
for ($i = 0; $i -le 2; $i++) {

    switch($i) {
        0 {
            $key = "me"
            $dir = $currentPath
            Break
        }
        
        1 {
            $key = "home"
            $dir = $homePath
            Break
        }
        
        2 {
            $key = "psProfile"
            $dir = $psProfileDir
            Break
        }
        
        default {
            Write-Error "Not sure how you got here"
        }
    }

    $path = New-Object -TypeName psobject

    $path | Add-Member -MemberType NoteProperty -Name key -Value $key
    $path | Add-Member -MemberType NoteProperty -Name directory -Value $dir

    $paths += $path
}

# Create the config file
$settings = New-Object -TypeName psobject
$settings | Add-Member -MemberType NoteProperty -Name paths -Value $paths
$settings | ConvertTo-Json | Out-File $PSScriptRoot\config.json

Write-Host "Config file created at" $PSScriptRoot\config.json

# Write the alias to the PowerShell profile
$profileValues = @()

if (Test-Path -Path $profile -PathType Leaf) {

    Write-Host "Existing PowerShell profile file found. Appending alias values."
    $profileValues = Get-Content -Path $profile
}

$profileValues += "New-Alias -Name " + $alias + " -Value " + $PSScriptRoot + "\Navigation-Helper.ps1"
$profileValues += "New-Alias -Name " + $alias + "-edit -Value " + $PSScriptRoot + "\Edit-Navigation-Helper.ps1"

$profileValues | Out-File $profile

# Update the user that the tool has been set up
Write-Host (
    "Your preferences have been saved. After restarting your PowerShell session/s you should be able to use:`n" +
    "`t* " + $alias + " (base command)`n" +
    "`t* " + $alias + "-edit (edit the config file to add or remove directories as desired)"
)
