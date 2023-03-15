{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-cmp
      rust-tools-nvim
      (nvim-treesitter.withPlugins (plugins: with plugins; [
      	tree-sitter-bash
      	tree-sitter-css
      	tree-sitter-dockerfile
      	tree-sitter-json
      	tree-sitter-lua
      	tree-sitter-nix
      	tree-sitter-python
      	tree-sitter-regex
      	tree-sitter-rust
      	tree-sitter-sql
      	tree-sitter-toml
      	tree-sitter-typescript
      	tree-sitter-yaml
      ]))
      telescope-nvim
    ];
    extraConfig = ''
      luafile ${builtins.toString ./init.lua}
    '';
  };

  xdg.configFile = {
    "nvim/lua" = {
      source = ./lua;
      recursive = true;
    };
    "nvim/init.lua".source = ./init.lua;
  };
}
