#requires -Version 5.1
# Danila Games: сайт + admin SPA на Beget
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $PSScriptRoot
. (Join-Path $PSScriptRoot 'beget.config.ps1')
$cfg = $BegetConfig

$placeholder = Join-Path $here 'deploy\danilagames-placeholder'
$admin = Join-Path $here 'deploy\danilagames-admin'
$remoteRoot = '/home/a/autogie1/danilagames.ru/public_html'
$remoteAdmin = "$remoteRoot/admin"
$sshArgs = @('-o', 'ConnectTimeout=30', '-i', $cfg.SshIdentityFile, $cfg.SshHost)

function Send-File($LocalPath, $RemotePath) {
  $local = (Resolve-Path -LiteralPath $LocalPath).Path
  $target = '{0}:{1}' -f $cfg.SshHost, $RemotePath
  & scp -o ConnectTimeout=30 -i $cfg.SshIdentityFile $local $target
  if ($LASTEXITCODE -ne 0) { throw "scp failed: $LocalPath -> $RemotePath" }
}

& ssh @sshArgs "mkdir -p $remoteAdmin"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Send-File (Join-Path $placeholder 'index.html') "$remoteRoot/index.html"
Send-File (Join-Path $placeholder '.htaccess') "$remoteRoot/.htaccess"
Send-File (Join-Path $placeholder 'site.css') "$remoteRoot/site.css"

foreach ($file in @('favicon.ico', 'favicon.svg', 'favicon-32.png', 'favicon-192.png', 'apple-touch-icon.png')) {
  Send-File (Join-Path $placeholder $file) "$remoteRoot/$file"
}

& ssh @sshArgs "mkdir -p $remoteRoot/expansion/screens"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

foreach ($file in @(
  'index.html', 'en.html', 'icon.jpg', 'carousel.js',
  'favicon.ico', 'favicon-32.png', 'favicon-192.png', 'apple-touch-icon.png'
)) {
  Send-File (Join-Path $placeholder "expansion\$file") "$remoteRoot/expansion/$file"
}

foreach ($file in Get-ChildItem (Join-Path $placeholder 'expansion\screens\*.jpg')) {
  Send-File $file.FullName "$remoteRoot/expansion/screens/$($file.Name)"
}

foreach ($file in @('legal.css', 'privacy-ru.html', 'privacy-en.html', 'support-ru.html', 'support-en.html', 'account-deletion-ru.html', 'account-deletion-en.html')) {
  Send-File (Join-Path $placeholder $file) "$remoteRoot/$file"
}

foreach ($file in @('index.html', 'app.js', 'styles.css', 'config.js', 'api-proxy.php', '.php-version')) {
  Send-File (Join-Path $admin $file) "$remoteAdmin/$file"
}

# SPA: /admin/ → index.html
$htadmin = @'
DirectoryIndex index.html
Options -Indexes
<IfModule mod_rewrite.c>
  RewriteEngine On
  RewriteBase /admin/
  RewriteRule ^api/(.*)$ api-proxy.php [QSA,L,E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
  RewriteRule ^index\.html$ - [L]
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteCond %{REQUEST_FILENAME} !-d
  RewriteRule . /admin/index.html [L]
</IfModule>

<IfModule mod_setenvif.c>
  SetEnvIf Authorization "(.*)" HTTP_AUTHORIZATION=$1
</IfModule>
'@
$htTemp = Join-Path $env:TEMP 'danilagames-admin-htaccess'
Set-Content -Path $htTemp -Value $htadmin -Encoding ASCII -NoNewline
Send-File $htTemp "$remoteAdmin/.htaccess"
Remove-Item $htTemp -Force -ErrorAction SilentlyContinue

Write-Host 'Done: danilagames.ru site + /admin/ deployed.'
