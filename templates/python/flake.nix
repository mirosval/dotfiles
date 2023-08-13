{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let 
        pkgs = import nixpkgs {
          system = system;
        };
      in
      {
        packages.default = pkgs.hello;
        devShells.default = pkgs.mkShellNoCC {
          packages = [
            pkgs.poetry
          ];
        }; 
      }
    );
}
