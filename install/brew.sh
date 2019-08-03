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
    neofetch
    neovim
    pipenv
    procs
    python3
    rustup-init
    sbt
    thefuck
    tldr
    tmux
    tokei
    tree
    watch
    wget
    xsv
    zsh
    zsh-autosuggestions
    zsh-completions
    zsh-navigation-tools
    zsh-syntax-highlighting
)

cask_formulas=(
    alfred
    docker
    flux
    font-hasklig-nerd-font
    fork
    graphiql
    hammerspoon
    iterm2
    java
    java8
    jetbrains-toolbox
    karabiner-elements
    netnewswire
    quicklook-csv
    quicklook-json
    slack
    spotify
    tableplus
    the-unarchiver
    visual-studio-code
)

echo "Installing Brew formulas"

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

brew tap homebrew/cask-fonts

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

