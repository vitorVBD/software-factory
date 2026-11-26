# Execução Rápida (Fast-Track) — Software Factory

Tarefa ou escopo:

$ARGUMENTS

Use este fluxo somente para mudanças **isoladas e de baixo risco**. O Fast-Track reduz delegações e documentação; não reduz os critérios mínimos de segurança, testes. Utilize esse fluxo em caso de aprovação humana direta mas avise sobre os riscos.

1. **Carregue o contexto:** leia `AGENTS.md` e, quando existirem e forem relevantes, `docs/ai/project-profile.md`, `architecture.md`, `business-rules.md`, `conventions.md`, `design-system.md`, `security-posture.md` e `quality-strategy.md`. Se houver `TASK-ID`, leia também `docs/ai/tasks/<TASK-ID>/00-overview.md` e `01-requirements.md`.
2. **Faça o Risk Gate antes de planejar a implementação.** Classifique o risco como `LOW`, `MEDIUM` ou `HIGH`, justificando a classificação. Só continue se for claramente `LOW`. Na dúvida, classifique como `MEDIUM` e encaminhe para `/factory-feature` ou `/factory-hotfix`.
3. **Considere no mínimo MEDIUM/HIGH** qualquer mudança que envolva autenticação/autorização, permissões ou isolamento de tenant; dados pessoais, financeiros ou sensíveis; pagamentos; schema, migrations ou integridade de dados; exclusão/exportação em massa; uploads; criptografia/segredos; integrações externas/webhooks; infraestrutura, CI/CD ou produção; dependências com impacto de segurança; ou lógica de negócio que altere acesso ou valores. A lista é indicativa, não exaustiva.
4. **Plano relâmpago:** para risco `LOW`, apresente em até 6 linhas: escopo exato, arquivos prováveis, motivo da classificação, critérios de aceite e verificações que serão executadas. Aguarde aprovação explícita do usuário para aquele escopo. Um “ok” anterior ou referente a outra tarefa não vale.
5. **Implementação:** após a aprovação, implemente somente o escopo aprovado, sem delegar para múltiplos subagentes. Se descobrir risco novo, necessidade de ampliar escopo ou impacto fora do previsto, pare e solicite autorização ou migre para o fluxo completo. Não faça commit, push, merge, release ou deploy.
6. **Verificação:** descubra os comandos reais do projeto e execute os testes relevantes para o comportamento alterado. Execute também lint, typecheck e build quando aplicáveis. Lint/build não substituem testes de comportamento. Não invente comandos nem declare verificações não executadas como aprovadas.
7. **Resultado e status:** reporte arquivos alterados, risco final, comandos executados, evidências e limitações. Use `PASS`, `FAIL`, `BLOCKED` ou `NOT RUN` para cada verificação. Se existir `TASK-ID`, atualize somente `00-overview.md`; não crie os artefatos `02` a `08`. Após implementação e verificações obrigatórias aprovadas, use `AWAITING_HUMAN_RELEASE_DECISION`, nunca `DONE` automaticamente. Se houver falha ou verificação obrigatória não executada, use o status de bloqueio/retrabalho apropriado e explique o motivo.

**Limite do Fast-Track:** este caminho não executa revisões independentes de Tech Lead, Security ou QA. Não apresente o resultado como aprovação completa da Software Factory. Qualquer mudança fora de baixo risco deve seguir o fluxo completo.
