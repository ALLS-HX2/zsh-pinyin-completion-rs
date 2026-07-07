if [[ -z ${ZSH_VERSION-} ]]; then
  return 0
fi

typeset _zsh_pinyin_completion_init_file="${(%):-%N}"
typeset -g ZSH_PINYIN_COMPLETION_ROOT="${_zsh_pinyin_completion_init_file:A:h}"
unset _zsh_pinyin_completion_init_file

if (( ! ${fpath[(Ie)${ZSH_PINYIN_COMPLETION_ROOT}/functions]} )); then
  fpath=("${ZSH_PINYIN_COMPLETION_ROOT}/functions" "${fpath[@]}")
fi

autoload -Uz \
  _pinyin_add_completion \
  _pinyin_expand_env_refs \
  _pinyin_find_binary \
  _pinyin_wrap_path_files

if ! ZSH_PINYIN_COMPLETION_BIN="$(_pinyin_find_binary)"; then
  typeset -g ZSH_PINYIN_COMPLETION_DISABLED=1
  print -u2 -- "zsh-pinyin-completion-rs: bash-pinyin-completion-rs not found in PATH or plugin directory; pinyin completion disabled for this shell session."
  return 0
fi

typeset -g ZSH_PINYIN_COMPLETION_BIN
unset ZSH_PINYIN_COMPLETION_DISABLED

if ! _pinyin_wrap_path_files 2>/dev/null; then
  autoload -Uz add-zsh-hook

  _zsh_pinyin_completion_deferred_wrap() {
    if _pinyin_wrap_path_files 2>/dev/null; then
      add-zsh-hook -d precmd _zsh_pinyin_completion_deferred_wrap
      unfunction _zsh_pinyin_completion_deferred_wrap 2>/dev/null || true
    fi
  }

  add-zsh-hook precmd _zsh_pinyin_completion_deferred_wrap
fi
