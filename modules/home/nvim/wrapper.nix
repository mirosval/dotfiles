{ self, inputs, ... }: {
  flake.wrappersModules.neovim = { config, lib, pkgs, ... }:
    let
      unstable = pkgs.extend (_final: super: {
        vimPlugins = super.vimPlugins // {
          gitlinker-nvim = import ./_gitlinker-nvim.nix { inherit pkgs; };
        };
      });
    in
    {
      settings.config_directory = ./config;
      specs.general = import ./_plugins.nix { pkgs = unstable; };
      runtimePkgs = import ./_extra-packages.nix { pkgs = unstable; };
    };

  perSystem = { system, ... }: {
    packages.neovim =
      let unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      in inputs.wrapper-modules.wrappers.neovim.wrap {
        pkgs = unstable;
        imports = [ self.wrappersModules.neovim ];
      };
  };
}
