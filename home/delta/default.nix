{ pkgs, inputs, ... }:
let
  unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
in
{
  programs.delta = {
    enable = true;
    package = unstable.delta;
    options = {
      navigate = true;
      line-numbers = true;
      side-by-side = true;
    };
    enableJujutsuIntegration = true;
    enableGitIntegration = true;
  };
}
