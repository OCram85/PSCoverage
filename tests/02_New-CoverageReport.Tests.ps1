#region HEADER
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
# Keep in mind to adjust `.parent` method based on the directory level of the pester test file.
$RepoRoot = (Get-Item -Path $here).Parent.Parent.FullName
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$sut = $sut -replace "\d{2}`_", ''
$suthome = (Get-ChildItem -Path $RepoRoot -Exclude ".\tests\" -Filter $sut -Recurse).FullName
# Skip try loading the source file if it doesn't exists.
If ($suthome.Length -gt 0) {
    . $suthome
}
Else {
    Write-Warning ("Could not find source file {0}" -f $sut)
}
#endregion HEADER

# load additional functions defined in the repository. Replace the expression <FunctionName>.
. (Get-ChildItem -Path $RepoRoot -Exclude ".\tests\" -Filter "Get-GitInfo.ps1" -Recurse).FullName
. (Get-ChildItem -Path $RepoRoot -Exclude ".\tests\" -Filter "New-PesterFileMap.ps1" -Recurse).FullName


# TestModule paths
$TestModuleSrc = Join-Path -Path $here -ChildPath '..\resources\TestModule\src'
$TestModuleTests = Join-Path -Path $here -ChildPath '..\resources\TestModule\Tests'

Describe 'New-CoverageReport' {
    Context 'Basic tests' {
        It 'Test1: Should not throw' {
            $FileMap = New-PesterFileMap -SourceRoot $TestModuleSrc -PesterRoot $TestModuleTests
            { $CoverageReport = New-CoverageReport -PesterFileMap $FileMap -RepoToken '12345' } | Should not throw
        }
    }
    Context 'Coverage report validation' {
        It 'Test2: Source file count should be 3' {
            $FileMap = New-PesterFileMap -SourceRoot $TestModuleSrc -PesterRoot $TestModuleTests
            $CoverageReport = New-CoverageReport -PesterFileMap $FileMap -RepoToken '12345'
            $CoverageReport.source_files.Count | Should be 3
        }

    }
}
