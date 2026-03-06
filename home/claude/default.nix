{ pkgs, inputs, ... }:
let
  unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
  rtk = pkgs.rustPlatform.buildRustPackage {
    pname = "rtk";
    version = "0.27.2";
    src = pkgs.fetchFromGitHub {
      owner = "rtk-ai";
      repo = "rtk";
      rev = "v0.27.2";
      hash = "sha256-95vOlmFKgAuGpGQfLTsNdVBVbOQJRuFLzYbrCVwj/iY=";
    };
    cargoHash = "sha256-ygkLwspnSh4sk0jcWFCzJGVtzZ+bTelMqfMT9Jm1lMI=";
    doCheck = false;
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
      hooks = {
        PreToolUse = [
          {
            matcher = "Bash";
            hooks = [
              {
                type = "command";
                command = "/Users/mirosval/.claude/hooks/rtk-rewrite.sh";
              }
            ];
          }
        ];
      };
    };
    skills = {
      rust = ./skills/rust;
    };
  };
  home.packages = [
    rtk # rtk compresses command output for commonly called commands to save tokens
  ];
}
