function Get-GitInfo () {
    [CmdletBinding()]
    param(
        [string]$BranchName
    )

    if ($Env:AppVeyor) {
        return [PSCustomObject]@{
            PSTypeName = 'PSCoverage.Git.Info'
            head = [PSCustomObject]@{
                PSTypeName = 'PSCoverage.Git.HEAD'
                id = $Env:APPVEYOR_REPO_COMMIT
                author_name = $Env:APPVEYOR_REPO_COMMIT_AUTHOR
                author_email = $Env:APPVEYOR_REPO_COMMIT_AUTHOR_EMAIL
                comitter_name = $Env:APPVEYOR_REPO_COMMIT_AUTHOR
                comitter_email = $Env:APPVEYOR_REPO_COMMIT_AUTHOR_EMAIL
                message = $Env:APPVEYOR_REPO_COMMIT_MESSAGE
            }
            branch = $Env:APPVEYOR_REPO_BRANCH
        }
    }
    else {
        if (-not $BranchName) {
            $BranchName = (git rev-parse --abbrev-ref HEAD)
        }
        return [PSCustomObject]@{
            PSTypeName = 'PSCoverage.Git.Info'
            head = [PSCustomObject]@{
                PSTypeName = 'PSCoverage.Git.HEAD'
                id = (git log --format="%H" HEAD -1)
                author_name = (git log --format="%an" HEAD -1)
                author_email = (git log --format="%ae" HEAD -1)
                committer_name = (git log --format="%cn" HEAD -1)
                committer_email = (git log --format="%ce" HEAD -1)
                message = (git log --format="%s" HEAD -1)
            }
            branch = $BranchName
        }
    }
}

