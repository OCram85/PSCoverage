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

* Take a look at the [Latest Release] (https://github.com/OCram85/PSCoverage/releases/latest) page.
* Download the `PSCoverage.zip`.
* Unpack the Zip and put it in your Powershell Module path.
  * Don't forget to change the NTFS permission flag in the context menu.
* Start with `Import-Module PSCoverage`

Build Details
=============

| AppVeyor Overall | AppVeyor Master | AppVeyor Dev | Coveralls.io  | Download |
| :--------------: | :-------------: | :----------: | :-----------: | :--------:|
| [![Build status](https://ci.appveyor.com/api/projects/status/h0qu0s5xla6gt5x3?svg=true)](https://ci.appveyor.com/project/OCram85/PSCoverage) | [![Build status](https://ci.appveyor.com/api/projects/status/h0qu0s5xla6gt5x3/branch/master?svg=true)](https://ci.appveyor.com/project/OCram85/PSCoverage/branch/master) | [![Build status](https://ci.appveyor.com/api/projects/status/h0qu0s5xla6gt5x3/branch/dev?svg=true)](https://ci.appveyor.com/project/OCram85/PSCoverage/branch/dev) | [![Coverage Status](https://coveralls.io/repos/github/OCram85/PSCoverage/badge.svg?branch=master)](https://coveralls.io/github/OCram85/PSCoverage?branch=master) | [![Download](https://img.shields.io/badge/powershellgallery.com-PSCoverage-blue.svg)](https://www.powershellgallery.com/packages/PSCoverage)
