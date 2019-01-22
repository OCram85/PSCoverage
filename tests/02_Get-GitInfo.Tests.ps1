$RepoRoot = (Get-Item -Path (Get-GitDirectory) -Force).Parent | Select-Object -ExpandProperty 'FullName'
Write-Verbose -Message ('RepoRoot: {0}' -f $RepoRoot) -Verbose

Describe 'Get-GitInfo' {
    Context 'Basic Tests' {

        Import-Module (Join-Path -Path $RepoRoot -ChildPath '/src/PSCoverage.psm1') -Force

        It 'Should not throw' {
            { Get-GitInfo }  | Should -Not -Throw
        }

        It 'Should run standalone' {
            Remove-Item Env:\AppVeyor -Force
            { Get-GitInfo } | Should -Not -Throw
            $Env:AppVeyor = $true
        }
    }
}
