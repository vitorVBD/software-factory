# Software Factory

Pacote de equipe multiagente para o [Cursor](https://cursor.com). O Agent principal da conversa atua como orquestrador e delega trabalho a subagentes especializados. O fluxo é supervisionado: planejamento, aprovação humana explícita e só então implementação, revisão e auditoria.

A versão documentada deste pacote está em `templates/VERSION` (**1.0.0**).

Este repositório é a fábrica. Ele não é um produto de aplicação. Mantenha-o em uma pasta estável, separada dos repositórios que você desenvolve, e abra cada produto como workspace próprio no Cursor.

## O que este pacote instala

| Componente | Quantidade | Função |
|---|---:|---|
| Subagentes | 11 | Papéis especializados (produto, arquitetura, implementação, revisão, segurança, QA e outros) |
| Skills | 8 | Procedimentos reutilizáveis de intake, onboarding, desenvolvimento, auditoria e release |
| Comandos | 12 | Atalhos `/factory-...` no Agent do Cursor |
| Regra global | 1 | Política de orquestração, gates humanos e evidências |
| Scaffold de projeto | 1 | `AGENTS.md`, regras `.mdc`, contexto em `docs/ai/` e templates de tarefa |

## Como o trabalho acontece

Não há um agente coordenador separado. O Agent com quem você conversa lê a regra global, escolhe os especialistas e para nos checkpoints humanos.

```text
Pedido
  → Product Owner (requisitos e critérios)
  → Architect e especialistas, quando a mudança exigir
  → Prompt Engineer (instruções para o Developer)
  → PARADA: você aprova o plano
  → Developer (implementação e testes)
  → Tech Lead
  → Security e QA, em paralelo e de forma independente
  → até 2 ciclos de correção se houver reprovação
  → Product Owner recomenda o aceite
  → PARADA: você decide commit, merge, release ou deploy
```

`/factory-fast` é a exceção explícita a esse ciclo, mas só deve ser usado para mudanças isoladas e de baixo risco. Antes de implementar, o Agent faz um Risk Gate; na dúvida ou diante de autenticação/autorização, permissões/tenant, dados pessoais ou financeiros, pagamentos, schema/migrations, uploads, segredos, integrações externas ou infraestrutura, deve encaminhar para `/factory-feature` ou `/factory-hotfix`. O Fast-Track exige plano de até 6 linhas e aprovação humana explícita, executa testes relevantes e não substitui revisões independentes quando o risco exigir o fluxo completo. Commit, push, merge, release e deploy continuam fora desse atalho. `/factory-triage` só classifica o backlog entre esse atalho e `/factory-feature`; não implementa código.

Estados de uma tarefa:

`DRAFT` → `DISCOVERY` → `PLANNING` → `AWAITING_HUMAN_APPROVAL` → `APPROVED_FOR_IMPLEMENTATION` → `IMPLEMENTING` → `TECH_REVIEW` → `SECURITY_QA` → `REWORK` (0 a 2 ciclos) → `PO_ACCEPTANCE` → `AWAITING_HUMAN_RELEASE_DECISION` → `DONE`

Estados alternativos: `NEEDS_CLARIFICATION`, `BLOCKED`, `REJECTED`, `CANCELLED`. Os comandos `/factory-roadmap` e `/factory-idea` também usam `BACKLOG` na visão geral da tarefa.

Resultados de verificação:

| Resultado | Significado |
|---|---|
| `PASS` | A verificação rodou e foi aprovada |
| `FAIL` | A verificação rodou e encontrou defeito ou risco bloqueador |
| `BLOCKED` | Não foi possível validar por uma dependência |
| `NOT RUN` | A verificação não foi executada |

`BLOCKED` e `NOT RUN` não contam como aprovação.

Gates:

1. Plano documentado e aprovação humana explícita.
2. Implementação concluída, com evidências de teste do Developer.
3. Tech Lead sem bloqueios; Security `PASS`; QA `PASS`.
4. Product Owner recomenda o aceite, com critérios rastreados.
5. Você autoriza, em separado, merge, release ou deploy.

Silêncio, um “ok” genérico ou a aprovação de outra etapa não autorizam a implementação nem a publicação. A exceção é `/factory-fast`: depois do plano de no máximo 6 linhas, “ok” autoriza só aquele escopo enxuto.

## Pré-requisitos

- Cursor com Agent.
- Windows com PowerShell 5 ou superior, **ou** Linux/macOS com `bash`.
- Uma pasta já existente para cada produto. Os scripts de preparação não criam o diretório do projeto.
- Git no produto, quando você quiser que status, auditoria e continuação leiam diff. Se a raiz do workspace não for um repositório Git, vários comandos procuram `backend/` e `frontend/`.

## 1. Obter a fábrica

Clone ou copie este repositório para uma pasta permanente.

Windows:

```text
C:\dev\software-factory\
```

Linux e macOS:

```text
~/dev/software-factory/
```

## 2. Instalar no seu perfil do Cursor

A instalação copia agentes, comandos e skills para o perfil do usuário e guarda os templates em `~/.cursor/factory-templates`. Arquivos de destino já existentes são substituídos.

O instalador da raiz é o caminho compatível com `/factory-init`, porque esse comando procura os scripts em `~/.cursor/factory-templates/scripts/`.

### Windows

No PowerShell, na raiz deste repositório:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

Destino: `%USERPROFILE%\.cursor\`.

### Linux e macOS

No terminal, na raiz deste repositório:

```bash
chmod +x ./install.sh
./install.sh
```

Destino: `$HOME/.cursor/`.

### Conferir a instalação

Windows:

```powershell
@(
  "$env:USERPROFILE\.cursor\agents\developer.md",
  "$env:USERPROFILE\.cursor\commands\factory-feature.md",
  "$env:USERPROFILE\.cursor\skills\feature-development\SKILL.md",
  "$env:USERPROFILE\.cursor\factory-templates\scripts\init-project.ps1",
  "$env:USERPROFILE\.cursor\factory-templates\templates\project\AGENTS.md"
) | ForEach-Object { "$((Test-Path $_))  $_" }
```

Linux e macOS:

```bash
for f in \
  "$HOME/.cursor/agents/developer.md" \
  "$HOME/.cursor/commands/factory-feature.md" \
  "$HOME/.cursor/skills/feature-development/SKILL.md" \
  "$HOME/.cursor/factory-templates/scripts/init-project.sh" \
  "$HOME/.cursor/factory-templates/templates/project/AGENTS.md"
do
  if [ -f "$f" ]; then echo "OK   $f"; else echo "FALTA  $f"; fi
done
```

Cada linha esperada começa com `True` no Windows ou `OK` no Linux/macOS. Feche e abra o Cursor (ou recarregue a janela) para os comandos e os subagentes serem detectados.

Há um segundo instalador, só para Windows, em `templates/scripts/install-global.ps1`. Ele não sobrescreve arquivos existentes, a menos que você passe `-Force` (nesse caso grava backup `.bak.<timestamp>`), e também copia `templates/global/rules` para `%USERPROFILE%\.cursor\rules`. Ele **não** preenche `factory-templates`. Quem segue este guia usa `install.ps1` ou `install.sh`.

## 3. Ativar a regra global

A regra que faz o Agent principal orquestrar a equipe fica em:

```text
global/global/GLOBAL-RULE.md
```

1. Abra esse arquivo e copie todo o conteúdo.
2. No Cursor, abra **Settings → Rules → User Rules**.
3. Cole o texto e salve.

User Rules valem no Editor para a conta, inclusive em projetos que ainda não receberam o scaffold. Cada projeto preparado também recebe regras locais em `.cursor/rules/`, entre elas o fluxo supervisionado.

O arquivo `templates/global/rules/software-factory-global.mdc` é a mesma política em formato de regra do Cursor, usada pelo instalador Windows alternativo em `~/.cursor/rules` (contexto de self-hosted workers).

## 4. Preparar cada produto

Repita este passo em cada repositório de aplicação. A pasta do produto precisa existir antes. Arquivos que já existem são mantidos. Nada é apagado.

Abra depois **somente** a pasta do produto como workspace. Assim as regras daquele repositório entram em vigor.

### Windows

```powershell
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.cursor\factory-templates\scripts\init-project.ps1" `
  -ProjectPath "C:\CAMINHO\PROJETOS\meu-produto" `
  -ProjectName "Meu Produto"
```

`-ProjectName` é opcional. Sem ele, o script usa o nome da pasta. `{{PROJECT_NAME}}` e `{{PROJECT_SLUG}}` são substituídos em arquivos `.md`, `.mdc` e `.txt`. O slug fica em minúsculas, com sequências que não são letras ou números trocadas por hífen.

Para substituir arquivos já gerados pela fábrica, com backup `.bak.<timestamp>`:

```powershell
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.cursor\factory-templates\scripts\init-project.ps1" `
  -ProjectPath "C:\CAMINHO\PROJETOS\meu-produto" `
  -ProjectName "Meu Produto" `
  -Force
```

Para versionar agentes e skills dentro do produto (necessário para CLI e Cloud Agents; útil para compartilhar o time com quem clona o repositório):

```powershell
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.cursor\factory-templates\scripts\init-project.ps1" `
  -ProjectPath "C:\CAMINHO\PROJETOS\meu-produto" `
  -ProjectName "Meu Produto" `
  -IncludeProjectAgents `
  -IncludeProjectSkills
```

O script aceita `-WhatIf` para mostrar o que seria copiado.

Também é possível rodar a cópia a partir do clone, sem depender da instalação global:

```powershell
powershell -ExecutionPolicy Bypass -File "C:\dev\software-factory\templates\scripts\init-project.ps1" `
  -ProjectPath "C:\CAMINHO\PROJETOS\meu-produto" `
  -ProjectName "Meu Produto"
```

### Linux e macOS

O script `init-project.sh` usa o mesmo layout de templates e as mesmas opções funcionais do script PowerShell. Ele preserva arquivos existentes por padrão, substitui `{{PROJECT_NAME}}` e `{{PROJECT_SLUG}}` em `.md`, `.mdc` e `.txt` e cria backups `.bak.<timestamp>` quando `--force` é usado.

Após instalar a fábrica:

```bash
bash "$HOME/.cursor/factory-templates/scripts/init-project.sh" \\
  --project-path "$HOME/projetos/meu-produto" \\
  --project-name "Meu Produto"
```

Para substituir arquivos existentes, com backup:

```bash
bash "$HOME/.cursor/factory-templates/scripts/init-project.sh" \\
  --project-path "$HOME/projetos/meu-produto" \\
  --project-name "Meu Produto" \\
  --force
```

Para versionar também os agentes e as skills no repositório do produto:

```bash
bash "$HOME/.cursor/factory-templates/scripts/init-project.sh" \\
  --project-path "$HOME/projetos/meu-produto" \\
  --project-name "Meu Produto" \\
  --include-project-agents \\
  --include-project-skills
```

Também é possível executar o script diretamente do clone, sem instalação global:

```bash
bash "/caminho/software-factory/templates/scripts/init-project.sh" \\
  "/caminho/projetos/meu-produto" \\
  "Meu Produto"
```

A pasta do produto precisa existir antes. Sem `--force`, arquivos de destino existentes são mantidos; com `--force`, cada arquivo substituído recebe um backup. O scaffold fica em `templates/templates/project`, e os agentes/skills opcionais vêm de `templates/global/`.

### O que aparece no produto

```text
meu-produto/
├── AGENTS.md
├── .cursor/rules/
│   ├── 00-project-context.mdc
│   ├── 05-supervised-workflow.mdc
│   ├── 10-engineering-standards.mdc
│   ├── 20-security-baseline.mdc
│   ├── 30-quality-gates.mdc
│   ├── 40-design-system.mdc
│   └── 50-data-and-migrations.mdc
└── docs/ai/
    ├── README.md
    ├── project-profile.md
    ├── architecture.md
    ├── business-rules.md
    ├── design-system.md
    ├── conventions.md
    ├── security-posture.md
    ├── quality-strategy.md
    ├── tasks/
    ├── adr/
    └── templates/task/
        ├── 00-overview.md
        ├── 01-requirements.md
        ├── 02-technical-plan.md
        ├── 03-implementation-prompt.md
        ├── 04-implementation-report.md
        ├── 05-tech-review.md
        ├── 06-security-report.md
        ├── 07-qa-report.md
        └── 08-acceptance-report.md
```

Os documentos de `docs/ai/` nascem como formulário. O onboarding ou o projeto greenfield preenchem só o que for confirmado. Segredos, dados pessoais, tokens e dumps não entram nesses arquivos.

## 5. Primeiro uso no produto

Abra a pasta do produto no Cursor, como workspace único. No Agent, os comandos digitados com `/` recebem o texto seguinte como argumento.

### Produto que já tem código

```text
/factory-onboard
```

O comando executa a skill `project-onboarding`. Ele inspeciona o repositório e atualiza `docs/ai/` com o que estiver no código ou na documentação. Inferências e lacunas ficam marcadas. Código de aplicação e instalação de dependências ficam de fora.

Revise em seguida:

- `docs/ai/project-profile.md`
- `docs/ai/architecture.md`
- `docs/ai/business-rules.md`
- `docs/ai/design-system.md`
- `docs/ai/conventions.md`
- `docs/ai/security-posture.md`
- `docs/ai/quality-strategy.md`

Classificação usada pela fábrica: **confirmado no código**, **documentado**, **inferido**, **desconhecido**.

No Windows, `/factory-init` faz essa escolha sozinho: se `AGENTS.md` e `.cursor/rules` ainda não existirem, roda `init-project.ps1`; se já houver código de aplicação, segue para `/factory-onboard`.

```text
/factory-init
```

### Produto do zero (greenfield)

```text
/factory-new
Sistema de reservas para clínicas. MVP: cadastro de pacientes, agenda e confirmação por e-mail. Stack desejada: a definir com o time.
```

Se o texto vier vazio, o Agent pergunta objetivo, funcionalidades do MVP e stack antes de continuar. Entram Product Owner, Architect e, quando couber, Database, UX/UI, Security e QA. O resultado fica em `docs/ai/`. Esta etapa para antes de criar código, migrations ou dependências. O fechamento esperado é um resumo para você aprovar e a sugestão do primeiro `/factory-feature` (em geral, setup e estrutura inicial).

`/factory-init` em uma pasta sem código de aplicação encaminha para esse fluxo e repassa o texto que você escreveu depois do comando.

## 6. Uso diário

### Nova funcionalidade, refatoração ou mudança de comportamento

```text
/factory-feature
Quero permitir que o cliente cancele um pedido até 30 minutos depois da confirmação, com estorno das regras já documentadas.
```

O orquestrador:

1. Cria `TASK-YYYYMMDD-###` em `docs/ai/tasks/<ID>/`, sem colidir com pastas existentes.
2. Copia `docs/ai/templates/task/` e substitui `{{TASK_ID}}`, `{{TASK_TITLE}}` e `{{PROJECT_NAME}}`.
3. Pede requisitos e critérios ao Product Owner.
4. Envolve Architect, Database, UX/UI ou DevOps quando a mudança cruzar arquitetura, persistência, interface ou operação.
5. Pede ao Prompt Engineer as instruções de implementação, ancoradas no código real.
6. Mostra escopo, arquivos prováveis, testes, riscos e critérios.

A conversa para aqui. Código, migrations, infraestrutura e configuração operacional permanecem intocados.

Leia o plano. Se algo bloqueante estiver em aberto, a tarefa fica em `NEEDS_CLARIFICATION` até você responder. Quando o plano estiver certo, aprove **esse** plano, com o ID:

```text
Aprovo o plano da TASK-20261125-001. Pode iniciar a implementação.
```

### Execução rápida

```text
/factory-fast
Ajustar o filtro da listagem de pedidos para o intervalo de datas já usado nas outras telas.
```

Use quando a mudança for padrão e de baixo risco: CRUD no padrão do projeto, tela ou formulário com componentes existentes, filtro, listagem, ajuste visual, validação simples ou endpoint que repete um padrão já consolidado. O comando lê `docs/ai/conventions.md`, `docs/ai/design-system.md` e, se você informar um `TASK-ID`, os arquivos `00-overview.md` e `01-requirements.md`.

O Agent mostra, em no máximo 6 linhas, quais arquivos de `backend/` e `frontend/` serão criados ou alterados. Um "ok" seu autoriza essa implementação. Ele escreve o código direto, sem delegar aos subagentes especialistas e sem preencher os templates `02` a `08`. Em seguida roda o linter, o typecheck ou o build rápido do que foi afetado, marca `00-overview.md` como `DONE` e resume os arquivos alterados.

Migration complexa, autenticação, permissões, regra financeira, integração externa, webhook, upload sensível e mudança de arquitetura continuam em `/factory-feature`. Commit, push, merge, release e deploy continuam pedindo autorização separada.

### Implementar o plano aprovado

```text
/factory-continue
Continue a TASK-20261125-001. O plano foi aprovado nesta conversa.
```

O comando confirma que a aprovação cobre exatamente o plano atual. Sem isso, ele para e pede aprovação. Em seguida chama Developer, Tech Lead, Security e QA. Security e QA trabalham como revisores independentes. Uma reprovação volta ao Developer, com no máximo dois ciclos automáticos. Se o bloqueio continuar, a fábrica para e pede a sua decisão.

Commit, push, merge, release, deploy e migrations destrutivas ficam de fora desse comando.

### Corrigir um defeito

```text
/factory-hotfix
Ao confirmar o pagamento com o cartão recusado, o pedido permanece como pago. O esperado é permanecer pendente e mostrar o erro do provedor.
```

O fluxo é o mesmo das features: Product Owner, diagnóstico com evidências, plano mínimo, parada para aprovação. Depois da aprovação, use `/factory-continue`.

### Ver o que está em andamento

```text
/factory-status
```

Lista cada pasta em `docs/ai/tasks/` com estado, gate, aprovação registrada, pendências, última evidência e próximo responsável. Sem registro explícito, a tarefa não é tratada como aprovada. O comando não altera arquivos. Se `docs/ai/tasks/` não existir, a resposta informa que ainda não há tarefas.

### Auditar o que já mudou

```text
/factory-audit
Audite as alterações atuais, sem modificar o código.
```

Security, QA e, quando for útil, Tech Lead revisam o diff. Ninguém corrige achados nesse comando. A saída traz `PASS`, `FAIL`, `BLOCKED` ou `NOT RUN` e os próximos passos.

### Quebrar um roadmap em backlog

Na raiz do produto, mantenha um `ROADMAP.md`. Depois:

```text
/factory-roadmap
Login e cadastro já estão no ar. O módulo de pagamentos está pela metade.
```

O Product Owner cruza o roadmap, o seu texto e o código (`backend/` e `frontend/` quando existirem). Itens já concluídos e confirmados no código não ganham pasta de tarefa. Itens pendentes ou parciais viram `docs/ai/tasks/TASK-.../` só com `00-overview.md` (status `BACKLOG`) e `01-requirements.md`. O plano técnico (`02` e `03`) fica para o momento em que você puxar a tarefa. A tabela final inclui a coluna **Modo Recomendado** (`/factory-fast` ou `/factory-feature`), e a mesma recomendação fica registrada em cada `00-overview.md`.

### Adicionar ideias ao backlog

```text
/factory-idea
Quero que o cliente receba um lembrete 24 horas antes da consulta e possa remarcar pelo link do e-mail.
```

O orquestrador coordena o Product Owner e para antes de código ou plano técnico (`02` e `03`). Se o texto vier vazio, o Agent pergunta quais ideias ou funcionalidades adicionar. A análise lê `ROADMAP.md` (quando existir), `docs/ai/project-profile.md`, `docs/ai/business-rules.md` e os IDs já usados em `docs/ai/tasks/` para continuar a numeração `TASK-YYYYMMDD-###`.

O Product Owner quebra as ideias em tarefas atômicas, evita duplicar o que já está no roadmap ou no backlog, define dependências e classifica o **Modo Recomendado** (`/factory-fast` ou `/factory-feature`). Quando `ROADMAP.md` existir, os itens novos entram na seção apropriada como pendentes `[ ]`. Cada tarefa nasce só com `00-overview.md` (status `BACKLOG`, prioridade, dependências e modo recomendado) e `01-requirements.md` (objetivo, regras de negócio e critérios de aceitação).

A resposta é uma tabela com `TASK ID`, título, escopo, dependências e modo recomendado, mais o comando exato para iniciar alguma delas na hora.

### Triar o backlog

```text
/factory-triage
```

O comando lê `00-overview.md` e `01-requirements.md` das tarefas em `docs/ai/tasks/` que ainda não estão `DONE`. Não altera código de aplicação e não chama subagentes. Cada tarefa aberta recebe, no topo de `00-overview.md`, a linha `**Modo Recomendado:**` com `/factory-fast` ou `/factory-feature`.

A resposta é uma tabela com `TASK ID`, título, escopo (Backend, Frontend ou Ambos), modo recomendado e uma frase de justificativa, na ordem de prioridade de execução. No fim, o Agent indica a primeira da fila e deixa o comando pronto para copiar.

`/factory-fast` cabe em CRUD padrão, telas e formulários que seguem componentes existentes, filtros, listagens, ajustes de interface e endpoints que repetem um padrão já consolidado. `/factory-feature` cabe em migration complexa, autenticação, permissões, regras financeiras, integrações, webhooks, upload sensível e mudança de arquitetura.

### Preparar a estrutura pelo comando

No Windows, com a instalação global feita:

```text
/factory-init
```

Isso aplica `init-project.ps1` quando o scaffold ainda não está na raiz e, em seguida, escolhe onboarding ou greenfield. No Linux e no macOS, prepare o projeto com o procedimento da seção 4 e só então use `/factory-onboard` ou `/factory-new`. `/factory-init` nesses sistemas chama `init-project.sh`, cujo caminho de origem não é o scaffold em `templates/templates/project`.

## 7. O que dizer na aprovação

A aprovação precisa identificar o plano.

Serve:

```text
Aprovo o plano da TASK-20261125-001. Pode iniciar a implementação.
```

Também é aprovação explícita uma frase que cite o ID e autorize a implementação daquele plano, depois de você ter lido o resumo.

Estas respostas não autorizam código no fluxo completo:

```text
ok
pode seguir
aprovado
continue
```

A exceção é `/factory-fast`. Depois do plano de no máximo 6 linhas, "ok" autoriza a implementação daquele escopo enxuto. Não autoriza commit, push, merge, release nem deploy.

Publicação é outro pedido. “Concluir a tarefa”, “está pronto” ou o aceite do Product Owner não geram commit, push, merge, release nem deploy. Quando quiser isso, diga a ação e o alvo:

```text
Pode criar o commit das alterações da TASK-20261125-001. Não faça push.
```

Peça autorização explícita, e espere por ela, antes de: editar código depois do planejamento; rodar migration destrutiva; apagar ou sobrescrever dados; alterar segredos, IAM, firewall, DNS ou produção; criar custo ou serviço externo; executar um comando de grande impacto.

## Onde cada coisa fica

| Componente | Caminho | Escopo |
|---|---|---|
| Subagentes | `~/.cursor/agents` | Editor e self-hosted workers neste usuário |
| Skills | `~/.cursor/skills` | Esta máquina; sincronizável para Cloud Agents |
| Comandos | `~/.cursor/commands` | Agent do Editor (atalho `/nome-do-arquivo`) |
| Templates da fábrica | `~/.cursor/factory-templates` | Scripts e scaffold usados na preparação |
| User Rules | Cursor Settings → Rules | Editor, na conta |
| Regras de worker | `~/.cursor/rules` | Self-hosted workers, se você usar o instalador alternativo do Windows |
| Regras do produto | `<produto>/.cursor/rules` | Somente aquele workspace |
| Contexto do produto | `<produto>/AGENTS.md` e `<produto>/docs/ai` | Somente aquele repositório |
| Agentes no repo (opcional) | `<produto>/.cursor/agents` | Editor, CLI e Cloud Agents |
| Skills no repo (opcional) | `<produto>/.cursor/skills` | Versionadas com o produto |
| Evidências da tarefa | `<produto>/docs/ai/tasks/<TASK-ID>/` | Histórico daquela tarefa |
| ADRs | `<produto>/docs/ai/adr/` | Decisões de arquitetura do produto |

No Windows, `~` é `%USERPROFILE%`.

## Papéis

O Developer é o único subagente sem `readonly: true`. Os demais revisam, especificam ou recomendam. Nenhum papel aprova o próprio trabalho no lugar dos gates. Security aprova ou reprova a auditoria de segurança. QA aprova ou reprova testes e qualidade. O Product Owner recomenda aceite funcional e não substitui Security nem QA.

| Subagente | Quando entra |
|---|---|
| `product-owner` | Problema, requisitos, regras de negócio, priorização e critérios de aceitação |
| `software-architect` | Desenho, integrações, limites de módulo, compatibilidade e risco estrutural |
| `prompt-engineer` | Instruções de implementação a partir do plano aprovado e do código real |
| `developer` | Implementação e testes, depois da aprovação humana |
| `tech-lead` | Padrões, legibilidade, tipagem, modularidade, erros e integração |
| `security-engineer` | Auditoria independente de AppSec em código, APIs, autenticação, dados e configuração |
| `qa-engineer` | Critérios de aceitação, regressão, cenários negativos e evidência de execução |
| `ux-ui-designer` | Fluxos, acessibilidade, responsividade e consistência visual |
| `database-engineer` | Schema, integridade, migrations e queries |
| `devops-engineer` | CI/CD, containers, infraestrutura e observabilidade |
| `debugger-performance-engineer` | Causa raiz, falhas difíceis de reproduzir e performance |

O orquestrador aciona só quem a tarefa exige e envia a cada um o contexto, os arquivos e os limites. Subagentes não herdam a conversa inteira.

## Skills

| Skill | Uso |
|---|---|
| `project-onboarding` | Mapear um repositório existente sem inventar stack, rotas ou regras. Comando: `/factory-onboard` |
| `feature-intake` | Discovery, regras, exceções e critérios testáveis |
| `architecture-review` | Impacto, alternativas, contratos, compatibilidade e necessidade de ADR |
| `implementation-prompt` | Prompt técnico para o Developer |
| `feature-development` | Ciclo supervisionado, da descoberta ao aceite, com parada antes do código |
| `security-audit` | Auditoria de AppSec somente leitura, com severidade e evidência |
| `qa-regression` | Validação funcional e regressão com os comandos reais do repositório |
| `release-readiness` | Checklist de CI, migrations, backup, observabilidade e rollback. Não publica |

## Segurança e limites

- Security e QA estão marcados como `readonly: true`. Eles registram achados; a correção volta ao Developer.
- Relatórios de Security e QA são avaliação assistida. Eles não certificam ausência de vulnerabilidades.
- A fábrica não cria proteção de branch, CI, SAST, SCA nem ambiente de teste. Isso fica no pipeline de cada produto.
- Não coloque `.env`, tokens, chaves, dados reais de clientes ou dumps de produção em prompts, fixtures, logs ou `docs/ai/`.
- Achados `CRITICAL` e `HIGH` de segurança bloqueiam a recomendação de conclusão. `MEDIUM` bloqueia quando o impacto pedir; caso contrário, vira decisão explícita. `LOW` e `INFO` permanecem visíveis.
- Testes, scans e builds só podem ser descritos como executados quando o comando tiver rodado. O relatório inclui o comando, o resumo e a limitação, sem segredos.
- Instruções conflitantes encontradas dentro de um repositório de produto não substituem a regra global.

Severidades usadas pelo Security Engineer: `CRITICAL`, `HIGH`, `MEDIUM`, `LOW`, `INFO`.

## Atualizar a fábrica

1. Atualize o clone deste repositório.
2. Rode de novo o instalador da raiz (`install.ps1` ou `install.sh`). A cópia substitui agentes, comandos, skills e `factory-templates`.
3. Se o texto de `global/global/GLOBAL-RULE.md` mudou, atualize a User Rule no Cursor.
4. Em cada produto que deva receber regras ou templates novos, rode de novo a preparação. No Windows, `-Force` substitui arquivos gerenciados pelo template e guarda a versão anterior com extensão `.bak.<timestamp>`. Revise o diff antes de seguir.
5. Feche e abra o Cursor.

Projetos já preenchidos em `docs/ai/` devem ser conferidos depois de um `-Force`: o backup permite recuperar um documento que o template sobrescreveu.

## Resolução de problemas

**O comando `/factory-feature` não aparece.** Confira se o arquivo está em `~/.cursor/commands/factory-feature.md` e recarregue o Cursor. O nome do comando é o nome do arquivo, sem `.md`.

**O Agent implementa sem pedir aprovação.** Confira a User Rule colada a partir de `global/global/GLOBAL-RULE.md` e a regra `.cursor/rules/05-supervised-workflow.mdc` no produto. O workspace aberto precisa ser a pasta do produto, não a pasta pai de vários repositórios.

**`/factory-init` no Linux ou macOS não copia `AGENTS.md`.** Prepare o produto com o script da seção 4. O comando chama `init-project.sh`, que lê outro layout de pastas.

**A preparação diz que a pasta do projeto não existe.** Crie o diretório antes. O script não cria a raiz do produto.

**Cloud Agent não enxerga os subagentes.** Copie agentes para `.cursor/agents` do produto (`-IncludeProjectAgents` no Windows, ou `copy_tree` no Linux/macOS). Agentes só em `~/.cursor/agents` cobrem o Editor e self-hosted workers.

**Dois produtos misturam regras.** Cada produto é um workspace. A fábrica global não carrega `docs/ai/` de outro repositório; se um documento divergir do código, a tarefa registra a divergência e pede decisão.

**O Agent afirma que um teste passou sem comando.** Peça o relatório em `docs/ai/tasks/<ID>/` com `PASS`, `FAIL`, `BLOCKED` ou `NOT RUN`, o comando e a limitação. Sem execução, o estado correto é `NOT RUN` ou `BLOCKED`.

## Layout deste repositório

```text
software-factory/
├── install.ps1              # instalação Windows no perfil do Cursor
├── install.sh               # instalação Linux/macOS no perfil do Cursor
├── global/
│   ├── agents/              # 11 subagentes
│   ├── commands/            # 12 comandos /factory-*
│   ├── skills/              # 8 skills
│   └── global/GLOBAL-RULE.md
└── templates/
    ├── VERSION              # versão do pacote
    ├── README.md            # guia do kit em templates/ (instalador Windows alternativo)
    ├── docs/                # modelo operacional e notas de implantação
    ├── scripts/
    │   ├── install-global.ps1
    │   ├── init-project.ps1
    │   └── init-project.sh
    ├── global/              # cópia de agentes, comandos, skills e regra .mdc
    └── templates/project/   # scaffold copiado para cada produto
```

`templates/docs/OPERATING-MODEL.md` descreve papéis, estados e gates. `templates/docs/IMPLEMENTATION-NOTES.md` registra onde o Cursor carrega agentes, skills, comandos e regras.

## Referências

- [Subagents](https://cursor.com/docs/subagents)
- [Skills](https://cursor.com/docs/skills)
- [Rules](https://cursor.com/docs/rules)
- [Hooks](https://cursor.com/docs/hooks)
- [Customize Cursor](https://cursor.com/docs/customize-cursor)
