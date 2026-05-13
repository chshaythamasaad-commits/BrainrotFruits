$ErrorActionPreference = "Stop"

$rojo = Get-Command rojo -ErrorAction SilentlyContinue

if ($null -eq $rojo) {
    throw "Rojo was not found. Run 'aftman install', then try again."
}

Set-Location -LiteralPath $PSScriptRoot
& $rojo.Source serve default.project.json --port 34872 --color never
