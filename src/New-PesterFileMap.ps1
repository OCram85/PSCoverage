Function New-PesterFileMap () {
    <#
    .SYNOPSIS
        Generates a new mapping between PowershellSource file <-> PesterTest file.

    .DESCRIPTION
        Pester Coverage function needs a 1:1 relationship between the source file and pester test file.
        Therefore we need this  map to iterate through via Pester.

        You need to sperate your source and pester files in the module. Best practice ist to seperate them in the
        Root level.
        Eg.:
        ~\src\
              Private\
                      Invoke-Foobar.ps1
              Functions\
              External\
        ~\tests\
                Private\
                        Invoko-Foobar.Tests.ps1
                Functions\
                External\
         \ModuleManifest.psd1
         \ModuleScript.psm1

    .PARAMETER SourceRoot
        Specifies the the root directory for powershell source files.

    .PARAMETER PesterRoot
        Specifies the root directory for you Pester files.

    .INPUTS
        [None]

    .OUTPUTS
        [Hashtable]

    .EXAMPLE
        # Set location to your module root
        $FileMap = New-PesterFileMap -SourceRoot '.\src'-PesterRoot '.\tests'

    .NOTES
        File Name   : New-PesterFileMap.ps1
        Author      : Marco Blessing - marco.blessing@googlemail.com
        Requires    :

    .LINK
        https://github.com/OCram85/PSCoverage
    #>

    [CmdletBinding()]
    [OutputType([Hashtable])]
    Param(
        [Parameter(Mandatory=$True)]
        [String]$SourceRoot,

        [Parameter(Mandatory=$True)]
        [String]$PesterRoot
    )

    BEGIN {
        $Map = @{}
    }

    PROCESS {
        $Files = Get-ChildItem -Path $SourceRoot -Filter "*.ps1" -Recurse

        ForEach ($File in $Files) {
            $PesterFile = Get-ChildItem -Path $PesterRoot -Filter ("*{0}.Tests.ps1" -f $File.BaseName) -Recurse
            $Map.($File.FullName) = $PesterFile.FullName
            Write-Verbose ("{0} -> {1}" -f $File.FullName, $PesterFile.FullName)
        }
    }

    END {
        Write-Output $Map
    }
}
