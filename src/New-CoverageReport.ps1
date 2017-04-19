Function New-CoverageReport () {
     <#
    .SYNOPSIS
         Creates a new coverage report based on the given PesterFileMap.

    .DESCRIPTION
        New-CoverageReport runs all Pester tests listed in the PesterFileMap. Source files without pester test will
        be marked as uncovered.
        It returns a coveralls.io REST API compatible Object. To upload the coverage report use
        Publish-CoverageReport.

    .PARAMETER PesterFileMap
        You need to provide a PesterFileMap created with New-PesterFileMap.

    .PARAMETER RepoToken
        Coveralls.io provides RepoTokens for grant access to the api upload methods. Therefore take a look at the
        repository page like: https://coveralls.io/github/<Github UserName>/<Repo Name>.

    .PARAMETER ModuleRoot
        New-CoverageReport uses relative file paths of the module. If you run New-CoverageReport not from
        the root directory of your module you need to provide the ModuleRoot path. This pattern is used to cut from
        the full file names to create the relative path.

    .INPUTS
        [None]

    .OUTPUTS
        [Hashtable]

    .EXAMPLE
        # Set location to your module root
        $FileMap = New-PesterFileMap -SourceRoot '.\src'-PesterRoot '.\tests'
        $CoverageReport = New-CoverageReport -PesterFileMap $FileMap -RepoToken 'ABCD1234'
        Publish-CoverageReport -CoverageReport $CoverageReport

    .NOTES
        File Name   : New-CoverageReport.ps1
        Author      : Marco Blessing - marco.blessing@googlemail.com
        Requires    :

    .LINK
        https://github.com/OCram85/PSCoverage
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]$PesterFileMap,

        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [String]$RepoToken,

        [Parameter(Mandatory=$False)]
        [ValidateNotNullOrEmpty()]
        [String]$ModuleRoot = $(Get-Location)
    )
    BEGIN {
        $CoverReport = [PSCustomObject]@{
            repo_token = $RepoToken
            commit_sha = (git log --format="%H" HEAD -1)
            git = Get-GitInfo
            service_name = 'appveyor'
            source_files = @()
        }
    }

    PROCESS {
        ForEach ($Item in $PesterFileMap.GetEnumerator() | Where-Object {$_.Value.Length -gt 0} ) {
            $Pest = Invoke-Pester -Script $Item.Value -CodeCoverage $Item.Name -PassThru -Quiet

            $Lines = (Get-Content -Path $Item.Name | Measure-Object).Count
            $CoverageArray = @()
            $Hits = 0
            $Missed = 0

            For ($LinePointer = 1; $LinePointer -le $Lines; $LinePointer++) {
                $Hits = ($Pest.CodeCoverage.HitCommands | Where-Object {$_.Line -eq $LinePointer} | Measure-Object).Count
                $Missed = ($Pest.CodeCoverage.MissedCommands | Where-Object {$_.Line -eq $LinePointer} | Measure-Object).Count
                Write-Verbose ("Line: {0} | Hits: {1} | Missed: {2}" -f $LinePointer, $Hits, $Missed)
                If ((-not $Hits -gt 0) -and (-not $Missed -gt 0)) {
                    $CoverageArray += 'null'
                }
                Else {
                    If ($Hits -gt 0) {
                        $CoverageArray += $Hits
                    }
                    Else {
                        If ($Missed -gt 0) {
                            $CoverageArray += $Missed
                        }
                    }
                }
            }
            $CoverageSourceFile = [PSCustomObject]@{
                name = $Item.Name.Replace($ModuleRoot,'').Replace('\','/')
                source_digest = (Get-FileHash -Path $Item.Name -Algorithm MD5).Hash
                coverage = $CoverageArray
            }
            If ($CoverageSourceFile.Name.StartsWith('/')) {
                $CoverageSourceFile.Name = $CoverageSourceFile.Name.Remove(0,1)
            }
            $CoverReport.source_files += $CoverageSourceFile
        }
        # TODO: Generate coverage report for source files without pester tests
    }

    END {
        Write-Output $CoverReport
    }
}
