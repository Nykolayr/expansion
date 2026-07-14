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
  Write-Host 'No deploy/secrets/expansion-api.env — merge SMTP from Joy Pick VPS into server .env'
  $joyKey = Join-Path $env:USERPROFILE '.ssh\id_ed25519'
  $joyHost = 'root@45.84.225.22'
  $smtpFragment = Join-Path $env:TEMP 'expansion-smtp-fragment.env'
  if (Test-Path $joyKey) {
    $smtpLines = & ssh -o ConnectTimeout=30 -i $joyKey $joyHost "grep -E '^(SMTP_|EMAIL_FROM=|CALCULATOR_LEAD_TELEGRAM_|EXPANSION_TELEGRAM_)' /opt/joypick/.env 2>/dev/null || true"
  } else {
    Write-Host 'Joy Pick key missing — fallback to Beget danilagames .env'
    $smtpLines = & ssh @scpArgs $beget.SshHost "grep -E '^(SMTP_|EMAIL_FROM=|CALCULATOR_LEAD_TELEGRAM_|EXPANSION_TELEGRAM_)' $($beget.DanilagamesRoot)/.env 2>/dev/null || true"
  }
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
$remote = @'
set -e
cd REMOTE_DIR
npm install --omit=dev
node scripts/migrate.js
ENV=REMOTE_DIR/.env
for SRC in /opt/redmobi/freelancer-radar/.env /opt/redmobi/lead-bot/.env; do
  if [ -f "$SRC" ] && [ -f "$ENV" ]; then
    grep -E '^(TELEGRAM_BOT_TOKEN|TELEGRAM_CHAT_ID|CALCULATOR_LEAD_TELEGRAM_|EXPANSION_TELEGRAM_)=' "$SRC" 2>/dev/null || true
  fi
done | sort -u > /tmp/expansion-tg-fragment.env || true
if [ -s /tmp/expansion-tg-fragment.env ] && [ -f "$ENV" ]; then
  while IFS= read -r line || [ -n "$line" ]; do
    key="${line%%=*}"
    val="${line#*=}"
    [ -z "$key" ] || [ -z "$val" ] && continue
    if grep -q "^${key}=" "$ENV"; then
      sed -i "s|^${key}=.*|${line}|" "$ENV"
    else
      echo "$line" >> "$ENV"
    fi
  done < /tmp/expansion-tg-fragment.env
  rm -f /tmp/expansion-tg-fragment.env
fi
if [ -f "$ENV" ] && ! grep -qE '^TELEGRAM_CHAT_ID=.+' "$ENV"; then
  for CHATFILE in /opt/redmobi/kwork-radar/data/chat_id.txt /opt/redmobi/freelancer-radar/data/chat_id.txt /opt/redmobi/fl-radar/data/chat_id.txt; do
    if [ -s "$CHATFILE" ]; then
      CHAT_ID="$(tr -d '\r\n' < "$CHATFILE")"
      if grep -q '^TELEGRAM_CHAT_ID=' "$ENV"; then
        sed -i "s|^TELEGRAM_CHAT_ID=.*|TELEGRAM_CHAT_ID=${CHAT_ID}|" "$ENV"
      else
        echo "TELEGRAM_CHAT_ID=${CHAT_ID}" >> "$ENV"
      fi
      break
    fi
  done
fi
pm2 delete expansion-api 2>/dev/null || true
pm2 start ecosystem.config.cjs
pm2 save
'@ -replace 'REMOTE_DIR', $remoteDir

Invoke-RemoteBash -Script $remote

Write-Host 'Done: expansion-api deployed on VPS.'
