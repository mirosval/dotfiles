{ config, inputs, ... }: {
  config.homeConfig = { pkgs, ... }: {
    imports = builtins.attrValues config.homeModules;
    _module.args.inputs = inputs;
    _module.args.pkgs-unstable = import inputs.nixpkgs-unstable {
      system = pkgs.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
    home.stateVersion = "24.05";
  };
}
