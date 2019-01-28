#!/bin/bash

DOTFILES=$HOME/.dotfiles

ln -s $DOTFILES/config/nvim $HOME/.config/nvim
ln -s $DOTFILES/config/karabiner $HOME/.config/karabiner
ln -s $DOTFILES/.hammerspoon $HOME/.hammerspoon
ln -s $DOTFILES/.ctags $HOME/.ctags

brew install neovim
pip3 install neovim sexpdata websocket-client
