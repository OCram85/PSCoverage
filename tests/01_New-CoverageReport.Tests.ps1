# Test module paths
$RepoRoot = (Get-Item -Path (Get-GitDirectory) -Force).Parent | Select-Object -ExpandProperty 'FullName'
$TestModuleSrc = Get-ChildItem -Path (
    Join-Path -Path $RepoRoot -ChildPath "/resources/TestModule/src/*.ps1"
) -Recurse | Sort-Object -Property 'Name' | Select-Object -ExpandProperty 'FullName'
$TestModuleTests = Join-Path -Path $RepoRoot -ChildPath '/resources/TestModule/Tests'

Describe 'New-CoverageReport' {
    Context 'Basic tests' {
        It 'Test1: Should not throw' {
            $TestResults = Invoke-Pester -Path $TestModuleTests -CodeCoverage $TestModuleSrc -PassThru -Show None -ErrorAction SilentlyContinue
            { $CoverageReport = New-CoverageReport -CodeCoverage $TestResults.CodeCoverage -RepoToken '123456'} | Should -Not -Throw
        }
        It 'Test2: Source file count should be 3' {
            $TestResults = Invoke-Pester -Path $TestModuleTests -CodeCoverage $TestModuleSrc -PassThru -Show None -ErrorAction SilentlyContinue
            $CoverageReport = New-CoverageReport -CodeCoverage $TestResults.CodeCoverage -RepoToken '123456'
            $CoverageReport.source_files.Count | Should -Be 4
        }
    }
}
