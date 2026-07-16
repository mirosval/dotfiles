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
    jj bookmark track "$name" --remote=origin
}

# Push current revision to GH and open browser with the PR link from GH
jjpr ()
{
    local bm
    bm=$(jj log --no-graph -r @ -T 'local_bookmarks.map(|b| b.name()).join(" ")')
    jj git push --bookmark "$bm" 2>&1 \
        | awk 'match($0, /https:\/\/github\.com\/[^ ]*\/pull\/new\/[^ ]*/){print substr($0,RSTART,RLENGTH); exit}' \
        | xargs open
}
