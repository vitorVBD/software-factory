# Gerar Backlog de Tarefas a partir do Roadmap — Software Factory

Contexto adicional e observações do usuário sobre o que já está concluído:

$ARGUMENTS

Atue como Orchestrator coordenando o `product-owner`. Não altere código de aplicação.

1. Leia `ROADMAP.md`, as observações acima (`$ARGUMENTS`) e os documentos de contexto em `docs/ai/` (`project-profile.md`, `architecture.md`, `business-rules.md`).
2. Audite cada item do `ROADMAP.md` cruzando:
   - Marcações explícitas no próprio arquivo (ex.: `[x]`, `✅`, `Concluído`, `Done`) e o que foi informado em `$ARGUMENTS`.
   - Evidências reais no código (`backend/` e `frontend/`).
3. Classifique os itens em três grupos:
   - **Concluídos:** Já marcados como feitos e confirmados no código. **Não crie pastas `TASK` para eles.**
   - **Divergentes / Parciais:** Marcados como concluídos no roadmap, mas incompletos no código (ou já prontos no código, mas desmarcados no roadmap). Crie `TASK` apenas para o que realmente falta implementar.
   - **Pendentes:** Itens ainda não iniciados.
4. Delegue ao `product-owner` a quebra apenas dos itens **Pendentes** e **Parciais** em tarefas atômicas, ordenadas por dependência técnica e prioridade de negócio.
5. Para cada tarefa a ser feita, crie `docs/ai/tasks/TASK-YYYYMMDD-###/` (sequencial, sem conflitar com pastas existentes) copiando os templates de `docs/ai/templates/task/` e substituindo `{{TASK_ID}}`, `{{TASK_TITLE}}` e `{{PROJECT_NAME}}`.
6. Preencha em cada tarefa apenas `00-overview.md` (status: `BACKLOG`, dependências e prioridade) e `01-requirements.md` (história, regras de negócio e critérios de aceitação), deixando o planejamento técnico (`02` e `03`) para quando a tarefa for puxada via `/factory-feature`.
7. Apresente ao final:
   - **Resumo do que foi ignorado (já concluído)** e eventuais divergências encontradas entre o `ROADMAP.md` e o código.
   - **Tabela do Backlog gerado:** `TASK ID`, `Título`, `Escopo (Backend/Frontend)`, `Dependências` e `Prioridade`.
   - Pergunte qual tarefa deseja detalhar tecnicamente primeiro.
8. Na tabela final do backlog, já inclua a coluna **Modo Recomendado** (`/factory-fast` para CRUDs/telas padrão ou `/factory-feature` para banco, auth, financeiro e arquitetura crítica) e registre essa recomendação em cada `00-overview.md`.