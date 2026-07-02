{ ... }: {
  homeModules.git = _: {
    programs.git = {
      enable = true;
      settings = {
        user.name = "Miroslav Zoricak";
        user.email = "1315417+mirosval@users.noreply.github.com";
        github.user = "mirosval";
        pull.ff = "only";
        push.autoSetupRemote = "true";
        init.defaultBranch = "main";
        commit.gpgsign = true;
        gpg.format = "ssh";
        user.signingkey = "~/.ssh/id_ed25519.pub";
      };
      ignores = [
        "*.DS_Store"
        ".AppleDouble"
        ".LSOverride"
        "Icon

"
        "._*"
        ".DocumentRevisions-V100"
        ".fseventsd"
        ".Spotlight-V100"
        ".TemporaryItems"
        ".Trashes"
        ".VolumeIcon.icns"
        ".com.apple.timemachine.donotpresent"
        ".AppleDB"
        ".AppleDesktop"
        "Network Trash Folder"
        "Temporary Items"
        ".apdisk"
      ];
    };
    programs.gh = {
      enable = true;
      settings = {
        version = "1";
      };
    };
  };
}
