#requires -Version 5.1
param(
  [string]$HostName = "autogie1.beget.tech",
  [string]$User = "autogie1_todo",
  [string]$RemoteDir = "expansion_api"
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$Remote = "${User}@${HostName}:${RemoteDir}/"

Write-Host "Sync expansion_server -> Beget $Remote"

if (-not (Get-Command pscp -ErrorAction SilentlyContinue)) {
  Write-Error "pscp not found (PuTTY). Install PuTTY or add to PATH."
}

# Создать каталог на сервере
& plink -batch -ssh "${User}@${HostName}" "mkdir -p $RemoteDir"

$items = @(
  "api",
  "migrations",
  "scripts",
  "package.json",
  "package-lock.json",
  "app.beget.js"
)

foreach ($item in $items) {
  $src = Join-Path $Root $item
  if (-not (Test-Path $src)) {
    Write-Warning "Skip missing: $item"
    continue
  }
  & pscp -batch -r $src "${User}@${HostName}:${RemoteDir}/"
}

& pscp -batch (Join-Path $Root "deploy\.htaccess.beget") "${User}@${HostName}:${RemoteDir}/.htaccess"

Write-Host "Done. Next: SSH, npm install, .env, migrate, restart Passenger."
