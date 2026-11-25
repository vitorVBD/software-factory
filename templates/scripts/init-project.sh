#!/usr/bin/env bash
set -e

PROJECT_PATH="$1"
PROJECT_NAME="${2:-$(basename "$PROJECT_PATH")}"
TEMPLATES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ -z "$PROJECT_PATH" ] || [ ! -d "$PROJECT_PATH" ]; then
  echo "Uso: ./init-project.sh <caminho-do-projeto> [NomeDoProjeto]"
  exit 1
fi

echo "Preparando Software Factory em: $PROJECT_PATH ($PROJECT_NAME)"

mkdir -p "$PROJECT_PATH/.cursor/rules" "$PROJECT_PATH/docs/ai"

# Copia apenas se não existir (equivalente ao init-project.ps1 sem -Force)
cp -rn "$TEMPLATES_DIR/.cursor/rules/." "$PROJECT_PATH/.cursor/rules/"
cp -rn "$TEMPLATES_DIR/docs/ai/." "$PROJECT_PATH/docs/ai/"
[ ! -f "$PROJECT_PATH/AGENTS.md" ] && cp "$TEMPLATES_DIR/AGENTS.md" "$PROJECT_PATH/AGENTS.md"

echo "Projeto preparado com sucesso. Abra no Cursor e execute /factory-onboard ou /factory-new."