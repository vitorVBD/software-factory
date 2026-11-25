# Instruções do projeto — {{PROJECT_NAME}}

Este arquivo contém instruções locais deste repositório. A Software Factory global fornece os papéis e o fluxo; este arquivo e `docs/ai/` fornecem a verdade específica deste produto.

## Antes de qualquer tarefa

1. Leia `docs/ai/project-profile.md`.
2. Leia os documentos relevantes: `architecture.md`, `business-rules.md`, `design-system.md`, `conventions.md`, `security-posture.md` e `quality-strategy.md`.
3. Inspecione o código atual e os manifests. Não assuma que este documento está atualizado sem conferir.
4. Preserve a stack, decisões, padrões e design system existentes. Não importe convenções de outros produtos.
5. Marque lacunas como desconhecidas; nunca invente rotas, tabelas, versões, scripts ou regras.

## Regras locais

- O modo de trabalho é supervisionado: apresente plano e aguarde aprovação humana explícita antes de alterações de código.
- Não faça commit, push, merge, release, deploy, migration destrutiva nem alteração em produção sem aprovação explícita.
- Security e QA são revisores independentes; uma reprovação bloqueia a recomendação de conclusão.
- Testes, scans e builds só podem ser declarados executados quando houver evidência da execução.
- Não exponha credenciais, dados pessoais ou dumps reais em prompts, fixtures, logs ou relatórios.

## Fonte de verdade

Priorize código, testes, schemas e configurações atuais; em seguida, documentação do projeto. Quando houver divergência material, reporte-a e peça decisão. Não altere este arquivo ou os documentos de contexto automaticamente para encobrir divergências.
