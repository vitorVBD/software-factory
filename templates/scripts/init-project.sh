#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
  cat <<'USAGE'
Uso:
  init-project.sh <caminho-do-projeto> [nome-do-projeto] [opções]
  init-project.sh --project-path <caminho> [opções]

Opções:
  -p, --project-path PATH       Caminho de um diretório de projeto já existente
  -n, --project-name NAME       Nome usado na substituição dos tokens
      --force                   Substitui arquivos existentes, criando backup .bak.<timestamp>
      --include-project-agents  Copia os subagentes para .cursor/agents do projeto
      --include-project-skills  Copia as skills para .cursor/skills do projeto
  -h, --help                    Exibe esta ajuda

Sem --force, arquivos existentes são preservados.
USAGE
}

PROJECT_PATH=''
PROJECT_NAME=''
FORCE=false
INCLUDE_PROJECT_AGENTS=false
INCLUDE_PROJECT_SKILLS=false

while (($#)); do
  case "$1" in
    -p|--project-path)
      (($# >= 2)) || { echo "ERRO: $1 exige um caminho." >&2; exit 2; }
      PROJECT_PATH="$2"; shift 2 ;;
    -n|--project-name)
      (($# >= 2)) || { echo "ERRO: $1 exige um nome." >&2; exit 2; }
      PROJECT_NAME="$2"; shift 2 ;;
    --force)
      FORCE=true; shift ;;
    --include-project-agents)
      INCLUDE_PROJECT_AGENTS=true; shift ;;
    --include-project-skills)
      INCLUDE_PROJECT_SKILLS=true; shift ;;
    -h|--help)
      usage; exit 0 ;;
    --*)
      echo "ERRO: opção desconhecida: $1" >&2; usage >&2; exit 2 ;;
    *)
      if [[ -z "$PROJECT_PATH" ]]; then
        PROJECT_PATH="$1"
      elif [[ -z "$PROJECT_NAME" ]]; then
        PROJECT_NAME="$1"
      else
        echo "ERRO: argumento inesperado: $1" >&2; usage >&2; exit 2
      fi
      shift ;;
  esac
done

if [[ -z "$PROJECT_PATH" || ! -d "$PROJECT_PATH" ]]; then
  echo "ERRO: informe uma pasta de projeto existente." >&2
  usage >&2
  exit 2
fi

PROJECT_PATH="$(cd "$PROJECT_PATH" && pwd -P)"
PROJECT_NAME="${PROJECT_NAME:-$(basename "$PROJECT_PATH")}"
if [[ "$PROJECT_NAME" == *$'\n'* || "$PROJECT_NAME" == *$'\r'* ]]; then
  echo 'ERRO: o nome do projeto não pode conter quebras de linha.' >&2
  exit 2
fi
PROJECT_SLUG="$(printf '%s' "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')"
PROJECT_SLUG="${PROJECT_SLUG:-project}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
FACTORY_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd -P)"
PROJECT_TEMPLATE_DIR="$FACTORY_ROOT/templates/project"
GLOBAL_TEMPLATE_DIR="$FACTORY_ROOT/global"

if [[ ! -d "$PROJECT_TEMPLATE_DIR" ]]; then
  echo "ERRO: scaffold não encontrado: $PROJECT_TEMPLATE_DIR" >&2
  exit 1
fi
if [[ "$INCLUDE_PROJECT_AGENTS" == true && ! -d "$GLOBAL_TEMPLATE_DIR/agents" ]]; then
  echo "ERRO: diretório de subagentes não encontrado: $GLOBAL_TEMPLATE_DIR/agents" >&2
  exit 1
fi
if [[ "$INCLUDE_PROJECT_SKILLS" == true && ! -d "$GLOBAL_TEMPLATE_DIR/skills" ]]; then
  echo "ERRO: diretório de skills não encontrado: $GLOBAL_TEMPLATE_DIR/skills" >&2
  exit 1
fi

COPIED=0
SKIPPED=0
BACKED_UP=0
STAMP="$(date '+%Y%m%d-%H%M%S')"

escape_sed_replacement() {
  local value="$1"
  value="${value//\\/\\\\}"
  value="${value//&/\\&}"
  value="${value//|/\\|}"
  printf '%s' "$value"
}

copy_tree() {
  local source="$1"
  local target="$2"
  local replace_tokens="${3:-false}"
  local file relative destination destination_dir backup suffix
  local escaped_name escaped_slug

  if [[ ! -d "$source" ]]; then
    echo "ERRO: template não encontrado: $source" >&2
    return 1
  fi

  mkdir -p "$target"
  escaped_name="$(escape_sed_replacement "$PROJECT_NAME")"
  escaped_slug="$(escape_sed_replacement "$PROJECT_SLUG")"

  while IFS= read -r -d '' file; do
    relative="${file#"$source"/}"
    destination="$target/$relative"
    destination_dir="$(dirname "$destination")"

    if [[ -e "$destination" || -L "$destination" ]]; then
      if [[ "$FORCE" != true ]]; then
        printf 'SKIP (já existe): %s\n' "$destination"
        ((SKIPPED+=1))
        continue
      fi
      if [[ ! -f "$destination" && ! -L "$destination" ]]; then
        printf 'ERRO: o destino existe e não é um arquivo: %s\n' "$destination" >&2
        return 1
      fi
      backup="$destination.bak.$STAMP"
      suffix=1
      while [[ -e "$backup" || -L "$backup" ]]; do
        backup="$destination.bak.$STAMP.$suffix"
        ((suffix+=1))
      done
      cp -p "$destination" "$backup"
      ((BACKED_UP+=1))
    fi

    mkdir -p "$destination_dir"
    case "$file" in
      *.md|*.mdc|*.txt)
        if [[ "$replace_tokens" == true ]]; then
          sed \
            -e "s|{{PROJECT_NAME}}|$escaped_name|g" \
            -e "s|{{PROJECT_SLUG}}|$escaped_slug|g" \
            "$file" > "$destination"
        else
          cp -p "$file" "$destination"
        fi
        ;;
      *)
        cp -p "$file" "$destination"
        ;;
    esac
    printf 'COPIADO: %s\n' "$destination"
    ((COPIED+=1))
  done < <(find "$source" -type f -print0)
}

printf 'Preparando Software Factory em: %s (%s)\n' "$PROJECT_PATH" "$PROJECT_NAME"
copy_tree "$PROJECT_TEMPLATE_DIR" "$PROJECT_PATH" true

if [[ "$INCLUDE_PROJECT_AGENTS" == true ]]; then
  copy_tree "$GLOBAL_TEMPLATE_DIR/agents" "$PROJECT_PATH/.cursor/agents"
fi
if [[ "$INCLUDE_PROJECT_SKILLS" == true ]]; then
  copy_tree "$GLOBAL_TEMPLATE_DIR/skills" "$PROJECT_PATH/.cursor/skills"
fi

mkdir -p "$PROJECT_PATH/docs/ai/tasks" "$PROJECT_PATH/docs/ai/adr"
printf '\nProjeto preparado: %s\n' "$PROJECT_PATH"
printf 'Resumo: copiados=%s; ignorados=%s; backups=%s\n' "$COPIED" "$SKIPPED" "$BACKED_UP"
printf 'Próximo passo: abra este repositório no Cursor e execute /factory-onboard ou /factory-new.\n'
if [[ "$INCLUDE_PROJECT_AGENTS" != true ]]; then
  echo 'Subagents serão obtidos da instalação global do Cursor Editor.'
fi
