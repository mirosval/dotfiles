{ pkgs, inputs, ... }:
let

  unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
in
{
  programs.claude-code = {
    enable = true;
    package = unstable.claude-code;
    skills = {
      rust = ./skills/rust;
    };
  };
}
