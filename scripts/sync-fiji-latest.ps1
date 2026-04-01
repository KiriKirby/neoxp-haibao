param()

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Resolve-Path (Join-Path $scriptDir "..")
$upstreamRoot = Resolve-Path (Join-Path $projectRoot "..")
$targetDir = Join-Path $projectRoot "references\fiji-upstream"
$metadataPath = Join-Path $targetDir "UPSTREAM_VERSION.json"
$aliasPath = Join-Path $targetDir "LATEST_MACRO.ijm"

function Parse-VersionFromName {
    param(
        [string]$Name
    )

    if ($Name -match '^Macrophage Image Four-Factor Analysis_(\d+)\.(\d+)\.(\d+)\.ijm$') {
        return [PSCustomObject]@{
            Major = [int]$Matches[1]
            Minor = [int]$Matches[2]
            Patch = [int]$Matches[3]
            Version = "$($Matches[1]).$($Matches[2]).$($Matches[3])"
        }
    }

    return $null
}

$candidates = Get-ChildItem $upstreamRoot -Filter 'Macrophage Image Four-Factor Analysis_*.ijm' -File | ForEach-Object {
    $parsed = Parse-VersionFromName -Name $_.Name
    if ($null -eq $parsed) {
        return
    }

    if ($parsed.Version -eq "3.0.2") {
        return
    }

    [PSCustomObject]@{
        File = $_
        Parsed = $parsed
    }
}

if (-not $candidates) {
    throw "No eligible Fiji macro found under $upstreamRoot"
}

$latest = $candidates |
    Sort-Object `
        @{ Expression = { $_.Parsed.Major } },
        @{ Expression = { $_.Parsed.Minor } },
        @{ Expression = { $_.Parsed.Patch } } |
    Select-Object -Last 1

New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

Get-ChildItem $targetDir -Filter 'Macrophage Image Four-Factor Analysis_*.ijm' -File -ErrorAction SilentlyContinue |
    Remove-Item -Force

Copy-Item $latest.File.FullName -Destination (Join-Path $targetDir $latest.File.Name) -Force
Copy-Item $latest.File.FullName -Destination $aliasPath -Force

$metadata = [ordered]@{
    upstream_repo_root = $upstreamRoot.Path
    source_file = $latest.File.FullName
    source_name = $latest.File.Name
    source_version = $latest.Parsed.Version
    copied_at = (Get-Date).ToString("s")
    fixed_reference_ignored = "Macrophage Image Four-Factor Analysis_3.0.2.ijm"
    rule = "Pick the highest 4.x-or-later versioned macro filename at upstream repo root and copy it here."
}

$metadata | ConvertTo-Json | Set-Content -Path $metadataPath -Encoding utf8

Write-Host "[sync] upstream root: $($upstreamRoot.Path)"
Write-Host "[sync] selected: $($latest.File.Name)"
Write-Host "[sync] target dir: $targetDir"
Write-Host "[sync] alias: $aliasPath"
