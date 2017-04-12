$Items = (Get-ChildItem -Path ("{0}\*.ps1" -f $PSScriptRoot ) -Recurse ).FullName | Where-Object {
    $_ -notmatch "(Classes|Init)"
}
ForEach ($Item in $Items) {
    # Write-Verbose ("Dotsourcing file {0}" -f $Item)
    . $Item
}

# Exports are now controlles by module Manifest
# Export-ModuleMember -Function *
