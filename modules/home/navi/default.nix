{ ... }: {
  homeModules.navi = { pkgs, inputs, ... }:
  let
    system = pkgs.stdenv.hostPlatform.system;
    unstable = import inputs.nixpkgs-unstable { inherit system; };
  in
  {
    home.packages = [ unstable.navi ];
    xdg.configFile = {
      "navi/config.yaml".source = ./config.yaml;
      "navi/cheats/common.cheat".source = ./cheats/common.cheat;
    };
  };
}
