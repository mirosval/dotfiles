#!/bin/bash

# Install nix
if ! command -v nix &> /dev/null
then
    echo "installing nix"
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
      | sh -s -- install
fi

#nix run . switch -- --flake .
#exec ${SHELL} -l


# OLD
# DOTFILES=$HOME/.dotfiles
# 
# $DOTFILES/install/link.sh
# $DOTFILES/install/osx.sh
# $DOTFILES/install/tmux.sh
# 
# brew bundle
# 
# # After the install setup fzf
# echo -e "\\n\\nRunning fzf install script..."
# echo "=============================="
# /usr/local/opt/fzf/install --all --no-bash --no-fish
# 
# # Change the default shell to zsh
# zsh_path="$( command -v zsh )"
# if ! grep "$zsh_path" /etc/shells; then
#     echo "adding $zsh_path to /etc/shells"
#     echo "$zsh_path" | sudo tee -a /etc/shells
# fi
# 
# if ; then
#     chsh -s "$zsh_path"
#     echo "default shell changed to $zsh_path"
# fi
# 
# # Python
# PYTHON_VERSION='3.8.0'
# pyenv install --skip-existing $PYTHON_VERSION
# pyenv global $PYTHON_VERSION
# 
# # Neovim
# pyenv exec python -m pip install \
#     neovim \
#     sexpdata \
#     websocket-client \
#     'python-language-server[all]' \
#     pyls-isort 
# 
# npm install -g \
#     bash-language-server \
#     dockerfile-language-server-nodejs \
#     eslint \
#     javascript-typescript-langserver \
#     ls_emmet \
#     neovim \
#     typescript \
#     typescript-language-server \
#     vscode-langservers-extracted \
#     yaml-language-server
# 
# # Go
# go install "github.com/juliosueiras/terraform-lsp"
# 
# # Set up vim-plug for neovim
# curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
#     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# 
# # Fix tmux colors
# /opt/homebrew/Cellar/ncurses/6.3/bin/infocmp -x tmux-256color > tmux/tmux-256color.src
# sudo /usr/bin/tic -x tmux/tmux-256color.src
