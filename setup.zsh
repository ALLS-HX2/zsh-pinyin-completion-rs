#!/usr/bin/env zsh
emulate -L zsh
set -e

local script_file="${(%):-%N}"
local root="${script_file:A:h}"
local binary_name="bash-pinyin-completion-rs"
local os_name=""
local os_id=""
local os_id_like=""
local brew_cmd=""

if command -v "$binary_name" >/dev/null 2>&1; then
  print -- "Found ${binary_name} in PATH: $(command -v "$binary_name")"
  exit 0
fi

print -u2 -- "zsh-pinyin-completion-rs: ${binary_name} was not found in PATH."

case "$(uname -s)" in
  Darwin)
    print -u2 -- "Install it with Homebrew:"
    print -u2 -- "  brew tap ALLS-HX2/bash-pinyin-completion-rs"
    print -u2 -- "  brew trust ALLS-HX2/bash-pinyin-completion-rs"
    print -u2 -- "  brew install bash-pinyin-completion-rs"
    exit 0
    ;;

  Linux)
    if [[ -r /etc/os-release ]]; then
      local NAME="" ID="" ID_LIKE=""
      source /etc/os-release
      os_name="${NAME:-}"
      os_id="${(L)ID:-}"
      os_id_like="${(L)ID_LIKE:-}"
    fi

    if [[ "$os_name" == "AOSC OS" || "$os_id" == "aosc" ]]; then
      print -u2 -- "AOSC OS usually ships ${binary_name}. If it is missing, install it with:"
      print -u2 -- "  oma install bash-pinyin-completion-rs"
      exit 0
    fi

    if [[ " ${os_id} ${os_id_like} " == *" arch "* ]]; then
      print -u2 -- "Install ${binary_name} from the AUR, for example:"
      print -u2 -- "  yay -S bash-pinyin-completion-rs"
      print -u2 -- "  paru -S bash-pinyin-completion-rs"
      exit 0
    fi

    if command -v brew >/dev/null 2>&1; then
      brew_cmd="$(command -v brew)"
    elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
      brew_cmd="/home/linuxbrew/.linuxbrew/bin/brew"
    elif [[ -x /linuxbrew/.linuxbrew/bin/brew ]]; then
      brew_cmd="/linuxbrew/.linuxbrew/bin/brew"
    fi

    if [[ -n "$brew_cmd" ]]; then
      print -u2 -- "Linuxbrew/Homebrew was detected: ${brew_cmd}"
      print -u2 -- "Install ${binary_name} with Homebrew:"
      print -u2 -- "  ${brew_cmd} tap ALLS-HX2/bash-pinyin-completion-rs"
      print -u2 -- "  ${brew_cmd} trust ALLS-HX2/bash-pinyin-completion-rs"
      print -u2 -- "  ${brew_cmd} install bash-pinyin-completion-rs"
      exit 0
    fi

    print -- "No package manager hint is available for this Linux distribution; building bundled backend."
    exec zsh "${root}/build.zsh"
    ;;

  *)
    print -u2 -- "Unsupported system."
    ;;
esac
