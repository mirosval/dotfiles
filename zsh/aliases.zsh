
alias zshconfig="code ~/.zshrc"

alias k="k -h"
alias l="exa -lah"
alias v="nvim ."

alias did="vim +'normal Go' +'r!date' ~/did.txt"

# use nvim, but don't make me think about it
alias vim="nvim"

# Filesystem aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....="cd ../../.."
alias .....="cd ../../../.."

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en1"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

mkcd ()
{
    mkdir -p -- "$1" && cd -P -- "$1"
}

# Git
alias gst="git status"

# Restarts coreaudio, use when headphones don't work
alias fix_audio='sudo pkill coreaudiod'

# Docker-compose alias
alias dc='docker-compose'

# K8s
alias k8='kubectl'
alias km='kubectl -n master'
