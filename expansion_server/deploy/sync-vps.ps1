#requires -Version 5.1
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'vps.config.ps1')
$Root = Split-Path -Parent $PSScriptRoot
$Key = $VpsConfig.SshIdentityFile
$Server = $VpsConfig.SshHost
$RemoteDir = $VpsConfig.RemoteRoot

if (-not (Test-Path $Key)) {
  Write-Error "SSH key not found: $Key"
}

$items = @(
  "api",
  "migrations",
  "scripts",
  "package.json",
  "package-lock.json"
)

ssh -i $Key -o BatchMode=yes $Server "mkdir -p $RemoteDir"

foreach ($item in $items) {
  $src = Join-Path $Root $item
  if (-not (Test-Path $src)) { continue }
  scp -i $Key -r $src "${Server}:${RemoteDir}/"
}

# ecosystem at root of remote dir
scp -i $Key (Join-Path $Root "deploy\ecosystem.config.cjs") "${Server}:${RemoteDir}/ecosystem.config.cjs"

Write-Host "Synced to $Server`:$RemoteDir"
