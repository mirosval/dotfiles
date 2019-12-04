#!/bin/bash

# This scripts downloads a terminfo database and installs it in ~/.terminfo
# This allows us to have a tmux-256color set as terminal inside tmux
# https://jdhao.github.io/2018/10/19/tmux_nvim_true_color/

curl -LO http://invisible-island.net/datafiles/current/terminfo.src.gz
gunzip terminfo.src.gz
tic -x terminfo.src
rm terminfo.src
