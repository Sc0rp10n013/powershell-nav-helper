# PowerShell Navigation Helper

## Overview

This project was created primarily for 2 reasons:
1. Until recently I hadn't really dabbled with PowerShell scripts and was interested in how they work, and;
2. I'm honestly quite lazy. I wanted to have a means of shorting a command like
```
    PS> cd C:\some\project\dir
```
down to
```
    PS> goto project
```
and decided that this was a good enough excuse to experiment with PowerShell scripts. 

## Setup

* Clone the repo to wherever you'd like to run the files from.
* Open PowerShell and navigate into `.\powershell-nav-helper\Navigation-Helper`.
* Run `Setup-Navigation-Helper.ps1` and follow the prompts.
    * Alternatively you can run `Setup-Navigation-Helper.ps1 -alias [alias]` where `[alias]` is whatever alias you choose to reference the nav helper by.
* Restart any running PS sessions and start enjoying the lazy navigation

## Using the scripts

There is some basic documentation on the scripts accessible by running:
```
    PS> Get-Help [script-name] -Full
```

However, here is a better breakdown on the scripts:

### Navigation-Helper.ps1

This is the main script. This script uses the config file (located in the running directory of the scripts and created during setup) to navigate to whatever directories you have listed there.

Using the script is straightforward. As part of the setup, you will create an alias for the script which is saved to your PowerShell profile and can be referenced from anywhere. For the sake of simplicity I will refer to this alias as `goto`, but you will be able to name it whatever you want.

Here are some examples of how the script is used (with the outputs):
```
PS> goto -key test
PS C:\test\directory>
```
```
PS> goto -dir C:\some\directory
PS C:\some\directory>
```
```
PS> goto -list

key   directory
---   ---------
test  C:\test\directory
test2 C:\test2\directory
```

### Edit-Navigation-Helper.ps1

This script allows you to easily add or remove keys in the config file.

During the setup process, this script will also be as `[alias]-edit`. For example, if your alias for `Navigation-Helper.ps1` is `goto`, then the `Edit-Navigation-Helper.ps1` alias will be `goto-edit`.

Examples of how to use the script (with outputs):
```
PS> .\Edit-Navigation-Helper -add -key test -dir C:\some\directory

key   directory
---   ---------
test  C:\some\directory
test2 C:\test2\directory
```

```
PS> .\Edit-Navigation-Helper -remove -key test

key   directory
---   ---------
test2 C:\test2\directory
```

```
PS> .\Edit-Navigation-Helper -list

key   directory
---   ---------
test  C:\some\directory
test2 C:\test2\directory
```

### Setup-Navigation-Helper.ps1

This script sets up the navigation helper by creating the config file and setting the user's chosen alias into the PowerShell profile so that it can be easily referenced.

The script will check for an existing config file and, if it exists, prompt if you wish to overwrite it. If not, execution will be stopped and you can then backup your config manually before re-running the script and generating a new config. This is a bit of an edge case as it's unlikely that anyone will re-run the setup after going through the process, but it's there.

Example of running the script in a best case scenario (with outputs):
```
PS> .\Setup-Navigation-Helper.ps1 -alias goto

Config file does not exist. Creating new file.
Config file created at C:\Projects\code\powershell-nav-helper\Navigation-Helper\config.json
Your preferences have been saved. After restarting your PowerShell session/s you should be able to use:
        * goto (base command)
        * goto-edit (edit the config file to add or remove directories as desired)
```

*Note that after completing execution, you will need to restart your running PowerShell sessions before you can reference the alias.*

### config.json

During the setup, this file is created in the script's executing directory. If you want to add or remove multiple elements to this file, it may be easier to just edit it directly.

Basic structure of the file is as follows:
```json
{
  "paths": [
    {
      "key": "key",
      "directory": "C:\\some\\directory"
    }
  ]
}
```
