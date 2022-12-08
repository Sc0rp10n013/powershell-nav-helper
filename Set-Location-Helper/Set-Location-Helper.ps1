<#
.DESCRIPTION
A nice, lazy solution for navigating to common folders

.EXAMPLE
PS> .\Set-Location-Helper -key test
PS C:\test\directory>

.EXAMPLE
PS> .\Set-Location-Helper -dir C:\some\directory
PS C:\some\directory>

.EXAMPLE
PS> .\Set-Location-Helper -list

key   directory
---   ---------
test  C:\test\directory
test2 C:\test2\directory

.SYNOPSIS
A nice, lazy solution for navigating to common folders
#>

param(
    #Specifies the key of the directory in config
    [string]$key,
    
    #The literal path to nav to in the event that it doesn't already exist in config
    [string]$dir,
    
    #Lists the values in the config
    [switch]$list=$false
)

if (
    [string]::IsNullOrWhiteSpace($key) -and
    [string]::IsNullOrWhiteSpace($dir) -and
    -not $list
) {
    Write-Error "No params specified! Use the -? switch to see the available options."
    exit
}

if (-not ([string]::IsNullOrWhiteSpace($dir))) {

    Set-Location $dir
    exit
}

$settings = Get-Content -Path C:\Absa\tools\scripts\Set-Location-Helper\config.json | ConvertFrom-Json

if ($list) {

    $settings.paths

    exit
}

$location="NA"

foreach ($path in $settings.paths) {

    if ($path.key -eq $key) {

        $location = $path.directory
        break
    }
}

if ($location -eq "NA") {

    Write-Error "Invalid option selected"
    exit
}

Set-Location $location