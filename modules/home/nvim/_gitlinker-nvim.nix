{ pkgs }:
pkgs.vimUtils.buildVimPlugin {
  pname = "gitlinker-nvim";
  version = "v5.4.0";
  src = pkgs.fetchFromGitHub {
    owner = "linrongbin16";
    repo = "gitlinker.nvim";
    rev = "v5.4.0";
    hash = "sha256-7zpVBZ/Hz9uBhdVeMc7a06M3HnXzo3Ah4ylCpDdITZI=";
  };
  doCheck = false;
}
