function md() {
    mkdir -p $1
    cd $1
}

# Start an HTTP server from a directory, optionally specifying the port
function server() {
    local port="${1:-8000}"
    open "http://localhost:${port}/"
    # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
    # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
    python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}

# All the dig info
function digga() {
    dig +nocmd "$1" any +multiline +noall +answer
}

# This function creates the pyrightconfig.json file for the current directory
# it only works if the current directory is a poetry project
#
# The purpose of these settings is to make the pyright LSP in neovim work with
# the installed dependencies in the poetry project
function pyright_venv() {
    jq \
      --null-input \
      --arg venv "$(basename $(poetry env info -p))" \
      --arg venvPath "$(dirname $(poetry env info -p))" \
      '{ "venv": $venv, "venvPath": $venvPath }' \
      > pyrightconfig.json
}
