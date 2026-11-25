---
name: project-onboarding
description: Mapeia um repositório novo para a Software Factory. Identifica stack, arquitetura, scripts, design system, regras de negócio, segurança e testes sem inventar informações.
---

# Project Onboarding

1. Confirme a raiz do repositório e leia `AGENTS.md`, README, manifests, arquivos de build, configuração, CI e documentação existente.
2. Identifique linguagens, frameworks, versões observáveis, runtime, gerenciadores de pacote, banco, integrações e estrutura de módulos.
3. Identifique comandos reais de install, dev, lint, typecheck, test, build e migrations. Não execute operações destrutivas.
4. Mapeie autenticação, autorização, tenancy, dados sensíveis e fronteiras de confiança em alto nível; não revele secrets.
5. Inspecione design tokens, componentes, tipografia, padrões responsivos e acessibilidade quando houver frontend.
6. Identifique regras de negócio apenas em fontes comprováveis: código, schemas, testes e documentação.
7. Produza/atualize `docs/ai/project-profile.md`, `architecture.md`, `business-rules.md`, `design-system.md`, `conventions.md`, `security-posture.md` e `quality-strategy.md`.
8. Marque cada item como Confirmado, Documentado, Inferido ou Desconhecido e inclua caminhos de evidência.
9. Preserve documentos existentes: antes de substituir, compare e mantenha decisões ainda válidas. Não sobrescreva conteúdo do usuário sem aprovação.
10. Entregue um resumo das lacunas e perguntas que impedem trabalho confiável.

Não faça refatorações, não instale dependências, não execute migrations e não altere o comportamento do produto durante onboarding.
