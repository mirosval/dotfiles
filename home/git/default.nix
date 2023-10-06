{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Miroslav Zoricak";
    userEmail = "miroslav.zoricak@gmail.com";

    delta = {
      enable = true;
      options = {
        features = "side-by-side line-numbers decorations";
      };
    };

    extraConfig = {
      github.user = "mirosval";
      pull.ff = "only";
      push.autoSetupRemote = "true";
      init.defaultBranch = "main";
    };

    ignores = [
      # Automatically created by GitHub for Mac
      # To make edits, delete these initial comments, or else your changes may be lost!
      "*.DS_Store"
      ".AppleDouble"
      ".LSOverride"

      # Icon must end with two \r
      "Icon"

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
  };
}
