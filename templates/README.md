# Software Factory para Cursor

Pacote de equipe multiagente para desenvolvimento **supervisionado** e reutilizável entre projetos.

## O que esta versão instala

- 11 subagents especializados (PO, Prompt Engineer, Architect, Developer, Tech Lead, Security, QA, UX/UI, Database, DevOps e Debugger/Performance).
- 8 Skills reutilizáveis para intake, onboarding, planejamento, desenvolvimento, auditoria e entrega.
- 6 comandos de Agent (`/factory-feature`, `/factory-continue`, `/factory-onboard`, `/factory-audit`, `/factory-status` e `/factory-hotfix`).
- Regra global de coordenação supervisionada.
- Templates por projeto: `AGENTS.md`, regras `.mdc`, perfil do projeto, arquitetura, regras de negócio, design system, convenções, segurança, estratégia de QA e template de tarefa.
- Scripts PowerShell para instalação global e preparação de cada projeto.

## Modelo operacional

O **Agent principal do Cursor é o Orchestrator**. A regra global e os comandos orientam esse Agent a delegar para subagents especializados. Não existe um agente-coordenador separado porque a coordenação precisa permanecer no Agent principal, que controla a conversa e os checkpoints humanos.

Fluxo normal:

1. PO transforma a solicitação em requisitos e critérios de aceitação.
2. Architect avalia a solução e impactos quando necessário.
3. Prompt Engineer prepara instruções técnicas claras para o Developer.
4. O fluxo **para e pede sua aprovação humana** antes de qualquer alteração no código-fonte.
5. Após sua autorização explícita, Developer implementa.
6. Tech Lead revisa padrões e integração.
7. Security e QA auditam de forma independente e, preferencialmente, em paralelo.
8. Reprovações retornam ao Developer; até 2 ciclos automáticos de correção e revalidação. Depois disso, a equipe para e pede intervenção humana.
9. PO verifica os critérios de produto e apresenta o aceite recomendado.
10. Você decide sobre merge, release ou deploy. O pacote não autoriza essas ações automaticamente.

## Instalação no Windows

### 1. Extraia o pacote em uma pasta estável

Exemplo:

```text
C:\dev\software-factory\
```

Não extraia dentro de um dos seus produtos. O repositório da Factory deve ser independente.

### 2. Instale os componentes globais

Abra PowerShell na pasta extraída e execute:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\install-global.ps1
```

O script instala subagents, Skills e comandos no perfil do usuário. Também instala o arquivo `.mdc` global em `~/.cursor/rules` para self-hosted workers; no Cursor Editor, a regra equivalente deve ser adicionada em **Cursor Settings → Rules** (veja o passo seguinte).

O script instala arquivos em:

```text
%USERPROFILE%\.cursor\
├── agents\
├── commands\
├── rules\
└── skills\
```

Por padrão, arquivos existentes **não são sobrescritos**. Para atualizar os arquivos da Factory depois de revisar as mudanças:

```powershell
.\scripts\install-global.ps1 -Force
```

Com `-Force`, versões anteriores são guardadas com extensão `.bak.<timestamp>`.

### 3. Ative a regra global no Editor

Para ter a política global também em projetos que ainda não receberam o scaffold, abra **Cursor Settings → Rules** e adicione o conteúdo de `global/rules/software-factory-global.mdc` como uma User Rule. O Cursor Editor aplica User Rules globais configuradas nessa tela; o arquivo em `~/.cursor/rules` é destinado ao contexto de self-hosted workers. Cada projeto preparado também recebe a regra de fluxo supervisionado em `.cursor/rules/05-supervised-workflow.mdc`.

### 4. Prepare cada projeto

Exemplo para FitMatch:

```powershell
.\scripts\init-project.ps1 -ProjectPath "C:\CAMINHO\PROJETOS\fitmatch" -ProjectName "FitMatch"
```

Repita para cada repositório. O script não apaga nem substitui arquivos preexistentes, a menos que você use `-Force`.

Para incluir cópias dos agents e Skills dentro do projeto (útil para CLI, Cloud Agents ou compartilhamento com outros desenvolvedores):

```powershell
.\scripts\init-project.ps1 `
  -ProjectPath "C:\CAMINHO\PROJETOS\fitmatch" `
  -ProjectName "FitMatch" `
  -IncludeProjectAgents `
  -IncludeProjectSkills
