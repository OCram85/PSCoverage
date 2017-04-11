Function Publish-CoverageReport () {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$CoverageReport,

        [Parameter(Mandatory=$False)]
        [Switch]$DotNet
    )
    BEGIN {

    }
    PROCESS {
        Add-Type -AssemblyName System.Net.Http
        $stringContent = New-Object System.Net.Http.StringContent (ConvertTo-Json $CoverageReport -Depth 3)
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