Function New-CoverageReport () {
    <#
    .SYNOPSIS
        Creates a CoverallsIO coverage report based on pester data

    .DESCRIPTION
        New-CoverageReport takes pester output and converts it into CoverallsIO readable format.
        It returns a coveralls.io REST API compatible Object. To upload the coverage report use
        Publish-CoverageReport.

        Follow this example to create a valid coverage report:

        ```
        $srcFiles = Get-ChildItem -Path ".\src\*.ps1" -Recurse | Sort-Object -Property 'Name' | Select-Object -ExpandProperty 'FullName'
        $testFiles = Get-ChildItem -Path ".\tests\*.Tests.ps1" -Recurse | Sort-Object -Property 'Name' | Select-Object -ExpandProperty 'FullName'
        $TestResults = Invoke-Pester -Path $testFiles -CodeCoverage $srcFiles -PassThru
        $CoverallsIOReport = New-CoverageReport -CodeCoverage $Test.ResultsCodeCoverage -RepoToken '123456' -ModuleRoot $PWD
        ```
    .PARAMETER CodeCoverage
        Provide the Pester CodeCoverage data.

    .PARAMETER RepoToken
        Coveralls.io provides RepoTokens for grant access to the api upload methods. Therefore take a look at the
        repository page like: https://coveralls.io/github/<Github UserName>/<Repo Name>.

    .PARAMETER ModuleRoot
        You need to provide a full path to the module root directory. New-Coverage report tries to create the
        relative paths to your src files. CoverallsIO needs them to successfully display the file tree.
        If you run New-CoverageReport from the base dir of you project you don't need to provide an explicit path.

    .INPUTS
        [None]

    .OUTPUTS
        [PSCoverage.Report]

    .EXAMPLE
        $srcFiles = Get-ChildItem -Path ".\src\*.ps1" -Recurse | Sort-Object -Property 'Name' | Select-Object -ExpandProperty 'FullName'
        $testFiles = Get-ChildItem -Path ".\tests\*.Tests.ps1" -Recurse | Sort-Object -Property 'Name' | Select-Object -ExpandProperty 'FullName'
        $TestResults = Invoke-Pester -Path $testFiles -CodeCoverage $srcFiles -PassThru
        $CoverallsIOReport = New-CoverageReport -CodeCoverage $TestResults.CodeCoverage -RepoToken '123456' -ModuleRoot $PWD

    .NOTES
        - File Name   : New-CoverageReport.ps1
        - Author      : Marco Blessing - marco.blessing@googlemail.com
        - Requires    :

    .LINK
        https://github.com/OCram85/PSCoverage
    #>

    [CmdletBinding()]
    [OutputType('PSCoverage.Report')]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$CodeCoverage,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$RepoToken,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$ModuleRoot = $(Get-Location)
    )
    begin {
        $CoverReport = [PSCustomObject]@{
            PSTypeName = 'PSCoverage.Report'
            repo_token = $RepoToken
            commit_sha = (git log --format="%H" HEAD -1)
            git = Get-GitInfo
            service_name = 'appveyor'
            source_files = @()
        }
    }

    process {
        # Find all files with hit commands -> These file have pester tests
        $UsedFiles = $CodeCoverage.AnalyzedFiles | Where-Object {
            $CodeCoverage.HitCommands.File -contains $_
        }

        foreach ($SourceFile in $UsedFiles) {
            $Lines = (Get-Content -Path $SourceFile | Measure-Object).Count
            Write-Verbose ("SourceFile: {0} | LinesCount: {1}" -f $SourceFile, $Lines)
            $CoverageArray = @()
            $Hits = 0
            $Missed = 0

            for ($LinePointer = 1; $LinePointer -le $Lines; $LinePointer++) {

                # Get only hit commands from current src file
                $curHits = $CodeCoverage.HitCommands | Where-Object {
                    $_.File -eq $SourceFile
                }
                [int]$Hits = (
                    $curHits | Where-Object {
                        $_.Line -eq $LinePointer
                    } | Measure-Object
                ).Count

                # again filter only missed commands from the curent file
                $curMissed = $CodeCoverage.MissedCommands | Where-Object {
                    $_.File -eq $SourceFile
                }
                [int]$Missed = (
                    $curMissed | Where-Object {
                        $_.Line -eq $LinePointer
                    } | Measure-Object
                ).Count

                Write-Verbose ("SourceFile:{0} | Line: {1} | Hits: {2} | Missed: {3}" -f $SourceFile, $LinePointer, $Hits, $Missed)
                if ((-not $Hits -gt 0) -and (-not $Missed -gt 0)) {
                    $CoverageArray += 'null'
                }
                else {
                    if ($Hits -gt 0) {
                        $CoverageArray += $Hits
                    }
                    elseif ($Missed -gt 0) {
                        $CoverageArray += 0
                    }
                }
            }
            # Get rid of the quotation
            $CoverageArray = $CoverageArray -Replace '"', ''
            $CoverageSourceFile = [PSCustomObject]@{
                name = $SourceFile.Replace($ModuleRoot, '').Replace('\', '/')
                source_digest = (Get-FileHash -Path $SourceFile -Algorithm MD5).Hash
                coverage = $CoverageArray
            }
            If ($CoverageSourceFile.Name.StartsWith('/')) {
                $CoverageSourceFile.Name = $CoverageSourceFile.Name.Remove(0, 1)
            }
            $CoverReport.source_files += $CoverageSourceFile
        }

        # Find all untested files to create a null coverage file
        $UnUsedFiles = $CodeCoverage.AnalyzedFiles | Where-Object {
            $CodeCoverage.HitCommands.File -notcontains $_
        }

        foreach ($UnUsedFile in $UnUsedFiles) {
            $Lines = (Get-Content -Path $UnUsedFile | Measure-Object).Count
            $CoverageArray = @()
            for ($LinePointer = 1; $LinePointer -le $Lines; $LinePointer++) {
                $CoverageArray += '0'
            }
            $CoverageSourceFile = [PSCustomObject]@{
                name = $UnUsedFile.Replace($ModuleRoot, '').Replace('\', '/')
                source_digest = (Get-FileHash -Path $UnUsedFile -Algorithm MD5).Hash
                coverage = $CoverageArray
            }
            if ($CoverageSourceFile.Name.StartsWith('/')) {
                $CoverageSourceFile.Name = $CoverageSourceFile.Name.Remove(0, 1)
            }
            $CoverReport.source_files += $CoverageSourceFile
        }
    }

    end {
        Write-Output $CoverReport
    }
}

function Publish-CoverageReport () {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$CoverageReport
    )
    begin {
        Add-Type -AssemblyName System.Net.Http
    }

    process {
        $CoverageJSON = ConvertTo-Json $CoverageReport -Depth 5
        # Try to fix null elements in coverage array.
        $CoverageJSON = $CoverageJSON.Replace('"null"', 'null')
        $stringContent = New-Object System.Net.Http.StringContent ($CoverageJSON)
        $httpClient = New-Object System.Net.Http.Httpclient
        $formdata = New-Object System.Net.Http.MultipartFormDataContent
        $formData.Add($stringContent, "json_file", "coverage.json")
        $result = $httpClient.PostAsync('https://coveralls.io/api/v1/jobs', $formData).Result
        $content = $result.Content.ReadAsStringAsync()
    }

    end {
        Write-Output $Content
    }
}

function Publish-CoverageReport {
    <#
    .SYNOPSIS
        Uploads a given CoverageReport to coveralls.io.

    .DESCRIPTION
        Publish your coverage.

    .PARAMETER CoverageReport
        Provide a valid CoverageReport created by New-CoverageReport.

    .INPUTS
        [None]

    .OUTPUTS
        [Hashtable]

    .EXAMPLE
        Publish-CoverageReport -CoverageReport $CoverallsIOReport

    .NOTES
        - File Name   : Publish-CoverageReport.ps1
        - Author      : Marco Blessing - marco.blessing@googlemail.com
        - Author      : Jan Joris - jan@herebedragons.io
        - Requires    :

    .LINK
        https://github.com/OCram85/PSCoverage
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$CoverageReport
    )
    begin {
        Add-Type -AssemblyName 'System.Net.Http'
    }

    process {
        $CoverageJSON = ConvertTo-Json $CoverageReport -Depth 3
        # Try to fix null elements in coverage array.
        $CoverageJSON = $CoverageJSON.Replace('"null"', 'null')
        $stringContent = New-Object System.Net.Http.StringContent ($CoverageJSON)
        $httpClient = New-Object System.Net.Http.Httpclient
        $formdata = New-Object System.Net.Http.MultipartFormDataContent
        $formData.Add($stringContent, "json_file", "coverage.json")
        $result = $httpClient.PostAsync('https://coveralls.io/api/v1/jobs', $formData).Result
        $content = $result.Content.ReadAsStringAsync()
    }

    end {
        Write-Output $Content
    }
}
