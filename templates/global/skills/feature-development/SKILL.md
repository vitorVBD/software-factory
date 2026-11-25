---
name: feature-development
description: Coordena o ciclo supervisionado de feature do intake até auditorias independentes e aceite do PO, com aprovação humana antes do código.
---

# Supervised Feature Development

## Gate 1 — Planejamento
- PO prepara requisitos e critérios.
- Architect avalia impactos necessários.
- UX, Database ou DevOps entram apenas quando relevantes.
- Prompt Engineer prepara instruções para Developer.
- Grave os documentos no diretório da tarefa.
- Apresente escopo, riscos, arquivos prováveis, testes e critérios.
- Pare e aguarde aprovação humana explícita.

## Gate 2 — Implementação
- Confirme que a aprovação corresponde ao ID e plano atual.
- Acione Developer com prompt, docs e critérios.
- Registre diff, comandos e resultados reais.
- Tech Lead revisa a implementação.

## Gate 3 — Auditorias
- Execute Security e QA de forma independente, em paralelo quando possível.
- Não permita que Security ou QA alterem o código.
- BLOCKED/NOT RUN não equivale a PASS.
- Qualquer FAIL bloqueia a recomendação de aceite.

## Gate 4 — Correção
- Entregue achados ao Developer.
- Limite a 2 ciclos automáticos de correção e revalidação.
- Se ainda houver bloqueios, pare e peça decisão humana.

## Gate 5 — Produto e entrega
- PO verifica critérios e registra recomendação.
- Apresente os relatórios, pendências e diff.
- Aguarde decisão humana antes de commit, push, merge, release ou deploy.
