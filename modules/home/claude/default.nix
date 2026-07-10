{ ... }: {
  homeModules.claude = { pkgs, pkgs-unstable, config, lib, ... }:
  let
    skillNames = builtins.attrNames
      (lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./skills));
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
      package = pkgs-unstable.claude-code;
      settings = {
        env.ENABLE_LSP_TOOL = "1";
        enabledPlugins."rust-analyzer-lsp@claude-plugins-official" = true;
        hooks.PreToolUse = [
          {
            matcher = "Bash";
            hooks = [{
              type = "command";
              command = "${pkgs-unstable.rtk}/bin/rtk hook claude";
            }];
          }
        ];
        fileSuggestion = {
          type = "command";
          command = "${config.home.homeDirectory}/.claude/scripts/file-suggestions.sh";
        };
      };
      skills = lib.genAttrs skillNames (name: ./skills + "/${name}");
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
      pkgs-unstable.rtk
      claude-tmux
    ];
  };
}
