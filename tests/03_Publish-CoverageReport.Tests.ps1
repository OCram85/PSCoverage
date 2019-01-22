$RepoRoot = (Get-Item -Path (Get-GitDirectory) -Force).Parent | Select-Object -ExpandProperty 'FullName'
Write-Verbose -Message ('RepoRoot: {0}' -f $RepoRoot) -Verbose

Describe 'Publish-CoverageReport' {
    Context 'Basic Tests' {
        $srcFiles = Get-ChildItem -Path "./resources/TestModule/src/*.ps1" -Recurse | Sort-Object -Property 'Name' | Select-Object -ExpandProperty 'FullName'
        $testFiles = Get-ChildItem -Path "./resources/TestModule/tests/*.Tests.ps1" -Recurse | Sort-Object -Property 'Name' | Select-Object -ExpandProperty 'FullName'
        $TestResults = Invoke-Pester -Path $testFiles -CodeCoverage $srcFiles -PassThru
        $CoverallsIOReport = New-CoverageReport -CodeCoverage $TestResults.CodeCoverage -RepoToken $Env:TestToken
        It 'Should not throw' {
            {$res = Publish-CoverageReport -CoverageReport $CoverallsIOReport} | Should -Not -Throw
        }
    }
}
