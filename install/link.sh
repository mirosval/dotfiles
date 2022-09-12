#!/usr/bin/env bash

DOTFILES="$HOME/.dotfiles"

if [[ "$(pwd)" != "$DOTFILES" ]] ; then
    echo "Please run this script from $DOTFILES"
    exit 1
fi

config_dirs=(
    ".config"
    ".config/alacritty"
    ".config/fd"
    ".config/git"
    ".config/karabiner"
    ".config/nvim"
    ".config/nvim/lua"
    ".config/nvim/lua/lang"
    ".config/nvim/lua/plugs"
    ".config/tmuxp"
    ".config/zellij"
    ".hammerspoon"
    ".hammerspoon/Spoons"
    ".config/k9s"
)

echo "Creating Directories"
echo "--------------------"
for config_dir in "${config_dirs[@]}" ; do
    config_dir="$HOME/$config_dir"
    if [[ -e $config_dir  ]] ; then
        echo "$config_dir already exists, not creating"
    else
        echo "Creating $config_dir"
        mkdir -p "$config_dir"
    fi
done

links=(
    "Brewfile .Brewfile"
    "config/alacritty/alacritty.yml .config/alacritty/alacritty.yml"
    "config/fd/ignore .config/fd/ignore"
    "config/flake8 .config/flake8"
    "config/git/config .config/git/config"
    "config/git/ignore .config/git/ignore"
    "config/karabiner/karabiner.json .config/karabiner/karabiner.json"
    "config/nvim/init.lua .config/nvim/init.lua"
    "config/nvim/lua/lib.lua .config/nvim/lua/lib.lua"
    "config/nvim/lua/diag.lua .config/nvim/lua/diag.lua"
    "config/nvim/lua/lang/rust.lua .config/nvim/lua/lang/rust.lua"
    "config/nvim/lua/opts.lua .config/nvim/lua/opts.lua"
    "config/nvim/lua/plug.lua .config/nvim/lua/plug.lua"
    "config/nvim/lua/lsp.lua .config/nvim/lua/lsp.lua"
    "config/nvim/lua/plugs/aerial_setup.lua .config/nvim/lua/plugs/aerial_setup.lua"
    "config/nvim/lua/plugs/cmp_setup.lua .config/nvim/lua/plugs/cmp_setup.lua"
    "config/nvim/lua/plugs/telescope_setup.lua .config/nvim/lua/plugs/telescope_setup.lua"
    "config/nvim/lua/plugs/tmux_setup.lua .config/nvim/lua/plugs/tmux_setup.lua"
    "config/nvim/lua/plugs/tree_sitter_setup.lua .config/nvim/lua/plugs/tree_sitter_setup.lua"
    "config/nvim/lua/plugs/todo_comments_setup.lua .config/nvim/lua/plugs/todo_comments_setup.lua"
    "config/nvim/lua/plugs/text_case_setup.lua .config/nvim/lua/plugs/text_case_setup.lua"
    "config/nvim/lua/plugs/lualine_setup.lua .config/nvim/lua/plugs/lualine_setup.lua"
    "config/pycodestyle .config/pycodestyle"
    "config/starship.toml .config/starship.toml"
    "config/tmuxp/dotfiles.yaml .config/tmuxp/dotfiles.yaml"
    "config/zellij/config.yaml .config/zellij/config.yaml"
    "ctags.symlink .ctags"
    "config/k9s/views.yml .config/k9s/views.yml"
    "hammerspoon/init.lua .hammerspoon/init.lua"
    "hammerspoon/Spoons/Caffeine.spoon .hammerspoon/Spoons/Caffeine.spoon"
    "hammerspoon/Spoons/MiroWindowsManager.spoon .hammerspoon/Spoons/MiroWindowsManager.spoon"
    "rgrc.symlink .rgrc"
    "tmux/tmux.conf.symlink .tmux.conf"
    "zsh/zshrc.symlink .zshrc"
)

echo 
echo "Creating Symlinks"
echo "--------------------"
for link in "${links[@]}" ; do
    set -- $link
    src="$DOTFILES/$1"
    dst="$HOME/$2"
    if [[ -e $dst ]] ; then
        echo "$dst already exists, skipping"
    else
        echo "Linking $src to $dst"
        ln -s "$src" "$dst"
    fi
done

echo
echo "Linking vim"
echo "--------------------"

linkables=$( find -H config/nvim -name '*' -maxdepth 1 -depth 1 )
for file in $linkables ; do
    target="$HOME/.$file"
    if [[ -e "$target" ]]; then
        echo "~${target} already exists, skipping"
    else
        echo "Linking $file to $target"
        ln -s "$DOTFILES/$file" "$target"
    fi
done

echo "Linking nvim init.vim to .ideavimrc"
ln -s "$DOTFILES/config/nvim/init.vim" "$HOME/.ideavimrc"

echo "Linking navi cheatsheets"
NAVI_CHEATS_PATH="$(navi info cheats-path)/mirosval/common.cheat"
mkdir -p "$(basedir NAVI_CHEATS_PATH)"
[[ -e $NAVI_CHEATS_PATH ]] || ln -s "$DOTFILES/cheats/common.cheat" "$NAVI_CHEATS_PATH"

