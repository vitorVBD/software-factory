#!/usr/bin/env bash
set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CURSOR_DIR="$HOME/.cursor"

echo "Instalando Software Factory em $CURSOR_DIR..."

mkdir -p "$CURSOR_DIR/agents" "$CURSOR_DIR/commands" "$CURSOR_DIR/skills" "$CURSOR_DIR/factory-templates"

cp -rf "$ROOT_DIR/global/agents/." "$CURSOR_DIR/agents/"
cp -rf "$ROOT_DIR/global/commands/." "$CURSOR_DIR/commands/"
cp -rf "$ROOT_DIR/global/skills/." "$CURSOR_DIR/skills/"
cp -rf "$ROOT_DIR/templates/." "$CURSOR_DIR/factory-templates/"

chmod +x "$CURSOR_DIR/factory-templates/scripts/"*.sh 2>/dev/null || true

echo "Instalação concluída com sucesso!"
echo "Passo manual no Cursor: copie o conteúdo de 'global/GLOBAL-RULE.md' e cole em Cursor Settings -> Rules -> User Rules."