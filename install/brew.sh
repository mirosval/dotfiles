#!/usr/bin/env bash

if test ! "$( command -v brew )"; then
    echo "Installing homebrew"
    ruby -e "$( curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install )"
fi
    
formulas=(
    autojump
    bat
    ctags
    direnv
    exa
    fd
    fzf
    fzy
    git
    git-lfs
    jenv
    jq
    neovim
    pipenv
    procs
    python3
    rustup-init
    sbt
    thefuck
    tldr
    tmux
    tree
    watch
    wget
    zsh
    zsh-completions
    zsh-syntax-highlighting
    zsh-autosuggestions
)

cask_formulas=(
    alfred
    cyberduck
    flux
    fork
    hammerspoon
    java
    java8
    jetbrains-toolbox
    karabiner-elements
    quicklook-csv
    quicklook-json
    slack
    the-unarchiver
    typora
    visual-studio-code
    font-hack-nerd-font
)

echo "Installing Brew formulas"

brew tap caskroom/fonts

for formula in "${formulas[@]}"; do
    formula_name=$( echo "$formula" | awk '{print $1}' )
    if brew list "$formula_name" > /dev/null 2>&1; then
        echo "$formula_name already installed... skipping."
    else
        brew install "$formula"
    fi
done

brew install --HEAD olafurpg/scalafmt/scalafmt

echo "Installing Brew Cask formulas"

for formula in "${cask_formulas[@]}"; do
    formula_name=$( echo "$formula" | awk '{print $1}' )
    if brew cask list "$formula_name" > /dev/null 2>&1; then
        echo "$formula_name already installed... skipping."
    else
        brew cask install "$formula"
    fi
done

# After the install setup fzf
echo -e "\\n\\nRunning fzf install script..."
echo "=============================="
/usr/local/opt/fzf/install --all --no-bash --no-fish

# after the install install neovim python libraries
echo -e "\\n\\nRunning Neovim Python install"
echo "=============================="
pip2 install --user neovim
pip3 install --user neovim

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

