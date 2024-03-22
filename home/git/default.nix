_:
{
  programs.git = {
    enable = true;
    userName = "Miroslav Zoricak";
    userEmail = "1315417+mirosval@users.noreply.github.com";

    extraConfig = {
      github.user = "mirosval";
      pull.ff = "only";
      push.autoSetupRemote = "true";
      init.defaultBranch = "main";
      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_ed25519.pub";
      diff.external = "difft";
    };

    ignores = [
      # Automatically created by GitHub for Mac
      # To make edits, delete these initial comments, or else your changes may be lost!
      "*.DS_Store"
      ".AppleDouble"
      ".LSOverride"

      # Icon must end with two \r
      "Icon

"

      # Thumbnails
      "._*"

      # Files that might appear in the root of a volume
      ".DocumentRevisions-V100"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".VolumeIcon.icns"
      ".com.apple.timemachine.donotpresent"

      # Directories potentially created on remote AFP share
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
      version = "1"; # this should prevent conflicts between the config written by gh and nix
    };
  };
}
