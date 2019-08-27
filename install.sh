#!/bin/bash

DOTFILES=$HOME/.dotfiles

ln -s $DOTFILES/Brewfile $HOME/.Brewfile
ln -s $DOTFILES/config/alacritty $HOME/.config/alacritty
ln -s $DOTFILES/config/nvim $HOME/.config/nvim
ln -s $DOTFILES/config/nvim/init.vim $HOME/.ideavimrc
ln -s $DOTFILES/config/karabiner $HOME/.config/karabiner
ln -s $DOTFILES/hammerspoon $HOME/.hammerspoon
ln -s $DOTFILES/ctags.symlink $HOME/.ctags
ln -s $DOTFILES/git/ignore $HOME/.gitignore
ln -s $DOTFILES/tmux/tmux.conf.symlink $HOME/.tmux.conf

$DOTFILES/install/osx.sh
$DOTFILES/install/tmux.sh

brew bundle

# After the install setup fzf
echo -e "\\n\\nRunning fzf install script..."
echo "=============================="
/usr/local/opt/fzf/install --all --no-bash --no-fish

# Change the default shell to zsh
zsh_path="$( command -v zsh )"
if ! grep "$zsh_path" /etc/shells; then
    echo "adding $zsh_path to /etc/shells"
    echo "$zsh_path" | sudo tee -a /etc/shells
fi

if [[ "$SHELL" != "$zsh_path" ]]; then
    chsh -s "$zsh_path"
    echo "default shell changed to $zsh_path"
fi

pip3 install neovim sexpdata websocket-client

# Set up vim-plug for neovim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Make Git use SSH Keys over HTTPS
git config --global url."git@github.com:".insteadOf "https://github.com/"
git config --global core.excludesfile '~/.gitignore'
