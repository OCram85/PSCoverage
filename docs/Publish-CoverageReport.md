---
external help file: PSCoverage-help.xml
Module Name: PSCoverage
online version: https://github.com/OCram85/PSCoverage
schema: 2.0.0
---

# Publish-CoverageReport

## SYNOPSIS
Uploads a given CoverageReport to coveralls.io.

## SYNTAX

```
Publish-CoverageReport [-CoverageReport] <PSObject> [<CommonParameters>]
```

## DESCRIPTION
Publish your coverage.

## EXAMPLES

### EXAMPLE 1
```
Publish-CoverageReport -CoverageReport $CoverallsIOReport
```

## PARAMETERS

### -CoverageReport
Provide a valid CoverageReport created by New-CoverageReport.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [None]
## OUTPUTS

### [Hashtable]
## NOTES
- File Name   : Publish-CoverageReport.ps1
- Author      : Marco Blessing - marco.blessing@googlemail.com
- Author      : Jan Joris - jan@herebedragons.io
- Requires    :

## RELATED LINKS

[https://github.com/OCram85/PSCoverage](https://github.com/OCram85/PSCoverage)

