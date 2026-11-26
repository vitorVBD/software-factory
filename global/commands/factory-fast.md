# Execução Rápida (Fast-Track) — Software Factory

Tarefa ou escopo:

$ARGUMENTS

Modo enxuto para tarefas padrão sem alto risco arquitetural. Não crie nem preencha os templates 02 a 08.

1. Leia `docs/ai/conventions.md`, `docs/ai/design-system.md` e, se `$ARGUMENTS` informar um `TASK-ID`, leia `docs/ai/tasks/<TASK-ID>/00-overview.md` e `01-requirements.md`.
2. **Plano relâmpago:** Apresente em no máximo 6 linhas quais arquivos de `backend/` e `frontend/` serão criados/alterados e aguarde um simples "ok" do usuário.
3. **Implementação direta:** Após o "ok", implemente o código diretamente respeitando os padrões existentes no projeto (sem delegar para múltiplos subagentes).
4. **Verificação mínima:** Rode apenas o linter/typecheck/build rápido afetado (se houver) e confira se não há erros de sintaxe ou segurança óbvios.
5. Atualize apenas o status em `00-overview.md` para `DONE` e apresente um resumo curto dos arquivos alterados.