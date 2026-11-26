#!/usr/bin/env python3
"""Atualiza apenas os trechos Fast-Track e Linux/macOS no README da fábrica."""
from pathlib import Path
import sys

readme = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("README.md")
if not readme.is_file():
    raise SystemExit(f"README não encontrado: {readme}")

content = readme.read_text(encoding="utf-8")
old_fast_track = '`/factory-fast` é a exceção explícita a esse ciclo. Ela vale quando você invoca o comando: um plano de no máximo 6 linhas, um "ok" seu e implementação direta, sem os subagentes especialistas e sem os artefatos `02` a `08`. Commit, push, merge, release e deploy continuam fora desse atalho. `/factory-triage` só classifica o backlog entre esse atalho e `/factory-feature`; não implementa código.'
new_fast_track = '`/factory-fast` é a exceção explícita a esse ciclo, mas só deve ser usado para mudanças isoladas e de baixo risco. Antes de implementar, o Agent faz um Risk Gate; na dúvida ou diante de autenticação/autorização, permissões/tenant, dados pessoais ou financeiros, pagamentos, schema/migrations, uploads, segredos, integrações externas ou infraestrutura, deve encaminhar para `/factory-feature` ou `/factory-hotfix`. O Fast-Track exige plano de até 6 linhas e aprovação humana explícita, executa testes relevantes e não substitui revisões independentes quando o risco exigir o fluxo completo. Commit, push, merge, release e deploy continuam fora desse atalho. `/factory-triage` só classifica o backlog entre esse atalho e `/factory-feature`; não implementa código.'
if content.count(old_fast_track) != 1:
    raise SystemExit("Parágrafo atual de /factory-fast não encontrado de forma única. Nenhuma alteração foi feita.")
content = content.replace(old_fast_track, new_fast_track, 1)

old_section = '''### Linux e macOS

O scaffold do projeto está em `templates/templates/project` (depois da instalação, em `~/.cursor/factory-templates/templates/project`). O script `templates/scripts/init-project.sh` procura `AGENTS.md`, `.cursor/rules` e `docs/ai` na pasta pai de `scripts/`, que é outro layout. Use a preparação abaixo, que copia o scaffold real e preserva arquivos existentes.
'''
if content.count(old_section) != 1:
    raise SystemExit("Seção Linux/macOS de preparação não encontrada de forma única. Nenhuma alteração foi feita.")
start = content.index(old_section)
end_marker = "### O que aparece no produto"
end = content.find(end_marker, start)
if end < 0:
    raise SystemExit("Fim da seção Linux/macOS não encontrado. Nenhuma alteração foi feita.")

new_section = r'''### Linux e macOS

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

'''
content = content[:start] + new_section + content[end:]
readme.write_text(content, encoding="utf-8")
print(f"README atualizado: {readme}")
