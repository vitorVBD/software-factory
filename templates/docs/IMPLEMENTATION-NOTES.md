# Notas de implantação

1. O diretório global do Cursor depende do perfil Windows que executa o Cursor (`%USERPROFILE%\.cursor`).
2. Global subagents do usuário são usados pelo Cursor Editor e self-hosted workers; para CLI/Cloud Agents, mantenha agentes em `.cursor/agents/` dentro do repositório.
3. Global Skills em `~/.cursor/skills/` podem ser sincronizadas para Cloud Agents em Settings → Agents → Sync Skills for Cloud Agents. Alternativamente, mantenha-as em `.cursor/skills/` no repositório.
4. Os comandos pessoais ficam em `~/.cursor/commands/`; comandos markdown podem ser chamados com `/` no Agent.
5. Rules de projeto ficam em `.cursor/rules/*.mdc`; `AGENTS.md` é uma alternativa markdown simples para instruções do repositório.
6. A Factory não cria automaticamente proteção de branch, CI, SAST/SCA ou ambientes de teste. Esses controles devem ser configurados em cada repositório e pipeline.
7. `readonly: true` restringe subagents revisores, mas não substitui validações externas. Verifique permissões e resultados apresentados pelo Cursor.
