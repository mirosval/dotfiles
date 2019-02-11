#!/bin/bash

DOTFILES=$HOME/.dotfiles

ln -s $DOTFILES/config/nvim $HOME/.config/nvim
ln -s $DOTFILES/config/karabiner $HOME/.config/karabiner
ln -s $DOTFILES/.hammerspoon $HOME/.hammerspoon
ln -s $DOTFILES/.ctags $HOME/.ctags
ln -s $DOTFILES/git/ignore $HOME/.gitignore

$DOTFILES/install/brew.sh
$DOTFILES/install/osx.sh

sudo sh -c 'echo /usr/local/bin/zsh >> /etc/shells'
chsh -s $(which zsh)

pip3 install neovim sexpdata websocket-client

# Set up vim-plug for neovim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Make Git use SSH Keys over HTTPS
git config --global url."git@github.com:".insteadOf "https://github.com/"
git config --global core.excludesfile '~/.gitignore'
