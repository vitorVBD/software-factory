---
name: release-readiness
description: Prepara checklist de prontidão para release/deploy com CI, migrations, backups, observabilidade, rollback e aprovação humana. Não executa publicação.
---

# Release Readiness

Verifique estado dos gates de produto, Tech Lead, Security e QA; changelog; build; configurações por ambiente; secrets; migrations; backup/restore; health checks; observabilidade; plano de rollback; comunicação e riscos conhecidos.

Retorne READY, NOT READY ou BLOCKED com evidências e pendências. Não faça commit, tag, push, merge, release ou deploy. Exija decisão humana explícita para qualquer ação de publicação.
