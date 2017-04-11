Function Get-GitInfo () {
    [CmdletBinding()]
    Param(
        [String]$BranchName
    )

    If (-not $BranchName) {
        $BranchName = (git rev-parse --abbrev-ref HEAD)
    }
    Return [PSCustomObject]@{
        head = [PSCustomObject]@{
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
