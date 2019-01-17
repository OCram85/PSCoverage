$RepoRoot = (Get-Item -Path (Get-GitDirectory) -Force).Parent | Select-Object -ExpandProperty 'FullName'
Write-Verbose -Message ('RepoRoot: {0}' -f $RepoRoot) -Verbose

$ManifestFilePath = Join-Path -Path $RepoRoot -ChildPath '/src/PSCoverage.psd1'
Write-Verbose -Message ("ManifestFilePath: {0}" -f $ManifestFilePath) -Verbose

Describe 'Module Tests' {
    Context 'Manifest related tests' {
        It 'Tests the file itself' {
            { Test-ModuleManifest -Path $ManifestFilePath -Verbose } | Should -Not -Throw
        }
    }
    Context "Module consistency tests" {
        It "Importing should work" {
            { Import-Module -Name $ManifestFilePath -Global -Force -Verbose } | Should -Not -Throw
        }
    }
}
