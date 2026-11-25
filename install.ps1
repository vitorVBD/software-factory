$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
$cursorDir = "$env:USERPROFILE\.cursor"

Write-Host "Instalando Software Factory em $cursorDir..." -ForegroundColor Cyan

# Garante que as pastas existem
New-Item -ItemType Directory -Force -Path "$cursorDir\agents", "$cursorDir\commands", "$cursorDir\skills", "$cursorDir\factory-templates" | Out-Null

# Copia agentes, comandos, skills e templates
Copy-Item "$root\global\agents\*" "$cursorDir\agents\" -Recurse -Force
Copy-Item "$root\global\commands\*" "$cursorDir\commands\" -Recurse -Force
Copy-Item "$root\global\skills\*" "$cursorDir\skills\" -Recurse -Force
Copy-Item "$root\templates\*" "$cursorDir\factory-templates\" -Recurse -Force

Write-Host "`nInstalacao concluida com sucesso!" -ForegroundColor Green
Write-Host "Unico passo manual no Cursor novo: copie o conteudo de 'global\GLOBAL-RULE.md' e cole em Cursor Settings -> Rules -> User Rules." -ForegroundColor Yellow