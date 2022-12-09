<#
.DESCRIPTION
Used to add or remove values in config to be used by Navigation-Helper

.EXAMPLE
PS> .\Edit-Navigation-Helper.ps1 -add -key test -dir C:\some\directory

key   directory
---   ---------
test  C:\some\directory
test2 C:\test2\directory

.EXAMPLE
PS> .\Edit-Navigation-Helper.ps1 -remove -key test

key   directory
---   ---------
test2 C:\test2\directory

.EXAMPLE
PS> .\Edit-Navigation-Helper.ps1 -list

key   directory
---   ---------
test  C:\some\directory
test2 C:\test2\directory
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

$ErrorActionPreference = 'Stop'

if (
    -not $add -and
    -not $remove -and
    -not $list
) {
    Write-Error "Invalid params specified! Use the -? switch to see the available options."
}

$settings = Get-Content -Path $PSScriptRoot\config.json | ConvertFrom-Json

if ($list) {

    $settings.paths

    exit
}

function writeConfig {
    [CmdletBinding()]
	param(
		[Parameter()]
		[System.Object] $settings
	)
	
    $settings | ConvertTo-Json | Out-File $PSScriptRoot\config.json
}

if ($add) {

    if (([string]::IsNullOrWhiteSpace($key)) -or ([string]::IsNullOrWhiteSpace($dir))) {

        Write-Error "Key or directory not specified"
    }

    foreach ($path in $settings.paths) {

        if ($path.key -eq $key) {

            Write-Error "Key already exists in config"
        }
    }

    $path = New-Object -TypeName psobject

    $path | Add-Member -MemberType NoteProperty -Name key -Value $key
    $path | Add-Member -MemberType NoteProperty -Name directory -Value (Resolve-Path -Path $dir)

    $settings.paths += ($path)

    $settings.paths

    writeConfig $settings

    exit
}

if ($remove) {
    
    if (([string]::IsNullOrWhiteSpace($key))) {

        Write-Error "Key not specified"
    }

    $newPaths = @()

    foreach ($path in $settings.paths) {
        
        if ($path.key -ne $key) {
            
            $newPaths += $path
        }
    }

    $settings.paths = $newPaths

    $settings.paths

    writeConfig $settings

    exit
}