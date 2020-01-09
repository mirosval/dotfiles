#!/usr/bin/env bash

DOTFILES="$HOME/.dotfiles"

if [[ "$(pwd)" != "$DOTFILES" ]] ; then
    echo "Please run this script from $DOTFILES"
    exit 1
fi

config_dirs=(
    ".config"
    ".config/alacritty"
    ".config/karabiner"
    ".config/nvim"
    ".hammerspoon"
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
    "config/flake8 .config/flake8"
    "config/karabiner/karabiner.json .config/karabiner/karabiner.json"
    "config/pycodestyle .config/pycodestyle"
    "config/starship.toml .config/starship.toml"
    "ctags.symlink .ctags"
    "git/ignore .gitignore"
    "hammerspoon .hammerspoon"
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



