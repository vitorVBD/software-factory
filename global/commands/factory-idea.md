# Adicionar Novas Ideias ao Backlog e Roadmap — Software Factory

Ideias e requisitos brutos enviados pelo usuário:

$ARGUMENTS

Atue como Orchestrator coordenando o `product-owner`. Não altere código de aplicação e não gere plano técnico (`02` e `03`) nesta etapa.

1. Se `$ARGUMENTS` estiver vazio, pergunte quais ideias ou funcionalidades o usuário deseja adicionar.
2. Leia `ROADMAP.md` (se existir), `docs/ai/project-profile.md`, `docs/ai/business-rules.md` e verifique os IDs já existentes em `docs/ai/tasks/` para manter a numeração sequencial `TASK-YYYYMMDD-###` sem conflitos.
3. Delegue ao `product-owner` a análise das ideias em `$ARGUMENTS` para:
   - Quebrar em tarefas atômicas e bem delimitadas (evitando duplicar algo que já exista no `ROADMAP.md` ou em `docs/ai/tasks/`).
   - Definir dependências em relação às tarefas já existentes.
   - Classificar o **Modo Recomendado** de cada nova tarefa (`/factory-fast` para CRUDs/telas/ajustes padrão ou `/factory-feature` para regras críticas, banco, auth, integrações externas e arquitetura).
4. Se `ROADMAP.md` existir na raiz, adicione os novos itens na seção apropriada (marcados como pendentes `[ ]`).
5. Para cada nova tarefa, crie `docs/ai/tasks/TASK-YYYYMMDD-###/` copiando os templates de `docs/ai/templates/task/` (substituindo `{{TASK_ID}}`, `{{TASK_TITLE}}` e `{{PROJECT_NAME}}`) e preencha apenas:
   - `00-overview.md` (status: `BACKLOG`, prioridade, dependências e `**Modo Recomendado:**`).
   - `01-requirements.md` (objetivo, regras de negócio e critérios de aceitação).
6. Apresente uma tabela com as novas tarefas criadas (`TASK ID`, `Título`, `Escopo`, `Dependências`, `Modo Recomendado`) e informe o comando exato caso o usuário queira iniciar alguma delas agora.