```

Atenção: os agentes do diretório global `~/.cursor/agents/` são carregados no Cursor Editor e em self-hosted workers, mas não são automaticamente carregados pelo CLI/Cloud Agents. Para esses ambientes, use `-IncludeProjectAgents`. Skills globais podem ser sincronizadas em **Cursor Settings → Agents → Sync Skills for Cloud Agents**; alternativamente use `-IncludeProjectSkills` para versioná-las no projeto.

### 5. Abra o projeto individualmente no Cursor

Abra `fitmatch`, `aichefe`, `onutri` etc. como workspace separado. Assim o Cursor aplica as regras locais daquele repositório. A pasta `PROJETOS` pode continuar como diretório-pai no Explorer, mas suas regras não substituem as regras do projeto quando você abre somente uma subpasta.

### 6. Faça o onboarding inicial

No Agent do Cursor, execute:

```text
/factory-onboard
```

Revise e complete os documentos em `docs/ai/`. O agente deve separar fatos confirmados, decisões documentadas, hipóteses e lacunas.

## Uso diário

### Nova funcionalidade

```text
/factory-feature
Quero implementar [descrição da funcionalidade].
```

A equipe faz intake e planejamento, gera os documentos da tarefa e **para antes de modificar código**. Leia o plano e responda explicitamente algo como:

```text
Aprovo o plano da TASK-YYYYMMDD-001. Pode iniciar a implementação.
```

### Continuar após aprovação

```text
/factory-continue
Continue a TASK-YYYYMMDD-001, cujo plano foi aprovado nesta conversa.
```

### Auditoria independente de mudanças existentes

```text
/factory-audit
Audite as alterações atuais, sem modificar o código.
```

### Status

```text
/factory-status
```

### Hotfix

```text
/factory-hotfix
Descreva o bug e o comportamento esperado.
```

O hotfix também passa por planejamento e checkpoint humano antes das alterações.

## Onde ficam as coisas

| Componente | Localização | Escopo |
|---|---|---|
| Subagents | `%USERPROFILE%\.cursor\agents` | Global no Editor |
| Skills | `%USERPROFILE%\.cursor\skills` | Global local; sincronizável para Cloud |
| Commands | `%USERPROFILE%\.cursor\commands` | Global no Editor/CLI compatível |
| User Rules | Cursor Settings → Rules | Global no Editor; sincronizada pela conta |
| Home Rules | `%USERPROFILE%\.cursor\rules` | Self-hosted workers nesta máquina |
| Project Rules | `projeto\.cursor\rules` | Apenas o projeto |
| Project context | `projeto\AGENTS.md` e `docs\ai\` | Apenas o projeto |
| Project agents (opcional) | `projeto\.cursor\agents` | Editor, CLI e Cloud Agents |
| Project Skills (opcional) | `projeto\.cursor\skills` | Projeto/versionável |

## Segurança e limites

- Security Engineer e QA são configurados como `readonly: true`. Eles revisam e testam; não corrigem a implementação.
- Developer é o único subagent padrão com permissão de escrita no código.
- Não compartilhar `.env`, tokens, chaves privadas, dados reais de clientes ou dumps de produção com agentes sem avaliar as políticas do projeto.
- Não executar migrations destrutivas, apagar dados, alterar permissões de produção, fazer merge ou deploy sem confirmação explícita.
- Os relatórios de Security/QA são avaliações assistidas por IA, não certificação ou garantia de ausência de vulnerabilidades.
- SAST/SCA, testes, CI e proteção de branch devem ser implementados no pipeline do projeto; prompts não substituem controles técnicos.

## Atualização da Factory

Mantenha este repositório em Git. Para distribuir atualizações, revise as mudanças, atualize a versão e rode novamente `install-global.ps1 -Force`. Projetos já preparados recebem regras/templates atualizados usando `init-project.ps1 -Force`, mas revise o diff, pois o modo Force substitui arquivos gerenciados pelo template.

## Referências oficiais

- https://cursor.com/docs/subagents
- https://cursor.com/docs/skills
- https://cursor.com/docs/rules
- https://cursor.com/docs/hooks
- https://cursor.com/docs/customize-cursor
