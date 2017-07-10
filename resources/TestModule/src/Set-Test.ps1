function Set-Test {
    [CmdletBinding()]
    Param(
        [int]$Value
    )

    if ($value -le 10 ) {
        return $Value
    }
    else {
        $message = "Didn't execute this line"
        return $message
    }
}
