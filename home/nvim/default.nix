{ pkgs, inputs, ... }:
let
  unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
    config. allowUnfree = true;
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
          renerocksai-calendar-vim = super.vimUtils.buildVimPlugin {
            pname = "calendar-vim";
            version = "2021-11-27";
            src = pkgs.fetchFromGitHub {
              owner = "renerocksai";
              repo = "calendar-vim";
              rev = "a7e73e02c92566bf427b2a1d6a61a8f23542cc21";
              hash = "sha256-4XeDd+myM+wtHUsr3s1H9+GAwIjK8fAqBbFnBCeatPo=";
            };
          };
        in
        {
          vimPlugins = super.vimPlugins // {
            inherit none-ls-nvim renerocksai-calendar-vim;
          };
        }
      )
    ];
  };
in
{
  programs.neovim = {
    enable = true;
    package = unstable.neovim-unwrapped;
    defaultEditor = true;
    plugins = with unstable.vimPlugins; [
      Navigator-nvim # Tmux window switching
      aerial-nvim # Project outline
      auto-hlsearch-nvim # Clear search highlighting on cursor movement
      cmp-buffer # Code completion from current buffer
      cmp-nvim-lsp # Code completion from LSP
      cmp-nvim-lsp-signature-help # Help overlay for Code Completion
      cmp-nvim-lua # Code completion for Neovim Lua API
      cmp-path # Code completion for paths
      cmp-treesitter # Code completion from treesitter nodes
      cmp-vsnip # Code completion snippets integration
      comment-nvim # Language-based comments toggle
      crates-nvim # Rust Cargo.toml companion - updates and docs for dependencies
      dressing-nvim # Makes native nvim UI look better
      fidget-nvim # LSP Progress spinner
      git-blame-nvim # Show git-blame in virtual text
      gitsigns-nvim # Highlight code changes vs git
      indent-blankline-nvim # Highlight leading whitespace for better visual block separation
      legendary-nvim # Action dispatcher and key binding manager
      lualine-nvim # Status line config
      none-ls-nvim # Integration of linters into the LSP stack
      nvim-autopairs # Parentheses come in pairs
      nvim-cmp # Code completion
      nvim-lspconfig # LSP Client configurations
      nvim-metals # Scala LSP
      nvim-nu # Nu scripting language support
      nvim-surround # Change both surrounding parentheses at once
      nvim-ts-autotag # Auto-close HTML tags
      nvim-web-devicons # Eye candy
      plenary-nvim # Utility lua function
      renerocksai-calendar-vim # Calendar integration for Telekasten
      rustaceanvim # Rust enhancements beyond LSP
      telekasten-nvim # Note taking
      telescope-nvim # Fuzzy finder
      text-case-nvim # Switch between word casing 
      todo-comments-nvim # TODO comments special highlighting
      tokyonight-nvim # Theme
      vim-sneak # Faster movement
      vim-vsnip # Code Snippets

      # Syntax highlighting and parsing
      (nvim-treesitter.withPlugins (plugins: with plugins; [
        tree-sitter-bash
        tree-sitter-css
        tree-sitter-dockerfile
        tree-sitter-hcl
        tree-sitter-json
        tree-sitter-kotlin
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
    ];
    extraPackages = with unstable; [
      nodePackages.bash-language-server
      shellcheck

      nodePackages.dockerfile-language-server-nodejs
      nodePackages.vscode-langservers-extracted
      nodePackages.typescript-language-server
      nodePackages.yaml-language-server

      luaformatter
      lua-language-server
      lua54Packages.luacheck

      deadnix
      statix
      nil

      terraform-lsp

      # TOML
      taplo-cli

      yamllint
    ];
    # extraConfig = ''
    #   luafile ${builtins.toString ./init.lua}
    # '';
  };

  home.packages = with unstable; [
    black
    coursier
    eslint_d
    metals
    mypy
    nil
    nixpkgs-fmt
    nodePackages.pyright
    python3Packages.flake8
    python3Packages.isort
    stylua
  ];

  xdg.configFile = {
    "nvim/lua" = {
      source = ./lua;
      recursive = true;
    };
    "nvim/init.lua".source = ./init.lua;
  };
}
