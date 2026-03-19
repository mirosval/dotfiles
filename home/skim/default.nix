{ pkgs, inputs, ... }:
let
  unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
in
{
  programs.skim = {
    enable = true;
    enableZshIntegration = true;
    package = unstable.skim;
  };
}
