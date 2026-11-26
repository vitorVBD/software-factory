#!/usr/bin/env bash
set -Eeuo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
SOURCE_SCRIPT="$REPO_ROOT/templates/scripts/init-project.sh"
[[ -f "$SOURCE_SCRIPT" ]] || { echo "ERRO: script não encontrado: $SOURCE_SCRIPT" >&2; exit 1; }

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
FACTORY="$TMP_DIR/factory"
PROJECT="$TMP_DIR/project with spaces"

mkdir -p \
  "$FACTORY/templates/scripts" \
  "$FACTORY/templates/templates/project/.cursor/rules" \
  "$FACTORY/templates/templates/project/docs/ai" \
  "$FACTORY/templates/global/agents" \
  "$FACTORY/templates/global/skills/demo"
mkdir -p "$PROJECT"
cp "$SOURCE_SCRIPT" "$FACTORY/templates/scripts/init-project.sh"

cat > "$FACTORY/templates/templates/project/AGENTS.md" <<'TEMPLATE'
Project: {{PROJECT_NAME}}
Slug: {{PROJECT_SLUG}}
TEMPLATE
cat > "$FACTORY/templates/templates/project/.cursor/rules/sample.mdc" <<'TEMPLATE'
name: {{PROJECT_SLUG}}
description: {{PROJECT_NAME}}
TEMPLATE
cat > "$FACTORY/templates/templates/project/docs/ai/README.md" <<'TEMPLATE'
# {{PROJECT_NAME}}
TEMPLATE
printf '<svg>unchanged</svg>\n' > "$FACTORY/templates/templates/project/logo.svg"
printf '# Agent template\n' > "$FACTORY/templates/global/agents/demo.md"
printf '# Skill template\n' > "$FACTORY/templates/global/skills/demo/SKILL.md"

PROJECT_NAME='My Project & R&D | Web'
PROJECT_SLUG='my-project-r-d-web'
bash "$FACTORY/templates/scripts/init-project.sh" "$PROJECT" "$PROJECT_NAME" > "$TMP_DIR/first-run.log"

grep -Fqx "Project: $PROJECT_NAME" "$PROJECT/AGENTS.md"
grep -Fqx "Slug: $PROJECT_SLUG" "$PROJECT/AGENTS.md"
grep -Fqx "name: $PROJECT_SLUG" "$PROJECT/.cursor/rules/sample.mdc"
grep -Fqx "description: $PROJECT_NAME" "$PROJECT/.cursor/rules/sample.mdc"
grep -Fqx "# $PROJECT_NAME" "$PROJECT/docs/ai/README.md"
grep -Fqx '<svg>unchanged</svg>' "$PROJECT/logo.svg"
[[ -d "$PROJECT/docs/ai/tasks" ]]
[[ -d "$PROJECT/docs/ai/adr" ]]

# Existing files must be preserved unless --force is explicitly supplied.
printf 'custom user content\n' > "$PROJECT/AGENTS.md"
bash "$FACTORY/templates/scripts/init-project.sh" "$PROJECT" "$PROJECT_NAME" > "$TMP_DIR/second-run.log"
grep -Fqx 'custom user content' "$PROJECT/AGENTS.md"
grep -Fq 'SKIP (já existe)' "$TMP_DIR/second-run.log"

# --force must back up the previous file and replace it with the rendered template.
bash "$FACTORY/templates/scripts/init-project.sh" \
  --project-path "$PROJECT" \
  --project-name "$PROJECT_NAME" \
  --force \
  --include-project-agents \
  --include-project-skills > "$TMP_DIR/force-run.log"
BACKUP="$(find "$PROJECT" -maxdepth 1 -type f -name 'AGENTS.md.bak.*' -print -quit)"
[[ -n "$BACKUP" && -f "$BACKUP" ]]
grep -Fqx 'custom user content' "$BACKUP"
grep -Fqx "Project: $PROJECT_NAME" "$PROJECT/AGENTS.md"
[[ -f "$PROJECT/.cursor/agents/demo.md" ]]
[[ -f "$PROJECT/.cursor/skills/demo/SKILL.md" ]]

grep -Fq 'Resumo:' "$TMP_DIR/force-run.log"
bash "$FACTORY/templates/scripts/init-project.sh" --help >/dev/null

if bash "$FACTORY/templates/scripts/init-project.sh" "$TMP_DIR/does-not-exist" >/dev/null 2>&1; then
  echo 'ERRO: caminho inexistente deveria falhar.' >&2
  exit 1
fi

echo 'PASS: init-project.sh — cópia, tokens, preservação, backup, opções e validação de caminho.'
