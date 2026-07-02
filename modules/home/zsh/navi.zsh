if type "navi" > /dev/null; then
  export NAVI_CONFIG="$HOME/.config/navi/config.yaml"
  eval "$(navi widget zsh)"
else
  echo "Navi not installed"
fi
