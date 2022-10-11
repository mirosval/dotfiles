alias zshconfig="code ~/.zshrc"

alias l="exa -lah"
alias lg="exa -lah --git"

alias v="nvim . && clear"

alias c="clear ; tmux clear-history ; clear"

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
alias flush="sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# show lyrics for currently playing song
lyrics ()
{
    golyrics-cli "$(~/.dotfiles/scripts/spotify_full.sh)"
}

mkcd ()
{
    mkdir -p -- "$1" && cd -P -- "$1"
}

# Brew
alias buc="brew upgrade && brew cleanup"

# Cargo
alias cb="cargo build"
alias ct="cargo test"
alias cr="cargo run"
alias ctn="cargo test -- --nocapture"
alias cwc="cargo watch -c -x 'check'"
alias cwct="cargo watch -c -x 'check' -x 'test -- --nocapture'"
alias cwctr="cargo watch -c -x 'check' -x 'test -- --nocapture' -x 'run'"

# Git
alias gpl="git pull"
alias gps="git push"
alias gpr="git push && gh pr create --fill --web"
alias gb="git checkout -b"
alias ghv="gh repo view --web"
alias gm="git checkout master || git checkout main"
alias gst="git status"

# tmuxp
alias tl="tmuxp load --yes"

# Restarts coreaudio, use when headphones don't work
alias fix_audio='sudo pkill coreaudiod'

# Docker-compose alias
alias dc='docker-compose'
alias dcu='docker-compose up'
alias dcd='docker-compose down'

# K8s
alias k8='kubectl'
alias km='kubectl -n master'

alias news='w3m https://news.ycombinator.com'

# Julia
alias jp='julia --project=.'
