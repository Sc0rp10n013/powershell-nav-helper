<#
.DESCRIPTION
A lazy solution for navigating to common folders

.EXAMPLE
PS> .\Navigation-Helper.ps1 -key test
PS C:\test\directory>

.EXAMPLE
PS> .\Navigation-Helper.ps1 -dir C:\some\directory
PS C:\some\directory>

.EXAMPLE
PS> .\Navigation-Helper.ps1 -list

key   directory
---   ---------
test  C:\test\directory
test2 C:\test2\directory
#>

param(
    #Specifies the key of the directory in config
    [string]$key,
    
    #The literal path to nav to in the event that it doesn't already exist in config
    [string]$dir,
    
    #Lists the values in the config
    [switch]$list=$false
)

$ErrorActionPreference = 'Stop'

function navigate {
    [CmdletBinding()]
	param(
		[Parameter()]
		[string] $location
	)
	
	Set-Location $location
}

if (
    [string]::IsNullOrWhiteSpace($key) -and
    [string]::IsNullOrWhiteSpace($dir) -and
    -not $list
) {
    Write-Error "No params or invalid params specified! Use the -? switch to see the available options."
}

if (-not ([string]::IsNullOrWhiteSpace($dir))) {

    navigate $dir
    exit
}

$settings = Get-Content -Path $PSScriptRoot\config.json | ConvertFrom-Json

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
}

navigate (Resolve-Path -Path $location)