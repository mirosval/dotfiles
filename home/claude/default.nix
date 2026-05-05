{
  pkgs,
  inputs,
  config,
  ...
}:
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
  claude-tmux = pkgs.rustPlatform.buildRustPackage {
    pname = "claude-tmux";
    version = "0.4.0";
    src = pkgs.fetchFromGitHub {
      owner = "nielsgroen";
      repo = "claude-tmux";
      rev = "99a09f2359086e7fafa182d00daf1f3f2b82ff28";
      hash = "sha256-2hibrO+t3MhBO7hEfxjcATUu5W3AWQJG1O7x9Xd9oRM=";
    };
    cargoHash = "sha256-w/imkvK9GNJmEN1+P8/7mF/DOFwjAZlrQvTrEPiIUDA=";
    buildInputs = [ pkgs.openssl ];
    nativeBuildInputs = [ pkgs.pkg-config ];
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
                command = "${config.home.homeDirectory}/.claude/hooks/rtk-rewrite.sh";
              }
            ];
          }
        ];
      };
      fileSuggestion = {
        type = "command";
        command = "${config.home.homeDirectory}/.claude/scripts/file-suggestions.sh";
      };
    };
    skills = {
      rust = ./skills/rust;
    };
  };

  home.file.".claude/scripts/file-suggestions.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      query=$(cat | jq -r '.query')
      fd --type f --hidden --follow --no-require-git | sk --filter "$query" | head -20
    '';
  };

  home.packages = [
    rtk # rtk compresses command output for commonly called commands to save tokens
    claude-tmux
  ];
}
