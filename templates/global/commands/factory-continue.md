# Continuar feature aprovada — Software Factory

Tarefa e solicitação:

$ARGUMENTS

1. Identifique o TASK ID e leia todos os documentos da tarefa.
2. Confirme que existe aprovação humana explícita para exatamente este plano e que o plano não mudou materialmente. Se não houver, pare e peça aprovação.
3. Inspecione `git status` e preserve alterações preexistentes.
4. Acione `developer` com o prompt aprovado; não amplie o escopo.
5. Acione `tech-lead` para revisão técnica.
6. Acione `security-engineer` e `qa-engineer` de forma independente, em paralelo quando possível.
7. Registre PASS/FAIL/BLOCKED/NOT RUN e evidências.
8. Se houver FAIL, envie os achados ao Developer, corrija e repita as validações pertinentes. Faça no máximo 2 ciclos automáticos.
9. Se persistir qualquer bloqueio, pare e peça decisão humana.
10. Se os gates passarem, acione `product-owner` para conferir critérios funcionais e gerar recomendação de aceite.
11. Apresente diff, testes, auditorias, limitações e recomendação final.

Não faça commit, push, merge, release, deploy ou migrations destrutivas. Aguarde decisão humana para essas ações.
