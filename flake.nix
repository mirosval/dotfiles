{
  description = "Miro's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: 
    let 
      home-common = {lib, ...}: {
        nixpkgs.overlays = [
          (self: super: {
            python310 = super.python310.override {
              packageOverrides = python-self: python-super: {
                libtmux = python-super.libtmux.overrideAttrs (oldAttrs:{
                  doCheck = false;
                  pythonImportsCheck = [];
                  disabledTests = [
                    "test_capture_pane_start"
                  ];
                  disabledTestPaths = [
                    "tests/test_test.py"
                    "tests/legacy_api/test_test.py"
                  ];
                });
              };
            };
            tmuxp = super.tmuxp.overrideAttrs (oldAttrs: {
              src = super.fetchPypi {
                pname = "tmuxp";
                version = "1.27.0";
                hash = "sha256-QAk+rcNYjhAgkJX2fa0bl3dHrB4yyYQ/oNlUX3IQMR8=";
              };
            });
          })
        ];

        programs.home-manager.enable = true;

        imports = [
          ./modules/cli.nix
          ./modules/home.nix
          ./modules/nvim
          ./modules/tmux
          ./modules/zsh
        ];
      };
      system = "aarch64-darwin";
    in 
    {
      defaultPackage.${system} = home-manager.defaultPackage.${system};

      homeConfigurations = {
        "mirosval" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            home-common
          ];
        };
      };
    };
}
