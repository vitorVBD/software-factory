[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$ProjectPath,

    [string]$ProjectName,
    [switch]$Force,
    [switch]$IncludeProjectAgents,
    [switch]$IncludeProjectSkills
)

$ErrorActionPreference = 'Stop'
$factoryRoot = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path -LiteralPath $ProjectPath -PathType Container)) {
    throw "A pasta do projeto não existe: $ProjectPath"
}
$resolvedProject = (Resolve-Path -LiteralPath $ProjectPath).Path
if (-not $ProjectName) { $ProjectName = Split-Path -Leaf $resolvedProject }
$projectSlug = (($ProjectName.ToLowerInvariant() -replace '[^a-z0-9]+', '-').Trim('-'))
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$script:copied = 0; $script:skipped = 0; $script:backedUp = 0

function Copy-FactoryTree {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory=$true)][string]$Source,
        [Parameter(Mandatory=$true)][string]$Target,
        [switch]$ReplaceTokens
    )
    if (-not (Test-Path -LiteralPath $Source -PathType Container)) { throw "Template não encontrado: $Source" }
    Get-ChildItem -LiteralPath $Source -File -Recurse -Force | ForEach-Object {
        $relative = $_.FullName.Substring($Source.Length).TrimStart([char[]]@([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar))
        $destination = Join-Path $Target $relative
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
        if ($PSCmdlet.ShouldProcess($destination, 'Copiar template')) {
            New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
            if ($ReplaceTokens -and $_.Extension -in @('.md', '.mdc', '.txt')) {
                $content = [IO.File]::ReadAllText($_.FullName)
                $content = $content.Replace('{{PROJECT_NAME}}', $ProjectName).Replace('{{PROJECT_SLUG}}', $projectSlug)
                [IO.File]::WriteAllText($destination, $content, (New-Object System.Text.UTF8Encoding($false)))
            } else {
                Copy-Item -LiteralPath $_.FullName -Destination $destination -Force
            }
            Write-Host "COPIADO: $destination" -ForegroundColor Green
            $script:copied++
        }
    }
}

Copy-FactoryTree -Source (Join-Path $factoryRoot 'templates/project') -Target $resolvedProject -ReplaceTokens

if ($IncludeProjectAgents) {
    Copy-FactoryTree -Source (Join-Path $factoryRoot 'global/agents') -Target (Join-Path $resolvedProject '.cursor/agents')
}
if ($IncludeProjectSkills) {
    Copy-FactoryTree -Source (Join-Path $factoryRoot 'global/skills') -Target (Join-Path $resolvedProject '.cursor/skills')
}

New-Item -ItemType Directory -Path (Join-Path $resolvedProject 'docs/ai/tasks') -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $resolvedProject 'docs/ai/adr') -Force | Out-Null
Write-Host "`nProjeto preparado: $resolvedProject" -ForegroundColor Cyan
Write-Host "Resumo: copiados=$script:copied; ignorados=$script:skipped; backups=$script:backedUp"
Write-Host 'Próximo passo: abra este repositório no Cursor e execute /factory-onboard.'
if (-not $IncludeProjectAgents) { Write-Host 'Subagents serão obtidos da instalação global do Cursor Editor.' }
