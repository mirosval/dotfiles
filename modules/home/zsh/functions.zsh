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
        awk 'function slug(s) {
                gsub(/[^A-Za-z0-9]+/, "-", s)
                gsub(/^-+|-+$/, "", s)
                return s
            }
            NR==1 {
                i = index($0, ":")
                if (i == 0) exit
                type = slug(substr($0, 1, i - 1))
                summary = slug(tolower(substr($0, i + 1)))
                if (type != "" && summary != "") print type "/" summary
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
