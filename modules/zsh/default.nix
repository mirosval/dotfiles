{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    shellAliases = import ./aliases.nix;
    initExtraBeforeCompInit = ''
      ${builtins.readFile ./session_variables.zsh}
      ${builtins.readFile ./functions.zsh}
      ${if pkgs.stdenv.isDarwin then builtins.readFile ./session_variables.mac.zsh else ""}
      # eval $(direnv hook zsh)
      eval $(starship init zsh)
    '';
  };
}
