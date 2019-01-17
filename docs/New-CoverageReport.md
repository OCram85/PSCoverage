---
external help file: PSCoverage-help.xml
Module Name: PSCoverage
online version: https://github.com/OCram85/PSCoverage
schema: 2.0.0
---

# New-CoverageReport

## SYNOPSIS
Creates a CoverallsIO coverage report based on pester data.

## SYNTAX

```
New-CoverageReport [-CodeCoverage] <PSObject> [-RepoToken] <String> [[-ModuleRoot] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
New-CoverageReport takes pester output and converts it into CoverallsIO readable format.
It returns a coveralls.io REST API compatible Object.
To upload the coverage report use
Publish-CoverageReport.

Follow this example to create a valid coverage report:

```powershell
$srcFiles = Get-ChildItem -Path ".\src\*.ps1" -Recurse | Sort-Object -Property 'Name' | Select-Object -ExpandProperty 'FullName'
$testFiles = Get-ChildItem -Path ".\tests\*.Tests.ps1" -Recurse | Sort-Object -Property 'Name' | Select-Object -ExpandProperty 'FullName'
$TestResults = Invoke-Pester -Path $testFiles -CodeCoverage $srcFiles -PassThru
$CoverallsIOReport = New-CoverageReport -CodeCoverage $Test.Results.CodeCoverage -RepoToken '123456' -ModuleRoot $PWD
```

## EXAMPLES

### EXAMPLE 1
```powershell
$srcFiles = Get-ChildItem -Path ".\src\*.ps1" -Recurse | Sort-Object -Property 'Name' | Select-Object -ExpandProperty 'FullName'
$testFiles = Get-ChildItem -Path ".\tests\*.Tests.ps1" -Recurse | Sort-Object -Property 'Name' | Select-Object -ExpandProperty 'FullName'
$TestResults = Invoke-Pester -Path $testFiles -CodeCoverage $srcFiles -PassThru
$CoverallsIOReport = New-CoverageReport -CodeCoverage $TestResults.CodeCoverage -RepoToken '123456' -ModuleRoot $PWD
```

## PARAMETERS

### -CodeCoverage
Provide the Pester CodeCoverage data.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ModuleRoot
You need to provide a full path to the module root directory.
New-Coverage report tries to create the
relative paths to your src files.
CoverallsIO needs them to successfully display the file tree.
If you run New-CoverageReport from the base dir of you project you don't need to provide an explicit path.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $(Get-Location)
Accept pipeline input: False
Accept wildcard characters: False
```

### -RepoToken
Coveralls.io provides RepoTokens for grant access to the api upload methods.
Therefore take a look at the
repository page like: https://coveralls.io/github/\<Github UserName\>/\<Repo Name\>.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [None]
## OUTPUTS

### [PSCoverage.Report]
## NOTES
- File Name   : New-CoverageReport.ps1
- Author      : Marco Blessing - marco.blessing@googlemail.com
- Requires    :

## RELATED LINKS

[https://github.com/OCram85/PSCoverage](https://github.com/OCram85/PSCoverage)
