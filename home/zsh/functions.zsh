lyrics ()
{
    golyrics-cli "$(~/.dotfiles/scripts/spotify_full.sh)"
}

mkcd ()
{
    mkdir -p -- "$1" && cd -P -- "$1"
}
