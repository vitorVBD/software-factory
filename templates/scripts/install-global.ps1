[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$factoryRoot = Split-Path -Parent $PSScriptRoot
if (-not $env:USERPROFILE) { throw 'USERPROFILE não foi encontrado. Execute no Windows com perfil de usuário carregado.' }
$cursorHome = Join-Path $env:USERPROFILE '.cursor'

$maps = @(
    @{ Source = Join-Path $factoryRoot 'global/agents';   Target = Join-Path $cursorHome 'agents';   Label = 'Subagents globais' },
    @{ Source = Join-Path $factoryRoot 'global/skills';   Target = Join-Path $cursorHome 'skills';   Label = 'Skills globais' },
    @{ Source = Join-Path $factoryRoot 'global/commands'; Target = Join-Path $cursorHome 'commands'; Label = 'Comandos globais' },
    @{ Source = Join-Path $factoryRoot 'global/rules';    Target = Join-Path $cursorHome 'rules';    Label = 'Regras locais do self-hosted worker' }
)

$installed = 0; $skipped = 0; $backedUp = 0
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
foreach ($map in $maps) {
    if (-not (Test-Path -LiteralPath $map.Source -PathType Container)) { throw "Origem não encontrada: $($map.Source)" }
    Get-ChildItem -LiteralPath $map.Source -File -Recurse | ForEach-Object {
        $relative = $_.FullName.Substring($map.Source.Length).TrimStart([char[]]@([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar))
        $destination = Join-Path $map.Target $relative
        $destinationDir = Split-Path -Parent $destination
        if (Test-Path -LiteralPath $destination -PathType Leaf) {
            if (-not $Force) {
                Write-Host "SKIP (já existe): $destination" -ForegroundColor Yellow
                $script:skipped++
                return
            }
            $backup = "$destination.bak.$stamp"
            if ($PSCmdlet.ShouldProcess($destination, "Criar backup em $backup")) {
                Copy-Item -LiteralPath $destination -Destination $backup
                $script:backedUp++
            }
        }
        if ($PSCmdlet.ShouldProcess($destination, "Instalar $($map.Label)")) {
            New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
            Copy-Item -LiteralPath $_.FullName -Destination $destination -Force
            Write-Host "INSTALADO: $destination" -ForegroundColor Green
            $script:installed++
        }
    }
}

Write-Host "`nResumo: instalados=$installed; ignorados=$skipped; backups=$backedUp" -ForegroundColor Cyan
Write-Host "Destino global: $cursorHome"
Write-Host 'Reabra o Cursor (ou recarregue a janela) para garantir que todas as configurações sejam detectadas.'
