{ pkgs }:
with pkgs; [
  shellcheck
  bash-language-server dockerfile-language-server
  vscode-langservers-extracted typescript-language-server
  yaml-language-server
  luaformatter lua-language-server lua54Packages.luacheck
  deadnix statix nil
  terraform-lsp taplo yamllint
]
