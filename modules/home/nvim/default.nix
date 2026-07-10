{ ... }: {
  homeModules.nvim = { pkgs, pkgs-unstable, ... }:
  let
    unstable = pkgs-unstable.extend (self: super: {
      vimPlugins = super.vimPlugins // {
        gitlinker-nvim = import ./_gitlinker-nvim.nix { inherit pkgs; };
      };
    });
  in
  {
    programs.neovim = {
      enable = true;
      package = unstable.neovim-unwrapped;
      defaultEditor = true;
      withRuby = false;
      withPython3 = false;
      plugins = import ./_plugins.nix { pkgs = unstable; };
      extraPackages = import ./_extra-packages.nix { pkgs = unstable; };
    };
    xdg.configFile."nvim" = { source = ./config; recursive = true; };
  };
}
