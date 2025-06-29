{ pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    # enableAutosuggestions = true;
    autosuggestion.enable = true;
    shellAliases = import ./aliases.nix;
    initContent = lib.mkOrder 550 ''
      ${builtins.readFile ./session_variables.zsh}
      ${builtins.readFile ./functions.zsh}
      ${builtins.readFile ./navi.zsh}
      ${if pkgs.stdenv.isDarwin then builtins.readFile ./session_variables.mac.zsh else ""}
    '';
  };
}
