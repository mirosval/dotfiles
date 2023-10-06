{ pkgs, inputs, ... }:
let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
    overlays = [
      (self: super:
        let
          none-ls-nvim = super.vimUtils.buildVimPlugin {
            pname = "none-ls.nvim";
            version = "2023-10-01";
            src = pkgs.fetchFromGitHub {
              owner = "nvimtools";
              repo = "none-ls.nvim";
              rev = "f39f627bbdfb33cc4ae4a95b4708e7dba7b9aafc";
              sha256 = "1qh9bdxhs0c5mxyyv3dkmiyr03qi8g4rsbjcgzkprk4v5pz04g1v";
            };
          };
        in
        {
          vimPlugins = super.vimPlugins // {
            inherit none-ls-nvim;
          };
        }
      )
    ];
  };
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with unstable.vimPlugins; [
      Navigator-nvim
      aerial-nvim
      cmp-buffer
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-nvim-lua
      cmp-path
      cmp-treesitter
      cmp-vsnip
      comment-nvim
      dressing-nvim
      git-blame-nvim
      gitsigns-nvim
      indent-blankline-nvim
      legendary-nvim
      lualine-lsp-progress
      lualine-nvim
      none-ls-nvim
      nvim-autopairs
      nvim-cmp
      nvim-lspconfig
      nvim-nu
      nvim-surround
      nvim-web-devicons
      plenary-nvim
      text-case-nvim
      todo-comments-nvim
      tokyonight-nvim
      vim-sneak
      vim-vsnip

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
    extraPackages = with unstable; [
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

  home.packages = with unstable; [
    python3Packages.isort
    python3Packages.flake8
    nodePackages.pyright
    black
    mypy
    rnix-lsp
    nixpkgs-fmt
  ];

  xdg.configFile = {
    "nvim/lua" = {
      source = ./lua;
      recursive = true;
    };
    "nvim/init.lua".source = ./init.lua;
  };
}
