Function New-CoverageReport () {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]$PesterMap,
        
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
        ForEach ($Item in $PesterMap.GetEnumerator() | Where-Object {$_.Value.Length -gt 0} ) {
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
    }

    END {
        Write-Output $CoverReport
    }
}
