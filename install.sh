#!/bin/bash

DOTFILES=$HOME/.dotfiles

ln -s $DOTFILES/config/nvim $HOME/.config/nvim
ln -s $DOTFILES/config/karabiner $HOME/.config/karabiner

brew install neovim
pip3 install neovim sexpdata websocket-client
