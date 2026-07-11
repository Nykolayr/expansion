#requires -Version 5.1
# Заглушка danilagames.ru — как redmobi deploy-beget.ps1 (SSH-ключ, без пароля)
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $PSScriptRoot
. (Join-Path $PSScriptRoot 'beget.config.ps1')
$cfg = $BegetConfig

$placeholder = Join-Path $here 'deploy\danilagames-placeholder'
$dest = "$($cfg.DanilagamesRoot)/"
$scpArgs = @('-o', 'ConnectTimeout=30', '-i', $cfg.SshIdentityFile)

& ssh @scpArgs $cfg.SshHost "cd $($cfg.DanilagamesRoot) && if [ -f .htaccess ] && ! grep -q 'DirectoryIndex index.html' .htaccess 2>/dev/null; then cp .htaccess .htaccess.joypick-proxy.bak; fi"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

& scp @scpArgs (Join-Path $placeholder 'index.html') "${cfg.SshHost}:${dest}index.html"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

& scp @scpArgs (Join-Path $placeholder '.htaccess') "${cfg.SshHost}:${dest}.htaccess"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host 'Done: danilagames.ru placeholder deployed.'
