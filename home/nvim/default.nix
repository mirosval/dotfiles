{ pkgs, inputs, ... }:
let
  unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
    config.allowUnfree = true;
    overlays = [
      (
        self: super:
        let
          gitlinker-nvim = super.vimUtils.buildVimPlugin {
            pname = "gitlinker-nvim";
            version = "2024-04-02";
            src = pkgs.fetchFromGitHub {
              owner = "linrongbin16";
              repo = "gitlinker.nvim";
              rev = "839215b322b15b662c08a010534e8de00dae38a6";
              hash = "sha256-BtvbqV8bD4iiRLBCZdp76eAPy73aHJ9CggBf+0R6tWQ=";
            };
          };
        in
        {
          vimPlugins = super.vimPlugins // {
            inherit gitlinker-nvim;
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
      # cmp-buffer # Code completion from current buffer
      # cmp-nvim-lsp # Code completion from LSP
      # cmp-nvim-lsp-signature-help # Help overlay for Code Completion
      # cmp-nvim-lua # Code completion for Neovim Lua API
      # cmp-path # Code completion for paths
      # cmp-treesitter # Code completion from treesitter nodes
      # cmp-vsnip # Code completion snippets integration
      crates-nvim # Rust Cargo.toml companion - updates and docs for dependencies
      dressing-nvim # Makes native nvim UI look better
      fidget-nvim # LSP Progress spinner
      git-blame-nvim # Show git-blame in virtual text
      gitlinker-nvim # Copy links to the selected code in GH
      gitsigns-nvim # Highlight code changes vs git
      which-key-nvim # Key binding helper and manager
      lualine-nvim # Status line config
      mini-nvim # Collection of minimal, independent, and fast Lua modules
      # none-ls-nvim # Integration of linters into the LSP stack
      nvim-bacon # Rust error navigation
      # nvim-cmp # Code completion
      # nvim-lspconfig # LSP Client configurations
      # nvim-metals # Scala LSP
      nvim-treesitter-context # Shows context at the top of the editor, like vscode
      nvim-ts-autotag # Auto-close HTML tags
      nvim-web-devicons # Eye candy
      plenary-nvim # Utility lua function
      rustaceanvim # Rust enhancements beyond LSP
      telescope-nvim # Fuzzy finder
      text-case-nvim # Switch between word casing
      tokyonight-nvim # Theme
      vim-sneak # Faster movement
      vim-vsnip # Code Snippets

      # Syntax highlighting and parsing
      (nvim-treesitter.withPlugins (
        plugins: with plugins; [
          tree-sitter-bash
          tree-sitter-css
          tree-sitter-dockerfile
          tree-sitter-hcl
          tree-sitter-json
          tree-sitter-just
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
        ]
      ))
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
    pyright
    python3Packages.flake8
    python3Packages.isort
    stylua
  ];

  xdg.configFile = {
    "nvim/lua" = {
      source = ./lua;
      recursive = true;
    };
    "nvim/lsp" = {
      source = ./lsp;
      recursive = true;
    };
    "nvim/init.lua".source = ./init.lua;
  };
}
