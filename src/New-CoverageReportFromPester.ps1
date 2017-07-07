function New-CoverageReportFromPester {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [pscustomobject]
        $CodeCoverage
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Token
    )

    process {
        #region Merge hit and missed commands with coverage information and truncate path
        $LineCoverage = @(
            $CodeCoverage.HitCommands    | Select-Object -Property @{
                Name = 'File'
                Expression = {$_.File.Substring($Path.Length)}
            }, @{
                Name = 'Line'
                Expression = {$_.Line}
            }, @{
                Name = 'Coverage'
                Expression = {1}
            }
            $CodeCoverage.MissedCommands | Select-Object -Property @{
                Name = 'File'
                Expression = {$_.File.Substring($Path.Length)}
            }, @{
                Name = 'Line'
                Expression = {$_.Line}
            }, @{
                Name = 'Coverage'
                Expression = {0}
            }
        )
        #endregion

        #region Build data structure and initialize coverage array
        $LineCoverageByFile = @{}
        $LineCoverage | Group-Object -Property File | ForEach-Object {
            $LineCoverageByFile[$_.Name] = @{
                name          = $_.Name.Replace('\', '/')
                source_digest = Get-FileHash -Path "$Path\$($_.Name)" -Algorithm MD5 | Select-Object -ExpandProperty Hash
                coverage      = ,'null' * ($_.Group | Measure-Object -Property Line -Maximum | Select-Object -ExpandProperty Maximum)
            }
        }
        #endregion

        #region Add information about hit and missed commands to coverage array
        $LineCoverage | ForEach-Object {
            $LineCoverageByFile[$_.File].coverage[$_.Line - 1] = $_.Coverage
        }
        #endregion

        #region Build request data structure
        @{
            repo_token = $Token
            source_files = $LineCoverageByFile.Values
        } | ConvertTo-Json -Depth 5
        #endregion
    }
}