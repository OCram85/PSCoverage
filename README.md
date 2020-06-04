[![AppVeyor branch](https://img.shields.io/appveyor/ci/OCram85/PSCoverage/master.svg?style=plastic "Master Branch Build Status")](https://ci.appveyor.com/project/OCram85/PSCoverage/branch/master)
[![AppVeyor tests branch](https://img.shields.io/appveyor/tests/OCram85/PSCoverage/master.svg?style=plastic "Pester Tests Results")](https://ci.appveyor.com/project/OCram85/PSCoverage/branch/master/tests)
[![Coveralls github](https://img.shields.io/coveralls/github/OCram85/PSCoverage.svg?style=plastic "Coveralls.io Coverage Report")](https://coveralls.io/github/OCram85/PSCoverage?branch=master)
[![codecov](https://codecov.io/gh/OCram85/PSCoverage/branch/master/graph/badge.svg)](https://codecov.io/gh/OCram85/PSCoverage)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/PSCoverage.svg?style=plastic "PowershellGallery Published Version")](https://www.powershellgallery.com/packages/PSCoverage)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/PSCoverage.svg?style=plastic "PowershellGallery Downloads")](https://www.powershellgallery.com/packages/PSCoverage)

![forthebadge](http://forthebadge.com/images/badges/built-with-love.svg)
![forthebadge](http://forthebadge.com/images/badges/for-you.svg)

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
* Use the builtin PackageManagement and install with: `Install-Module PSCoverage -AllowPrerelease`
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

```console
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
```

**1.** First you need a list of all your src files:

```powershell
$srcFiles = Get-ChildItem -Path ".\src\*.ps1" -Recurse | Sort-Object -Property 'Name' | Select-Object -ExpandProperty 'FullName'
```

**2.** Next you need a list with all your pester tests files:

```powershell
$testFiles = Get-ChildItem -Path ".\tests\*.Tests.ps1" -Recurse | Sort-Object -Property 'Name' | Select-Object -ExpandProperty 'FullName'
```

**3.** The simplest way to get you code coverage is by creating it with your unit tests. This avoids rerunning all
the test with PSCoverage:

```powershell
$TestResults = Invoke-Pester -Path $testFiles -CodeCoverage $srcFiles -PassThru
```

**4.** And then passthru the code coverage to create a new report:

```powershell
$CoverallsIOReport = New-CoverageReport -CodeCoverage $TestResults.CodeCoverage -RepoToken '123456' -ModuleRoot $PWD
```

**5.** Finally we can upload the coverage report to coveralls.io:

```powershell
Publish-CoverageReport -CoverageReport $CoverallsIOReport
```
