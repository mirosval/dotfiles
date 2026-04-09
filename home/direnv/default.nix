{ lib, pkgs, ... }: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
    # NixOS/nixpkgs#507531 - direnv test-fish gets Killed: 9 on darwin after
    # libarchive 3.8.6 update.
    package = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
      pkgs.direnv.overrideAttrs (_: { doCheck = false; })
    );
  };
}
