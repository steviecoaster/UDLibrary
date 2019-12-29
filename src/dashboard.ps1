$root = Split-Path $MyInvocation.MyCommand.Definition
$pages = Join-Path $root "Pages"
Get-ChildItem $PSScriptRoot\Pages\*.ps1 -Recurse | % { . $_.FullName }

$dashboard = New-UDDashboard -Title "Valdinger Home Library" -Pages @($search,$loan)

Start-UDDashboard -Dashboard $dashboard -Port 10001