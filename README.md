# zsh-pinyin-completion-rs

这是一个基于安同 OS（AOSC OS） `bash-pinyin-completion-rs` 组件的 zsh 补全插件。插件会增强 zsh 原有的路径补全：当您输入拼音并按下 <kbd>Tab</kbd> 时，它会把当前目录中的文件名和目录名交给 Rust 后端匹配，并把匹配到的中文候选加入补全列表。

纯 vibe 开发。不保证能用。

### 功能

- 为 zsh 文件路径补全增加拼音匹配。
- 保留 zsh 原生补全结果，不替换系统补全行为。
- 支持全拼和 `bash-pinyin-completion-rs` 提供的双拼方案。
- 优先使用系统 `PATH` 中已有的 `bash-pinyin-completion-rs`。

### 使用 zimfw 安装

在 `~/.zimrc` 中加入：

```bash
zmodule ALLS-HX2/zsh-pinyin-completion-rs --on-pull 'zsh setup.zsh'
```

然后执行：

```bash
zimfw install
```

更新插件时：

```bash
zimfw update
```

`setup.zsh` 会在安装或更新时检查 `bash-pinyin-completion-rs` 是否可用，并根据系统给出安装建议或自动构建。

### 后端获取策略

插件依赖 `bash-pinyin-completion-rs` 。初始化时会按以下顺序查找：

1. 系统 `PATH` 中的 `bash-pinyin-completion-rs`。
2. 插件目录下的 `bin/bash-pinyin-completion-rs`。
3. 插件内部子模块目录下的 `bash-pinyin-completion-rs/target/release/bash-pinyin-completion-rs`。

安装插件时会运行 `setup.zsh`，检测并提示用户安装依赖：

- AOSC OS：伟大的本家！通常情况下系统会自带。如果缺失，可执行：

  ```bash
  oma install bash-pinyin-completion-rs
  ```

- macOS：您可以通过 [Homebrew Tap](https://github.com/ALLS-HX2/homebrew-bash-pinyin-completion-rs) 安装二进制包：

  ```bash
  brew tap ALLS-HX2/bash-pinyin-completion-rs
  brew trust ALLS-HX2/bash-pinyin-completion-rs
  brew install bash-pinyin-completion-rs
  ```

- Arch 系发行版：您可以通过 AUR 安装，例如：

  ```bash
  yay -S bash-pinyin-completion-rs
  # 或
  paru -S bash-pinyin-completion-rs
  ```

- 其他 Linux 发行版：检测是否有 Linuxbrew，若有则使用 Linuxbrew 从源码构建安装，若无则调用 `build.zsh` 从插件内部子模块目录下的源码构建（系统中需要先安装 Rust 语言相关工具链，例如 `rustup` 或 `cargo`）。

### 手动加载

如果您不使用 zimfw，也可以手动克隆并加载：

```bash
git clone --recursive https://github.com/ALLS-HX2/zsh-pinyin-completion-rs.git ~/.zsh-pinyin-completion-rs
zsh ~/.zsh-pinyin-completion-rs/setup.zsh
source ~/.zsh-pinyin-completion-rs/init.zsh
```

要长期启用，请把 `source ~/.zsh-pinyin-completion-rs/init.zsh` 放入您的
`~/.zshrc`。

### 配置拼音方案

`bash-pinyin-completion-rs` 通过 `PINYIN_COMP_MODE` 配置拼音方案。如果未设置或值无效，默认使用 `Quanpin`。

关于拼音方案的配置详情，敬请参阅 [上游的配置说明](https://github.com/AOSC-Dev/bash-pinyin-completion-rs#configuring-pinyin-schema)。

如果您使用双拼的话，请在 `zshenv` 配置环境变量设置您喜欢的双拼方案，例如小鹤双拼：

```bash
export PINYIN_COMP_MODE="ShuangpinXiaohe"
```

您也可以同时启用全拼和一种双拼方案，例如：

```bash
export PINYIN_COMP_MODE="Quanpin,ShuangpinXiaohe"
```

可用方案包括：

- `Quanpin`
- `ShuangpinAbc`
- `ShuangpinJiajia`
- `ShuangpinMicrosoft`
- `ShuangpinThunisoft`
- `ShuangpinXiaohe`
- `ShuangpinZrm`

注意：如果启用了任意双拼方案，全拼的前缀匹配会被关闭。多个双拼方案同时启用时，只有第一个双拼方案生效。

### 故障排查

- 如果启动 zsh 时看到后端未找到的提示，请先运行 `zsh setup.zsh`，或按系统提示安装 `bash-pinyin-completion-rs`。
- 如果需要本地构建，请确认 `cargo` 可用。
- 如果是手动克隆，请确认使用了 `--recursive`，或执行过 `git submodule update --init --recursive`。
- 修改 `PINYIN_COMP_MODE` 后，请重新打开 shell，或重新 source 您的 zsh 配置。

### 致谢

本插件的核心匹配功能基于 [`AOSC-Dev/bash-pinyin-completion-rs`](https://github.com/AOSC-Dev/bash-pinyin-completion-rs) 开发，匹配能力基于 `ib-matcher`/IbPinyinLib。

本插件与安同开源社区和 AOSC OS 没有关系。

### License

[GPLv3](./LICENSE)。
