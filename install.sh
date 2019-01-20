#!/bin/bash

DOTFILES=$HOME/.dotfiles

ln -s $DOTFILES/config $HOME/.config

brew install neovim
pip3 install neovim sexpdata websocket-client
