# Beget — тот же аккаунт autogie1, ключ redmobi_beget_ed25519 (как redmobi_server/deploy-beget.ps1)
$BegetConfig = @{
  SshHost         = 'autogie1@autogie1.beget.tech'
  SshIdentityFile = Join-Path $env:USERPROFILE '.ssh\redmobi_beget_ed25519'
  DanilagamesRoot = '~/danilagames.ru/public_html'
}
