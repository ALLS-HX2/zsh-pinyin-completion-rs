#!/usr/bin/env zsh
emulate -L zsh
set -e

0=${(%):-%N}
local root="${0:A:h}"
local backend_dir="${root}/bash-pinyin-completion-rs"
local binary_name="bash-pinyin-completion-rs"
local bin_dir="${root}/bin"
local plugin_binary="${bin_dir}/${binary_name}"

if [[ ! -d "$backend_dir" ]]; then
  print -u2 -- "backend directory not found: ${backend_dir}"
  exit 1
fi

if ! command -v cargo >/dev/null 2>&1; then
  print -u2 -- "cargo is required to build ${binary_name}"
  exit 1
fi

(
  cd "$backend_dir"
  cargo build --release
)

mkdir -p "$bin_dir"
ln -sf "../bash-pinyin-completion-rs/target/release/${binary_name}" "$plugin_binary"

print -- "Built ${plugin_binary}"
