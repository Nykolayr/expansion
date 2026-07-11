# Как redmobi_vps/scripts/vps.config.ps1 — тот же VPS Beget Cloud
$VpsConfig = @{
  SshHost         = 'root@46.173.25.193'
  SshIdentityFile = Join-Path $env:USERPROFILE '.ssh\redmobi_beget_ed25519'
  RemoteRoot      = '/opt/expansion-api'
}
