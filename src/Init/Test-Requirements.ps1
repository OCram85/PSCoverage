Try {
    $GitVersion = $(git --version)
}
Catch {
    Write-Warning -Message @"
It seems like you did not install a git client! You need a valid git setup to work with PSCoverage.
Please install the git client and repeat try it again.

Git Client Installation
-----------------------
If you need help installing the client take a look at https://git-scm.com.
The easiest way is to your chocolatey: `choco install git -y`
"@
    Throw "Requirement Check failed!"
}