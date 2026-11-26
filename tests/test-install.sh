#!/usr/bin/env bash
set -Eeuo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

FIXTURE="$TMP_DIR/repo"
HOME_FIXTURE="$TMP_DIR/home"
mkdir -p "$FIXTURE/global/agents" "$FIXTURE/global/commands" "$FIXTURE/global/skills/example" \
  "$FIXTURE/global/global" "$FIXTURE/templates/scripts" "$HOME_FIXTURE"
cp "$REPO_ROOT/install.sh" "$FIXTURE/install.sh"
printf '# rule\n' > "$FIXTURE/global/global/GLOBAL-RULE.md"
printf '# agent\n' > "$FIXTURE/global/agents/example.md"
printf '# command\n' > "$FIXTURE/global/commands/example.md"
printf '# skill\n' > "$FIXTURE/global/skills/example/SKILL.md"
printf '# template\n' > "$FIXTURE/templates/example.txt"

HOME="$HOME_FIXTURE" bash "$FIXTURE/install.sh" > "$TMP_DIR/install.log"
[[ -f "$HOME_FIXTURE/.cursor/agents/example.md" ]]
[[ -f "$HOME_FIXTURE/.cursor/commands/example.md" ]]
[[ -f "$HOME_FIXTURE/.cursor/skills/example/SKILL.md" ]]
[[ -f "$HOME_FIXTURE/.cursor/factory-templates/example.txt" ]]
grep -Fq "$FIXTURE/global/global/GLOBAL-RULE.md" "$TMP_DIR/install.log"

# The installer must fail early when a required rule is missing.
rm -f "$FIXTURE/global/global/GLOBAL-RULE.md"
if HOME="$TMP_DIR/second-home" bash "$FIXTURE/install.sh" >/dev/null 2>&1; then
  echo 'ERRO: instalação deveria falhar quando a regra global não existe.' >&2
  exit 1
fi

printf 'PASS: install.sh — cópia de agentes/commands/skills/templates e validação da regra global.\n'
