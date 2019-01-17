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

**1.** First you need a list of all your src files:

```
$srcFiles = Get-ChildItem -Path ".\src\*.ps1" -Recurse | Sort-Object -Property 'Name' | Select-Object -ExpandProperty 'FullName'
```

**2.** Next you need a list with all your pester tests files:

```
$testFiles = Get-ChildItem -Path ".\tests\*.Tests.ps1" -Recurse | Sort-Object -Property 'Name' | Select-Object -ExpandProperty 'FullName'
```

**3.** The simplest way to get you code coverage is by creating it with your unit tests. This avoids rerunning all
the test with PSCoverage:

```
$TestResults = Invoke-Pester -Path $testFiles -CodeCoverage $srcFiles -PassThru
```

**4.** And then passthru the code coverage to create a new report:

```
$CoverallsIOReport = New-CoverageReport -CodeCoverage $TestResults.CodeCoverage -RepoToken '123456' -ModuleRoot $PWD
```

**5.** Finally we can upload the coverage report to coveralls.io:

```
Publish-CoverageReport -CoverageReport $CoverallsIOReport
```
