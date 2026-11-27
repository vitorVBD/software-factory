# Planejar uma Feature — Software Factory

Atue como Orchestrator utilizando a regra global da Software Factory.

Leia o contexto do workspace antes de delegar.

## Solicitação do usuário

$ARGUMENTS

## Objetivo

Este comando possui dois modos de operação:

1. **NEW:** Criar e planejar uma nova tarefa.
2. **EXISTING:** Promover ou retomar uma tarefa existente do backlog para planejamento técnico, preservando seu TASK-ID e histórico.

Nunca duplique uma tarefa existente.

---

## 1. Identificação do modo de execução

Procure por um identificador no formato:

`TASK-YYYYMMDD-###`

### Modo NEW

Quando nenhum TASK-ID válido for informado:

1. Gere um novo ID sequencial, sem colisão com pastas existentes.
2. Crie `docs/ai/tasks/<TASK-ID>/`.
3. Utilize os templates existentes em `docs/ai/templates/task/`.
4. Substitua `{{TASK_ID}}`, `{{TASK_TITLE}}` e `{{PROJECT_NAME}}`.
5. Registre a solicitação original e inicie o planejamento.

### Modo EXISTING

Quando um TASK-ID for informado:

1. Localize `docs/ai/tasks/<TASK-ID>/`.
2. Confirme que a pasta e os documentos da tarefa existem.
3. Leia todos os documentos existentes, especialmente:
   - `00-overview.md`
   - `01-requirements.md`
   - `02-technical-plan.md`, caso exista.
   - `03-implementation-prompt.md`, caso exista.
4. Leia o ROADMAP e verifique as dependências relacionadas.
5. Preserve o TASK-ID original.
6. NÃO crie outra pasta TASK.
7. NÃO sobrescreva requisitos, decisões ou evidências existentes sem necessidade.
8. Reaproveite e complemente os artefatos existentes.

Se a tarefa não existir, não crie outra automaticamente. Informe o problema e solicite a correção do ID.

---

## 2. Validação do estado da tarefa

Antes de planejar, identifique o status atual.

### BACKLOG / DRAFT

Pode iniciar o planejamento técnico.

### NEEDS_CLARIFICATION

Leia as perguntas bloqueadoras e as respostas disponíveis.

Se as pendências foram resolvidas, retome o planejamento. Caso contrário, pergunte apenas o necessário.

### PLANNING

Retome o planejamento existente.

Não gere outro TASK-ID nem recrie documentos. Compare os artefatos existentes com o contexto atual e complemente apenas o necessário.

### AWAITING_HUMAN_APPROVAL

Apresente o plano já registrado e aguarde a decisão humana.

Não altere o escopo silenciosamente nem solicite uma segunda aprovação para um plano idêntico.

### APPROVED_FOR_IMPLEMENTATION / IMPLEMENTING / TECH_REVIEW / SECURITY_QA / REWORK / PO_ACCEPTANCE / AWAITING_HUMAN_RELEASE_DECISION

Não reinicie o planejamento nem gere novos artefatos.

Informe o estado atual e encaminhe para `/factory-continue <TASK-ID>` quando aplicável.

### DONE / CANCELLED / REJECTED

Não reabra automaticamente.

Informe o estado terminal e solicite uma nova tarefa ou uma decisão explícita sobre a necessidade de reabertura.

---

## 3. Carregamento de contexto

Leia, quando existirem e forem relevantes:

- `AGENTS.md`
- `docs/ai/project-profile.md`
- `docs/ai/architecture.md`
- `docs/ai/business-rules.md`
- `docs/ai/conventions.md`
- `docs/ai/design-system.md`
- `docs/ai/security-posture.md`
- `docs/ai/quality-strategy.md`
- `ROADMAP.md`

Inspecione o código real.

Não assuma caminhos de frontend ou backend. Descubra a estrutura existente.

Classifique as informações como:

- Confirmado no código.
- Documentado.
- Inferido.
- Desconhecido.

O código e os contratos reais do projeto são a fonte de verdade funcional.

---

## 4. Planejamento especializado de UI/UX

Quando a tarefa envolver frontend, telas, componentes, navegação ou comportamento visual, acione obrigatoriamente o `ux-ui-designer`.

Consulte também os artefatos do Design System quando disponíveis:

- `design-system/docs/`
- `design-system/tokens/`
- `design-system/cursor-rule/design-system.mdc`
- `design-system/layouts/docs/`
- `design-system/layouts/cursor-rule/ui-layout.mdc`

Os caminhos devem ser descobertos no workspace, não presumidos.

Para mudanças de frontend, o UX/UI Designer deverá:

1. Identificar a tela e os componentes atuais.
2. Identificar funcionalidades e interações existentes.
3. Consultar a especificação visual correspondente.
4. Mapear os estados e comportamentos necessários.
5. Identificar componentes existentes que podem ser reutilizados.
6. Documentar divergências entre o layout atual e o novo System Design.
7. Definir critérios de aceitação visuais e funcionais.

