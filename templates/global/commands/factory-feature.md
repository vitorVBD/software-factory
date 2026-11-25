# Planejar uma nova feature — Software Factory

Atue como Orchestrator usando a regra global. Leia o contexto do workspace antes de delegar.

Solicitação do usuário:

$ARGUMENTS

Execute somente a etapa de planejamento:
1. Crie um ID `TASK-YYYYMMDD-###` não conflitante e uma pasta em `docs/ai/tasks/<ID>/` usando os templates em `docs/ai/templates/task/`; ao copiá-los, substitua `{{TASK_ID}}`, `{{TASK_TITLE}}` e `{{PROJECT_NAME}}` pelos valores reais.
2. Delegue ao `product-owner` a análise de requisitos e critérios de aceitação.
3. Quando houver mudança arquitetural, integração ou persistência relevante, delegue ao `software-architect` e aos especialistas aplicáveis (`database-engineer`, `ux-ui-designer`, `devops-engineer`).
4. Delegue ao `prompt-engineer` a criação do prompt técnico para o Developer, baseado nos resultados anteriores e no código real.
5. Registre os documentos, decisões, suposições, riscos, dependências e perguntas bloqueadoras.
6. Apresente um resumo do plano, arquivos prováveis, testes, critérios e riscos.

**PARE AQUI.** Não edite código, migrations, infraestrutura nem arquivos operacionais. Solicite aprovação explícita do usuário para o plano desta TASK. Se faltarem informações bloqueadoras, pergunte apenas o necessário e mantenha a tarefa em `NEEDS_CLARIFICATION`.
