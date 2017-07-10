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
# . (Get-ChildItem -Path $RepoRoot -Exclude ".\tests\" -Filter "<Function-Name>.ps1" -Recurse).FullName


# TestModule paths
$TestModuleSrc = Join-Path -Path $here -ChildPath '..\resources\TestModule\src'
$TestModuleTests = Join-Path -Path $here -ChildPath '..\resources\TestModule\Tests'

Describe 'New-PesterFileMap' {
    Context 'Basic tests' {
        It 'Test1: Should not throw' {
            { $FileMap = New-PesterFileMap -SourceRoot $TestModuleSrc -PesterRoot $TestModuleTests } | Should not throw
        }
    }
    Context 'Test FileMap' {
        It 'Test2: Count items' {
            $FileMap = New-PesterFileMap -SourceRoot $TestModuleSrc -PesterRoot $TestModuleTests
            $Count = ($FileMap.GetEnumerator() | Measure-Object).Count
            $Count | Should be 3
        }
    }
}
