# Triagem de Tarefas (Fast-Track vs. Full-Pipeline) — Software Factory

Filtro ou observações (opcional):

$ARGUMENTS

Não altere código de aplicação e não acione subagentes especialistas. Faça uma análise rápida e objetiva do backlog existente.

1. Leia todos os arquivos `00-overview.md` e `01-requirements.md` dentro de `docs/ai/tasks/` que ainda não estejam com status `DONE`.
2. Classifique cada tarefa em um dos dois modos de execução usando estes critérios:
   - **`/factory-fast` (Modo Enxuto):** CRUDs padrão, telas/formulários que seguem componentes existentes, filtros, listagens, ajustes de UI/UX, validações simples ou endpoints que replicam padrões já consolidados no projeto.
   - **`/factory-feature` (Fluxo Completo):** Alterações críticas de banco de dados/migrations complexas, autenticação/permissões/RBAC, regras financeiras/faturamento, integrações externas/webhooks, upload/processamento sensível ou mudanças arquiteturais inéditas.
3. Registre uma linha `**Modo Recomendado:** /factory-fast` (ou `/factory-feature`) no topo de cada `00-overview.md` analisado para servir de referência futura.
4. Apresente uma tabela consolidada ordenada pela prioridade de execução contendo:
   - `TASK ID`
   - `Título`
   - `Escopo` (Backend / Frontend / Ambos)
   - `Modo Recomendado` (`/factory-fast` ou `/factory-feature`)
   - `Justificativa` (1 frase curta explicando o risco ou simplicidade)
5. Ao final, indique qual é a primeira tarefa da fila e já deixe o comando exato pronto para o usuário copiar e executar.