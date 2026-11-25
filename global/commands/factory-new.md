# Iniciar projeto do zero (Greenfield) — Software Factory

Escopo e ideia inicial:

$ARGUMENTS

Execute somente a etapa de concepção e documentação base em `docs/ai/`:
1. Se `$ARGUMENTS` estiver vazio ou incompleto, pergunte antes de prosseguir: objetivo do sistema, funcionalidades principais (MVP) e stack tecnológica desejada.
2. Acione `product-owner` para estruturar visão do produto, personas, regras de negócio iniciais e backlog macro em `docs/ai/project-profile.md` e `docs/ai/business-rules.md`.
3. Acione `software-architect` (e, quando aplicável, `database-engineer` e `ux-ui-designer`) para definir arquitetura, modelo de dados inicial, convenções e padrões visuais em `docs/ai/architecture.md`, `docs/ai/conventions.md` e `docs/ai/design-system.md`.
4. Acione `security-engineer` e `qa-engineer` para registrar requisitos mínimos de segurança e estratégia de testes em `docs/ai/security-posture.md` e `docs/ai/quality-strategy.md`.
5. Marque explicitamente o que são decisões definidas e o que ainda está em aberto.

**PARE AQUI.** Não crie código de aplicação, migrations nem instale dependências nesta etapa. Apresente um resumo da arquitetura e regras definidas para aprovação e sugira o primeiro `/factory-feature` (ex.: setup base e estrutura inicial do projeto).