### Preservação funcional obrigatória

Em tarefas de redesign ou modernização visual:

- Não remover funcionalidades existentes.
- Não substituir integrações reais por mocks.
- Não eliminar filtros, pesquisas, ações ou controles.
- Não modificar contratos de API sem justificativa e aprovação.
- Preservar validações, permissões e regras de negócio.
- Preservar estados de loading, empty, error e success.
- Preservar a responsividade e os comportamentos de interação.

Produza uma matriz de rastreabilidade:

| Funcionalidade existente | Tela/componente | Comportamento esperado após mudança | Teste de regressão |
|---|---|---|---|

Se uma funcionalidade não estiver contemplada no novo layout, ela deverá continuar disponível e receber uma adaptação visual documentada.

Se a especificação visual contradizer o comportamento real do produto, registre a divergência e solicite decisão quando ela alterar o escopo funcional.

---

## 5. Análise de requisitos e arquitetura

Delegue ao `product-owner`:

- Refinamento do problema.
- Requisitos funcionais e não funcionais.
- Regras de negócio.
- Critérios de aceitação Given/When/Then.
- Cenários negativos.
- Dependências.
- Riscos e perguntas bloqueadoras.

Quando aplicável, delegue também:

- `software-architect`: arquitetura, contratos e impactos técnicos.
- `database-engineer`: persistência, schema e integridade.
- `ux-ui-designer`: fluxos, layout, acessibilidade e preservação funcional.
- `devops-engineer`: infraestrutura e operação.
- `security-engineer`: riscos de segurança e privacidade.

Use somente os especialistas relevantes.

---

## 6. Plano técnico

Crie ou atualize `02-technical-plan.md` utilizando o template existente.

O plano deve conter:

- Contexto confirmado.
- Componentes e arquivos impactados.
- Abordagem de implementação.
- Alternativas e trade-offs.
- Dados, APIs e contratos afetados.
- Segurança e privacidade.
- UX e acessibilidade.
- Testes unitários, integração e regressão.
- Estratégia de rollout e rollback, quando aplicável.
- Riscos e lacunas.

Os caminhos apresentados devem ter sido identificados no código real.

Não invente nomes de arquivos, rotas, funções ou componentes.

---

## 7. Prompt técnico de implementação

Delegue ao `prompt-engineer` a criação ou atualização de `03-implementation-prompt.md`.

O prompt deve orientar o Developer a:

1. Inspecionar os arquivos antes de modificar.
2. Respeitar as convenções e arquitetura existentes.
3. Utilizar os componentes e tokens aprovados.
4. Implementar somente o escopo autorizado.
5. Preservar funcionalidades e contratos existentes.
6. Escrever ou atualizar testes.
7. Executar verificações pertinentes.
8. Apresentar evidências e diff final.

Para tarefas de redesign, inclua obrigatoriamente a matriz de rastreabilidade funcional e os critérios de regressão.

---

## 8. Atualização dos documentos da tarefa

Atualize os documentos sem perder seu histórico.

### `00-overview.md`

Registre:

- TASK-ID original.
- Título.
- Status `PLANNING` ou `NEEDS_CLARIFICATION`.
- Prioridade.
- Modo recomendado.
- Dependências.
- Agentes envolvidos.
- Gate atual.
- Aprovação humana do plano: `PENDING`.

### `01-requirements.md`

Preserve e refine os requisitos existentes.

Não remova requisitos válidos registrados durante a criação do backlog.

### `02-technical-plan.md`

Registre a estratégia técnica e os arquivos impactados.

### `03-implementation-prompt.md`

Registre o prompt técnico completo para o Developer.

Nunca marque uma tarefa como aprovada sem autorização humana explícita.

---

## 9. Gate de aprovação humana

Apresente:

- TASK-ID.
- Modo de execução.
- Problema e objetivo.
- Requisitos.
- Escopo incluído e excluído.
- Arquivos e componentes prováveis.
- Dependências.
- Riscos.
- Critérios de aceitação.
- Estratégia de testes.
- Alterações de frontend e backend previstas.

Se houver perguntas bloqueadoras, mantenha `NEEDS_CLARIFICATION`.

Caso contrário:

1. Registre `AWAITING_HUMAN_APPROVAL`.
2. Mantenha a aprovação como `PENDING`.
3. PARE.
4. Aguarde aprovação explícita do usuário.

Exemplo:

`Aprovo o plano da TASK-20261127-001. Pode iniciar a implementação.`

---

## 10. Limites obrigatórios

Este comando executa exclusivamente planejamento.

Não:

- Implemente código.
- Altere migrations.
- Modifique infraestrutura.
- Instale dependências.
- Execute operações destrutivas.
- Faça commit ou push.
- Faça merge ou deploy.
- Considere silêncio como aprovação.

Não amplie o escopo de uma tarefa existente sem registrar e apresentar as alterações para aprovação.

O próximo passo após a aprovação será:

`/factory-continue <TASK-ID>`

A responsabilidade pela decisão final continua sendo do usuário.