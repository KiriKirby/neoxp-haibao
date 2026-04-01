param(
    [string]$UpstreamRoot = "",
    [switch]$Optional
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = (Resolve-Path (Join-Path $scriptDir "..")).Path
$defaultUpstreamRoot = Join-Path (Split-Path $projectRoot -Parent) "Macrophage-4-Analysis"
$targetDir = Join-Path $projectRoot "references\fiji-upstream"
$metadataPath = Join-Path $targetDir "UPSTREAM_VERSION.json"
$aliasPath = Join-Path $targetDir "LATEST_MACRO.ijm"

if ([string]::IsNullOrWhiteSpace($UpstreamRoot)) {
    $UpstreamRoot = $defaultUpstreamRoot
}

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

function Complete-Skip {
    param(
        [string]$Reason
    )

    Write-Host "[sync] skipped: $Reason"
    exit 0
}

if (-not (Test-Path $UpstreamRoot)) {
    if ($Optional) {
        Complete-Skip -Reason "upstream root not found at $UpstreamRoot"
    }

    throw "Upstream Fiji repository root not found at $UpstreamRoot"
}

$upstreamRoot = (Resolve-Path $UpstreamRoot).Path

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
    if ($Optional) {
        Complete-Skip -Reason "no eligible Fiji macro found under $upstreamRoot"
    }

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

$metadata = [PSCustomObject]@{
    upstream_repo_root = $upstreamRoot
    source_file = $latest.File.FullName
    source_name = $latest.File.Name
    source_version = $latest.Parsed.Version
    copied_at = (Get-Date).ToString("s")
    fixed_reference_ignored = "Macrophage Image Four-Factor Analysis_3.0.2.ijm"
    rule = "Pick the highest versioned root-level macro filename at the upstream Fiji repository root, excluding 3.0.2, and copy it here."
}

$metadata | ConvertTo-Json | Set-Content -Path $metadataPath -Encoding utf8

Write-Host "[sync] upstream root: $upstreamRoot"
Write-Host "[sync] selected: $($latest.File.Name)"
Write-Host "[sync] target dir: $targetDir"
Write-Host "[sync] alias: $aliasPath"

