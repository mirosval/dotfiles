{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp-nvim-lsp-signature-help
      cmp-vsnip
      cmp-path
      cmp-buffer
      cmp-treesitter
      vim-vsnip
      plenary-nvim
      aerial-nvim
      vim-tmux-navigator
      todo-comments-nvim
      indent-blankline-nvim
      nvim-autopairs
      nvim-comment
      nvim-surround
      vim-sneak
      text-case-nvim
      lualine-nvim
      nvim-web-devicons
      null-ls-nvim
      lualine-lsp-progress
      gitsigns-nvim
      nvim-nu
      git-blame-nvim
      tokyonight-nvim

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
