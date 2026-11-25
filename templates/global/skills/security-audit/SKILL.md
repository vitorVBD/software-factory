---
name: security-audit
description: Executa auditoria de AppSec somente leitura em alterações de software, APIs e integrações, com classificação de risco e evidências reproduzíveis.
---

# Security Audit

1. Confirme escopo e diff.
2. Mapeie ativos, papéis, autorização, tenant boundaries e inputs.
3. Analise OWASP Top 10/API, injection, XSS, CSRF, SSRF, IDOR/BOLA, secrets, uploads, dependências, logs e configuração conforme aplicabilidade.
4. Procure validação e autorização no servidor.
5. Use ferramentas instaladas/localmente e seguras; não envie código ou dados para serviços não aprovados.
6. Não teste produção nem execute exploração destrutiva.
7. Registre achados com severidade, confiança, arquivo/linha, evidência, impacto e remediação.
8. Retorne PASS/FAIL/BLOCKED e áreas não avaliadas.
9. Não modifique arquivos nem corrija achados.
