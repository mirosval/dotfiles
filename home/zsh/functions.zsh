lyrics ()
{
    golyrics-cli "$(~/.dotfiles/scripts/spotify_full.sh)"
}

mkcd ()
{
    mkdir -p -- "$1" && cd -P -- "$1"
}

# Create jj bookmark from the commit description
jjbk() {
    name=$(jj show --template "description" --no-patch --no-pager | \
        awk -F':' 'NR==1{
            t=tolower($2)
            gsub(/[^a-z0-9]+/,"-",t)
            sub(/^-|-$/,"",t)
            print $1 "/" t
        }')

    if [[ -z $name ]]; then
        print -u2 "Error: there was no description to generate bookmark from"
        return 1
    fi

    jj bookmark create --revision @ "$name"
}

# Push current revision to GH and open browser with the PR link from GH
jjpr ()
{
    jj git push --allow-new 2>&1 | awk '/https:\/\/github.com\/.*\/pull\/new/ {print $2; exit}' | xargs open
}
