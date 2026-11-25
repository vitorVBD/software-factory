# Operating Model — Software Factory

## Responsabilidades e separação de funções

| Papel | Pode editar código de produto? | Pode aprovar o próprio trabalho? |
|---|---:|---:|
| Agent principal / Orchestrator | Somente quando a tarefa exige e após aprovação; delegar implementação preferencialmente | Não substitui gates |
| Product Owner | Não | Não aprova segurança/QA |
| Prompt Engineer | Não | Não |
| Architect | Não | Não |
| Developer | Sim, após checkpoint humano | Não |
| Tech Lead | Não | Não |
| Security Engineer | Não (`readonly`) | Aprova/reprova apenas auditoria de segurança |
| QA Engineer | Não (`readonly`) | Aprova/reprova apenas testes/qualidade |
| UX/UI, Database, DevOps, Debugger | Não (`readonly`) | Recomendam dentro do seu domínio |

## Estados recomendados

`DRAFT` → `DISCOVERY` → `PLANNING` → `AWAITING_HUMAN_APPROVAL` → `APPROVED_FOR_IMPLEMENTATION` → `IMPLEMENTING` → `TECH_REVIEW` → `SECURITY_QA` → `REWORK` (0–2 ciclos) → `PO_ACCEPTANCE` → `AWAITING_HUMAN_RELEASE_DECISION` → `DONE`.

Estados alternativos: `NEEDS_CLARIFICATION`, `BLOCKED`, `REJECTED`, `CANCELLED`.

## Semântica dos resultados

- `PASS`: verificação executada e aprovada.
- `FAIL`: verificação executada e encontrou defeito/risco bloqueador.
- `BLOCKED`: não foi possível validar por uma dependência ou impedimento.
- `NOT RUN`: verificação não foi executada.

`BLOCKED` e `NOT RUN` nunca contam como `PASS`.

## Gates

- Gate 1: plano documentado + aprovação humana explícita.
- Gate 2: implementação concluída + evidências de testes do Developer.
- Gate 3: Tech Lead sem blockers; Security PASS; QA PASS.
- Gate 4: PO recomenda aceite com critérios rastreados.
- Gate 5: usuário autoriza separadamente merge/release/deploy, se desejado.

## Iterações de correção

Até dois ciclos automáticos são permitidos. Um novo ciclo só começa com achados concretos, reproduzíveis e delimitados. Se o problema não for resolvido, peça decisão humana; não repita o mesmo processo indefinidamente.
