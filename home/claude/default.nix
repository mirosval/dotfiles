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
    settings = {
      env = {
        ENABLE_LSP_TOOL = "1";
      };
      enabledPlugins = {
        "rust-analyzer-lsp@claude-plugins-official" = true;
      };
    };
    skills = {
      rust = ./skills/rust;
    };
  };
}
