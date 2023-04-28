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
      Navigator-nvim
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
      legendary-nvim
      dressing-nvim

      rust-tools-nvim
      (nvim-treesitter.withPlugins (plugins: with plugins; [
      	tree-sitter-bash
      	tree-sitter-css
      	tree-sitter-dockerfile
      	tree-sitter-hcl
      	tree-sitter-json
      	tree-sitter-lua
      	tree-sitter-make
      	tree-sitter-markdown
      	tree-sitter-nix
      	tree-sitter-python
      	tree-sitter-regex
      	tree-sitter-rust
      	tree-sitter-sql
      	tree-sitter-toml
      	tree-sitter-tsx
      	tree-sitter-typescript
      	tree-sitter-yaml
      ]))
      telescope-nvim
    ];
    extraPackages = with pkgs; [
      nodePackages.bash-language-server
      shellcheck

      nodePackages.dockerfile-language-server-nodejs
      nodePackages.vscode-langservers-extracted
      nodePackages.typescript-language-server
      
      luaformatter
      lua-language-server
      lua54Packages.luacheck

      deadnix
      statix
      nil

      terraform-lsp

      # TOML
      taplo-cli

      nodePackages.yaml-language-server
      yamllint
    ];
    # extraConfig = ''
    #   luafile ${builtins.toString ./init.lua}
    # '';
  };

  home.packages = with pkgs; [
    python3Packages.isort
    python3Packages.flake8
    nodePackages.pyright
    black
    mypy
  ];

  xdg.configFile = {
    "nvim/lua" = {
      source = ./lua;
      recursive = true;
    };
    "nvim/init.lua".source = ./init.lua;
  };
}
