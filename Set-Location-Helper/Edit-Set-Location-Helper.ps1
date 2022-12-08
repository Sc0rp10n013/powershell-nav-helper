<#
.DESCRIPTION
Used to add or remove values in config to be used by Set-Location-Helper

.EXAMPLE
PS> .\Edit-Set-Location-Helper -add -key test -dir C:\some\directory

key   directory
---   ---------
test  C:\some\directory
test2 C:\test2\directory

.EXAMPLE
PS> .\Edit-Set-Location-Helper -remove -key test

key   directory
---   ---------
test2 C:\test2\directory

.EXAMPLE
PS> .\Edit-Set-Location-Helper -list

key   directory
---   ---------
test  C:\some\directory
test2 C:\test2\directory

.SYNOPSIS
Used to add or remove values in config to be used by Set-Location-Helper
#>

param(
    #Allows the user to add a new value to the config
    [switch]$add=$false,

    #Allows the user to remove a value from the config
    [switch]$remove=$false,

    #Lists the values in the config
    [switch]$list=$false,

    #Specifies the key of the item in config to be added or removed
    [string]$key,
    
    #Specifies the directory associated with the key to be added in config
    [string]$dir
)

if (
    -not $add -and
    -not $remove -and
    -not $list
) {
    Write-Error "Invalid params specified! Use the -? switch to see the available options."
    exit
}

$settings = Get-Content -Path "C:\Absa\tools\scripts\Set-Location-Helper\config.json" | ConvertFrom-Json

if ($list) {

    $settings.paths

    exit
}

if ($add) {

    if (([string]::IsNullOrWhiteSpace($key)) -or ([string]::IsNullOrWhiteSpace($dir))) {

        Write-Error "Key or directory not specified"
        exit
    }

    foreach ($path in $settings.paths) {

        if ($path.key -eq $key) {

            Write-Error "Key already exists in config"
            exit
        }
    }

    $path = New-Object -TypeName psobject

    $path | Add-Member -MemberType NoteProperty -Name key -Value $key
    $path | Add-Member -MemberType NoteProperty -Name directory -Value $dir

    $settings.paths += ($path)

    $settings.paths

    $settings | ConvertTo-Json | Out-File "C:\Absa\tools\scripts\Set-Location-Helper\config.json"

    exit
}

if ($remove) {
    
    if (([string]::IsNullOrWhiteSpace($key))) {

        Write-Error "Key not specified"
        exit
    }

    $newPaths = @()

    foreach ($path in $settings.paths) {
        
        if ($path.key -ne $key) {
            
            $newPaths += $path
        }
    }

    $settings.paths = $newPaths

    $settings.paths

    $settings | ConvertTo-Json | Out-File "C:\Absa\tools\scripts\Set-Location-Helper\config.json"

    exit
}