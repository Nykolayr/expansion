#requires -Version 5.1
# Полный деплой API на redmobi VPS — паттерн redmobi_vps/scripts/deploy-lead-bot.ps1
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $PSScriptRoot
. (Join-Path $PSScriptRoot 'vps.config.ps1')
. (Join-Path $PSScriptRoot 'beget.config.ps1')

$vps = $VpsConfig
$beget = $BegetConfig
$remoteDir = $vps.RemoteRoot
$secrets = Join-Path $here 'deploy\secrets\expansion-api.env'
$scpArgs = @('-o', 'ConnectTimeout=30', '-i', $vps.SshIdentityFile)

function Invoke-RemoteBash {
  param([Parameter(Mandatory)][string]$Script)
  $normalized = ($Script -replace "`r", '').TrimEnd() + "`n"
  $tempScript = Join-Path $env:TEMP ("expansion-remote-{0}.sh" -f [guid]::NewGuid().ToString('N'))
  [System.IO.File]::WriteAllText($tempScript, $normalized, [System.Text.UTF8Encoding]::new($false))
  try {
    & scp @scpArgs $tempScript "$($vps.SshHost):/tmp/expansion-remote.sh"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    & ssh @scpArgs $vps.SshHost 'bash /tmp/expansion-remote.sh; rm -f /tmp/expansion-remote.sh'
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
  } finally {
    Remove-Item -Force $tempScript -ErrorAction SilentlyContinue
  }
}

function Write-UnixTextFile {
  param([Parameter(Mandatory)][string]$Path, [Parameter(Mandatory)][string]$Content)
  $normalized = ($Content -replace "`r", '').TrimEnd() + "`n"
  [System.IO.File]::WriteAllText($Path, $normalized, [System.Text.UTF8Encoding]::new($false))
}

if (-not (Test-Path $vps.SshIdentityFile)) {
  Write-Error "Missing SSH key: $($vps.SshIdentityFile)"
}

# --- sync code ---
$items = @('api', 'migrations', 'scripts', 'content', 'package.json', 'package-lock.json')
& ssh @scpArgs $vps.SshHost "mkdir -p $remoteDir"
foreach ($item in $items) {
  $src = Join-Path $here $item
  if (Test-Path $src) {
    & scp @scpArgs -r $src "$($vps.SshHost):$remoteDir/"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
  }
}
& scp @scpArgs (Join-Path $here 'deploy\ecosystem.config.cjs') "$($vps.SshHost):$remoteDir/ecosystem.config.cjs"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

# --- .env: secrets локально или синк SMTP с Beget danilagames ---
if (Test-Path $secrets) {
  & scp @scpArgs $secrets "$($vps.SshHost):$remoteDir/.env"
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
} else {
  Write-Host 'No deploy/secrets/expansion-api.env — merge SMTP from Beget into server .env'
  $smtpFragment = Join-Path $env:TEMP 'expansion-smtp-fragment.env'
  $smtpLines = & ssh @scpArgs $beget.SshHost "grep -E '^(SMTP_|EMAIL_FROM=)' $($beget.DanilagamesRoot)/.env 2>/dev/null || true"
  $smtpText = ($smtpLines | ForEach-Object { $_.TrimEnd("`r") }) -join "`n"
  if ($smtpText.Trim().Length -gt 0) {
    Write-UnixTextFile -Path $smtpFragment -Content $smtpText
    & scp @scpArgs $smtpFragment "$($vps.SshHost):/tmp/expansion-smtp-fragment.env"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    $merge = @'
set -e
ENV=/opt/expansion-api/.env
test -f "$ENV" || exit 0
while IFS= read -r line || [ -n "$line" ]; do
  key="${line%%=*}"
  [ -z "$key" ] && continue
  if grep -q "^${key}=" "$ENV"; then
    sed -i "s|^${key}=.*|${line}|" "$ENV"
  else
    echo "$line" >> "$ENV"
  fi
done < /tmp/expansion-smtp-fragment.env
rm -f /tmp/expansion-smtp-fragment.env
'@
    Invoke-RemoteBash -Script $merge
  }
  Remove-Item -Force $smtpFragment -ErrorAction SilentlyContinue
}

# --- install, migrate, pm2 ---
$remote = @"
set -e
cd $remoteDir
npm install --omit=dev
node scripts/migrate.js
pm2 delete expansion-api 2>/dev/null || true
pm2 start ecosystem.config.cjs
pm2 save
"@

Invoke-RemoteBash -Script $remote

Write-Host 'Done: expansion-api deployed on VPS.'
