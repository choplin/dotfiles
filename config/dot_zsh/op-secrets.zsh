# 1Password secrets (macOS only)
# Run `op-secrets-refresh` to resolve secrets from 1Password and cache them.
if [[ ${OSTYPE} == darwin* ]]; then
  _op_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/op-secrets"
  if [[ -f "$_op_cache" ]]; then
    source "$_op_cache"
  fi

  op-secrets-refresh() {
    local tpl="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/op-secrets.tpl"
    local cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/op-secrets"
    if [[ ! -f "$tpl" ]]; then
      echo "Template not found: $tpl" >&2
      return 1
    fi
    mkdir -p "${cache:h}"
    op inject --in-file "$tpl" > "$cache" 2>/dev/null || { echo "op inject failed. Is 1Password unlocked?" >&2; return 1; }
    chmod 600 "$cache"
    source "$cache"
    echo "Secrets refreshed and cached."
  }

  unset _op_cache
fi
