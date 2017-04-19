| AppVeyor Overall | AppVeyor Master | AppVeyor Dev | Coveralls.io  | Download |
| :--------------: | :-------------: | :----------: | :-----------: | :--------:|
| [![Build status](https://ci.appveyor.com/api/projects/status/h0qu0s5xla6gt5x3?svg=true)](https://ci.appveyor.com/project/OCram85/PSCoverage) | [![Build status](https://ci.appveyor.com/api/projects/status/h0qu0s5xla6gt5x3/branch/master?svg=true)](https://ci.appveyor.com/project/OCram85/PSCoverage/branch/master) | [![Build status](https://ci.appveyor.com/api/projects/status/h0qu0s5xla6gt5x3/branch/dev?svg=true)](https://ci.appveyor.com/project/OCram85/PSCoverage/branch/dev) | [![Coverage Status](https://coveralls.io/repos/github/OCram85/PSCoverage/badge.svg?branch=master)](https://coveralls.io/github/OCram85/PSCoverage?branch=master) | [![Download](https://img.shields.io/badge/powershellgallery-PSCoverage-blue.svg)](https://www.powershellgallery.com/packages/PSCoverage)

General
=======

PSCoverage is an interface for coveralls.io. It enables you to run your known pester tests and its coverage report.
Furthermore it formats the coverage report and uploads it to coveralls.io.

To get started read the [about_PSCoverage](/src/en-US/about_PSCoverage.help.txt) page.

Installation
============


PowerShellGallery.com (Recommended Way)
---------------------------------------

* Make sure you use PowerShell 5.0 or higher with `$PSVersionTable`.
* Use the builtin PackageManagement and install with: `Install-Module PSCoverage`
* Done. Start exploring the Module with `Import-Module PSCoverage ; Get-Command -Module PSCoverage`

Manual Way
----------

* Take a look at the [Latest Release](https://github.com/OCram85/PSCoverage/releases/latest) page.
* Download the `PSCoverage.zip`.
* Unpack the Zip and put it in your Powershell Module path.
  * Don't forget to change the NTFS permission flag in the context menu.
* Start with `Import-Module PSCoverage`

Usage
-----

Navigate to your module/ repository root. Your module structure needs to be like this:
```
Eg.:
----------------------------------------
~\src\
      Private\
              Invoke-Foobar.ps1
      Functions\
      External\
~\tests\
        Private\
                Invoke-Foobar.Tests.ps1
        Functions\
        External\
~\ModuleManifest.psd1
~\ModuleScript.psm1
----------------------------------------
```

**1.** First you need a file map for source and pester files. You generate a new with:
```powershell
$FileMap = New-PesterFileMap -SourceRoot '.\src' -PesterRoot '.\tests'
```
_The map represents a listing of each source file and its pester file._

**2.** Next you generate your coverage report:
```powershell
$CoverageReport = New-CoverageReport -PesterFileMap $FileMap -RepoToken 'abcd1234'
```
_This runs Invoke-Pester with the appropriate parameters. Keep in mind that you run your unit tests again, if you put PSCoverage in your release pipeline._

**3.** Finally we can upload the coverage report to coveralls.io :
```powershell
Publish-CoverageReport -CoverageReport $CoverageReport
```
