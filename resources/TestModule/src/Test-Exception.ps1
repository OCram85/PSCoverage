function Test-Exception {
    [CmdletBinding()]
    param (
        [string]$ExceptionMessage
    )
    Write-Error $ExceptionMessage
}
