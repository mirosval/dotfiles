{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    # enableSyntaxHighlighting = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    shellAliases = import ./aliases.nix;
    initExtraBeforeCompInit = ''
      ${builtins.readFile ./session_variables.zsh}
      ${builtins.readFile ./functions.zsh}
      ${builtins.readFile ./navi.zsh}
      ${if pkgs.stdenv.isDarwin then builtins.readFile ./session_variables.mac.zsh else ""}
    '';
  };
}
