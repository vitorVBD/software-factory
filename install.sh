#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CURSOR_DIR="$HOME/.cursor"

required_paths=(
  "$ROOT_DIR/global/agents"
  "$ROOT_DIR/global/commands"
  "$ROOT_DIR/global/skills"
  "$ROOT_DIR/templates"
  "$ROOT_DIR/global/global/GLOBAL-RULE.md"
)
for path in "${required_paths[@]}"; do
  if [[ ! -e "$path" ]]; then
    printf 'ERRO: arquivo ou diretório obrigatório não encontrado: %s\n' "$path" >&2
    exit 1
  fi
done

printf 'Instalando Software Factory em %s...\n' "$CURSOR_DIR"
mkdir -p "$CURSOR_DIR/agents" "$CURSOR_DIR/commands" "$CURSOR_DIR/skills" "$CURSOR_DIR/factory-templates"
cp -rf "$ROOT_DIR/global/agents/." "$CURSOR_DIR/agents/"
cp -rf "$ROOT_DIR/global/commands/." "$CURSOR_DIR/commands/"
cp -rf "$ROOT_DIR/global/skills/." "$CURSOR_DIR/skills/"
cp -rf "$ROOT_DIR/templates/." "$CURSOR_DIR/factory-templates/"

for script in "$CURSOR_DIR/factory-templates/scripts/"*.sh; do
  [[ -f "$script" ]] && chmod +x "$script"
done

printf '\nInstalação concluída com sucesso!\n'
printf 'Regra global: %s\n' "$ROOT_DIR/global/global/GLOBAL-RULE.md"
printf 'No Cursor, copie o conteúdo dessa regra para Settings -> Rules -> User Rules.\n'
