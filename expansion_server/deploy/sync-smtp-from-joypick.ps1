#requires -Version 5.1
# Копирует рабочий SMTP с Joy Pick VPS на Expansion VPS.
$ErrorActionPreference = 'Stop'
$joyKey = Join-Path $env:USERPROFILE '.ssh\id_ed25519'
$expKey = Join-Path $env:USERPROFILE '.ssh\redmobi_beget_ed25519'
$joyHost = 'root@45.84.225.22'
$expHost = 'root@46.173.25.193'
$frag = Join-Path $env:TEMP 'expansion-smtp-from-joypick.env'

if (-not (Test-Path $joyKey)) { throw "Missing key: $joyKey" }
if (-not (Test-Path $expKey)) { throw "Missing key: $expKey" }

$smtpLines = & ssh -o ConnectTimeout=15 -i $joyKey $joyHost "grep -E '^(SMTP_|EMAIL_FROM=)' /opt/joypick/.env"
if (-not $smtpLines) { throw 'No SMTP lines from Joy Pick' }

$text = (($smtpLines | ForEach-Object { $_.TrimEnd("`r") }) -join "`n") + "`n"
[System.IO.File]::WriteAllText($frag, $text, [System.Text.UTF8Encoding]::new($false))

& scp -o ConnectTimeout=15 -i $expKey $frag "${expHost}:/tmp/smtp.env"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$remote = @'
set -e
ENV=/opt/expansion-api/.env
FRAG=/tmp/smtp.env
sed -i 's/\r$//' "$FRAG"
while IFS= read -r line || [ -n "$line" ]; do
  key="${line%%=*}"
  [ -z "$key" ] && continue
  if grep -q "^${key}=" "$ENV"; then
    sed -i "s|^${key}=.*|${line}|" "$ENV"
  else
    echo "$line" >> "$ENV"
  fi
done < "$FRAG"
rm -f "$FRAG"
cd /opt/expansion-api
node scripts/test-smtp.js
pm2 restart expansion-api --update-env
sleep 2
curl -s http://127.0.0.1:3000/api/health
'@

$tempScript = Join-Path $env:TEMP "expansion-smtp-sync-$(Get-Random).sh"
[System.IO.File]::WriteAllText($tempScript, ($remote -replace "`r", '').TrimEnd() + "`n", [System.Text.UTF8Encoding]::new($false))
& scp -o ConnectTimeout=15 -i $expKey $tempScript "${expHost}:/tmp/sync-smtp-run.sh"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& ssh -o ConnectTimeout=15 -i $expKey $expHost 'bash /tmp/sync-smtp-run.sh; rm -f /tmp/sync-smtp-run.sh'
Remove-Item -Force $tempScript -ErrorAction SilentlyContinue
