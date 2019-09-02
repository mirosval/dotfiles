# Dotfiles

![A screenshort of the setup](screenshot.png)

My dotfiles are optimized to use the mouse as little as possible and to make navigating the terminal as pleasant as possible on macOS.

Highlights:

* [Alacritty](https://github.com/jwilm/alacritty)
* [Hasklug Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hasklig)
* Tmux + Neovim integration (navigate using `ctrl-hjkl` between tmux/nvim panels)
* Brewfile
* [Karabiner](https://pqrs.org/osx/karabiner/) and [Hammerspoon](https://www.hammerspoon.org/) (map `caps-lock` to `esc`, move/resize windows, quick shortcuts)

## Contents

* Installation
* Usage

## Installation

There is an `install.sh` that you should be able to just run, but be sure to go through it and review what you actually want, because it is pretty aggressive and not so well tested.

## Usage

### Tmux

I use [TPM](https://github.com/tmux-plugins/tpm) for maintaining plugins, after you start tmux for the first time, you need to press `ctrl-a I` to install the plugins.

Start with `tmux new -s work` or `tmux attach-session -t work` if you have an already running session.

- `ctrl-a c` to create a new tab
- `ctrl-a -` to split vertically
- `ctrl-a |` to split horizontally
- `ctrl-a x` to close a panel
- `ctrl-a ,` to rename a tab
- `ctrl-a C` to clear the screen
- `ctrl-k/j/k/l` to navigate between panels
- `ctrl-a 1/2/3...` to switch to a different tab

### NVim

I use [LanguageClient](https://github.com/autozimu/LanguageClient-neovim) for talking to the LSP Servers.

- `ctrl-k/j/k/l` to navigate between panels
- `\w` save
- `\ew` open current directory viewer
- `\es` open current directory viewer in vertical split
- `\ev` open current directory viewer in horizontal split
- `\;` open LanguageClient context menu
- `K` LanguageClient Hover
- `gd` LanguageClient Go to definition
- LanguageClient formats on save
- `ctrl-p` to trigger fuzzy finder

### Hammerspoon

- `caps-lock-w` Alacritty
- `caps-lock-q` GraphiQL
- `caps-lock-e` IntelliJ IDEA Ultimate
- `caps-lock-t` TablePlus
- `caps-lock-b` Firefox
- `caps-lock-c` Visual Studio Code
- `caps-lock-m` Messages
- `caps-lock-g` Fork
- `caps-lock-s` Slack
- `caps-lock-d` Spotify
- `caps-lock-h` Move window to the left
- `caps-lock-j` Move window to the bottom
- `caps-lock-k` Move window to the top
- `caps-lock-l` Move window to the right
- `caps-lock-f` Maximize window, repeat to cycle through sizes

### Karabiner

- Remap `caps-lock` to `esc` when pressed shortly and to `hyper` when long-pressed.

### Rust utils

I use Rust re-implementations of many standard utilities.

- [bat](https://github.com/sharkdp/bat) like `cat` but prettier
- [exa](https://github.com/ogham/exa) replacement for `ls`
- [fd](https://github.com/sharkdp/fd) replacement for `find`
- [procs](https://github.com/dalance/procs) replacement for `ps`
- [ripgrep](https://github.com/BurntSushi/ripgrep) replacement for `ag`
- [sd](https://github.com/chmln/sd) replacement for `sed`
- [tokei](https://github.com/XAMPPRocky/tokei) for counting lines of code
- [xsv](https://github.com/BurntSushi/xsv) csv manipulation similar to jq
