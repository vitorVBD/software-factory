# Factory Init â€” Software Factory

Escopo ou descriÃ§Ã£o inicial (opcional):

$ARGUMENTS

Inicialize a estrutura da Software Factory no workspace atual:
1. Identifique o caminho absoluto da raiz do workspace atual e o nome da pasta raiz.
2. Verifique se `AGENTS.md` e `.cursor/rules` jÃ¡ existem na raiz do projeto.
3. Se ainda não existirem, execute no terminal conforme o sistema operacional do ambiente:
   - **Windows:** `powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.cursor\factory-templates\scripts\init-project.ps1" -ProjectPath "<CAMINHO_DO_WORKSPACE>" -ProjectName "<NOME_DA_PASTA>"`
   - **Linux / macOS:** `bash "$HOME/.cursor/factory-templates/scripts/init-project.sh" "<CAMINHO_DO_WORKSPACE>" "<NOME_DA_PASTA>"`
4. Verifique se o workspace jÃ¡ possui cÃ³digo-fonte de aplicaÃ§Ã£o (ex.: `package.json`, `composer.json`, `requirements.txt`, `src/`, `app/`, etc.):
   - **Se houver cÃ³digo existente:** execute o fluxo de `/factory-onboard`[cite: 6].
   - **Se a pasta estiver vazia (projeto do zero):** execute o fluxo de `/factory-new` repassando `$ARGUMENTS`.
