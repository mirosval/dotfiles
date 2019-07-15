# Completion menu
zmodload -i zsh/complist

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# default to file completion
zstyle ':completion:*' completer _expand _complete _files _correct _approximate

zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

# Kubernetes
if [ /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi

# Homebrew
fpath=(/usr/local/share/zsh/site-functions $fpath)
fpath=(/usr/local/share/zsh-completions $fpath)
