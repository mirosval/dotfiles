export DOTFILES=~/.dotfiles
export PATH="$HOME/.local/bin:$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:$PATH"
export NIX_PATH=${NIX_PATH:+$NIX_PATH:}$HOME/.nix-defexpr/channels
# required by tmuxp
export DISABLE_AUTO_TITLE='true'
export RIPGREP_CONFIG_PATH=~/.config/rg/rgrc
