$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

Write-Host "[manual-sync] repository: $scriptDir"
Write-Host "[manual-sync] running npm run sync:fiji-ref"

npm run sync:fiji-ref
