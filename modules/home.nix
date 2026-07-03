{ config, ... }: {
  config.homeConfig = { ... }: {
    imports = builtins.attrValues config.homeModules;
    home.stateVersion = "24.05";
  };
}
