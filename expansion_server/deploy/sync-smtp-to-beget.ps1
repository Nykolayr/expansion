#requires -Version 5.1
# Обновляет SMTP_* в danilagames .env на Beget из рабочего Joy Pick VPS.
$ErrorActionPreference = 'Stop'
$joyKey = Join-Path $env:USERPROFILE '.ssh\id_ed25519'
$begetKey = Join-Path $env:USERPROFILE '.ssh\redmobi_beget_ed25519'
$joyHost = 'root@45.84.225.22'
$begetHost = 'autogie1@autogie1.beget.tech'
$begetEnv = '~/danilagames.ru/public_html/.env'
$frag = Join-Path $env:TEMP 'danilagames-smtp-from-joypick.env'

$smtpLines = & ssh -o ConnectTimeout=15 -i $joyKey $joyHost "grep -E '^(SMTP_|EMAIL_FROM=)' /opt/joypick/.env"
$text = (($smtpLines | ForEach-Object { $_.TrimEnd("`r") }) -join "`n") + "`n"
[System.IO.File]::WriteAllText($frag, $text, [System.Text.UTF8Encoding]::new($false))

& scp -o ConnectTimeout=15 -i $begetKey $frag "${begetHost}:/tmp/smtp.env"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$remote = @'
set -e
ENV=~/danilagames.ru/public_html/.env
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
echo 'Beget danilagames SMTP updated'
'@

$tempScript = Join-Path $env:TEMP "beget-smtp-sync-$(Get-Random).sh"
[System.IO.File]::WriteAllText($tempScript, ($remote -replace "`r", '').TrimEnd() + "`n", [System.Text.UTF8Encoding]::new($false))
& scp -o ConnectTimeout=15 -i $begetKey $tempScript "${begetHost}:/tmp/sync-smtp-run.sh"
& ssh -o ConnectTimeout=15 -i $begetKey $begetHost 'bash /tmp/sync-smtp-run.sh; rm -f /tmp/sync-smtp-run.sh'
Remove-Item -Force $tempScript -ErrorAction SilentlyContinue
