lyrics ()
{
    golyrics-cli "$(~/.dotfiles/scripts/spotify_full.sh)"
}

mkcd ()
{
    mkdir -p -- "$1" && cd -P -- "$1"
}

# Create jj bookmark from the commit description
jjbk ()
{
    name=$(jj show --template "description" --no-pager | awk -F':' 'NR==1{t=tolower($2); gsub(/[^a-z0-9]+/,"-",t); sub(/^-|-$/,"",t); print $1"/"t}')
    jj bookmark create $name
}
