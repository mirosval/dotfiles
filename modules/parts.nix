{ inputs, lib, ... }: {
  # nixosConfigurations is already declared by flake-parts/nixpkgs-lib.
  # darwinConfigurations is not, so declare it here to allow merging
  # sub-keys across multiple host modules.
  options.flake.darwinConfigurations = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = {};
  };

  # darwin.nix sets darwinModules.shared; host modules read it.
  options.darwinModules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = {};
  };

  # Each home/*/default.nix contributes one key to homeModules.
  # home.nix composes them all into homeConfig for host modules to consume.
  options.homeModules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.deferredModule;
    default = {};
  };

  options.homeConfig = lib.mkOption {
    type = lib.types.deferredModule;
    default = {};
  };

  config = {
    systems = [ "aarch64-darwin" "aarch64-linux" ];

    perSystem = { system, ... }: {
      _module.args.pkgs = import inputs.nixpkgs { inherit system; };
    };
  };
}
