Function Publish-CoverageReport () {
     <#
    .SYNOPSIS
        Uploads a given CoverageReport to coveralls.io.
    .DESCRIPTION

    .PARAMETER CoverageReport
        Provide a valid CoverageReport created by New-CoverageReport.

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
        File Name   : Publish-CoverageReport.ps1
        Author      : Marco Blessing - marco.blessing@googlemail.com
        Author      : Jan Joris - jan@herebedragons.io
        Requires    :

    .LINK
        https://github.com/OCram85/PSCoverage
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$CoverageReport
    )
    BEGIN {
        Add-Type -AssemblyName System.Net.Http
    }

    PROCESS {
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

    END {
        Write-Output $Content
    }
}
