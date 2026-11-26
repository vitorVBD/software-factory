#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
AGENTS=(tech-lead security-engineer qa-engineer)
EXPECTED='RESULT: <PASS|FAIL|BLOCKED|NOT RUN>'

for agent in "${AGENTS[@]}"; do
  global_file="$ROOT/global/agents/$agent.md"
  template_file="$ROOT/templates/global/agents/$agent.md"
  [[ -f "$global_file" && -f "$template_file" ]] || {
    echo "ERRO: agente ou cópia de template ausente: $agent" >&2
    exit 1
  }
  grep -Fq "$EXPECTED" "$global_file" || {
    echo "ERRO: contrato RESULT ausente em $global_file" >&2
    exit 1
  }
  cmp -s "$global_file" "$template_file" || {
    echo "ERRO: cópia divergente entre global e templates: $agent" >&2
    exit 1
  }
done

if grep -Eq 'Retorne APPROVED|Retorne CHANGES_REQUIRED' "$ROOT/global/agents/tech-lead.md"; then
  echo 'ERRO: Tech Lead ainda usa resultados legados.' >&2
  exit 1
fi

grep -Fq 'Risk Gate' "$ROOT/global/commands/factory-fast.md"
grep -Fq 'AWAITING_HUMAN_RELEASE_DECISION' "$ROOT/global/commands/factory-fast.md"

echo 'PASS: contratos Tech Lead/Security/QA sincronizados e Fast-Track com Risk Gate.'
