$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$cursorDir = Join-Path $env:USERPROFILE '.cursor'
$globalRule = Join-Path $root 'global\global\GLOBAL-RULE.md'

$requiredPaths = @(
    (Join-Path $root 'global\agents'),
    (Join-Path $root 'global\commands'),
    (Join-Path $root 'global\skills'),
    (Join-Path $root 'templates'),
    $globalRule
)
foreach ($path in $requiredPaths) {
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Arquivo ou diretório obrigatório não encontrado: $path"
    }
}

Write-Host "Instalando Software Factory em $cursorDir..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path `
    (Join-Path $cursorDir 'agents'), `
    (Join-Path $cursorDir 'commands'), `
    (Join-Path $cursorDir 'skills'), `
    (Join-Path $cursorDir 'factory-templates') | Out-Null

Copy-Item (Join-Path $root 'global\agents\*') (Join-Path $cursorDir 'agents\') -Recurse -Force
Copy-Item (Join-Path $root 'global\commands\*') (Join-Path $cursorDir 'commands\') -Recurse -Force
Copy-Item (Join-Path $root 'global\skills\*') (Join-Path $cursorDir 'skills\') -Recurse -Force
Copy-Item (Join-Path $root 'templates\*') (Join-Path $cursorDir 'factory-templates\') -Recurse -Force

Write-Host "`nInstalação concluída com sucesso!" -ForegroundColor Green
Write-Host "Regra global: $globalRule" -ForegroundColor Cyan
Write-Host 'No Cursor, copie o conteúdo dessa regra para Settings -> Rules -> User Rules.' -ForegroundColor Yellow
