$c = [System.IO.File]::ReadAllText('pubspec.yaml')
if (-not $c.Contains('- assets/icons/')) {
    $c = $c.Replace("    - assets/drinks/", "    - assets/drinks/`r`n    - assets/icons/")
    [System.IO.File]::WriteAllText('pubspec.yaml', $c)
    Write-Host "Updated pubspec.yaml"
} else {
    Write-Host "Already present in pubspec.yaml"
}
