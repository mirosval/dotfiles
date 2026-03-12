{ pkgs, inputs, ... }:
let
  unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
in
{
  programs.jujutsu = {
    enable = true;
    package = unstable.jujutsu;
    settings = {
      ui = {
        editor = "nvim";
        default-command = "log";
      };
      git.sign-on-push = true;
    };
  };
}
