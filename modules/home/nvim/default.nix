{ ... }: {
  homeModules.nvim = { pkgs, inputs, ... }:
  let
    system = pkgs.stdenv.hostPlatform.system;
    unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        (self: super:
          let
            gitlinker-nvim = super.vimUtils.buildVimPlugin {
              pname = "gitlinker-nvim";
              version = "v5.4.0";
              src = pkgs.fetchFromGitHub {
                owner = "linrongbin16";
                repo = "gitlinker.nvim";
                rev = "v5.4.0";
                hash = "sha256-7zpVBZ/Hz9uBhdVeMc7a06M3HnXzo3Ah4ylCpDdITZI=";
              };
              doCheck = false;
            };
          in
          { vimPlugins = super.vimPlugins // { inherit gitlinker-nvim; }; }
        )
      ];
    };
  in
  {
    programs.neovim = {
      enable = true;
      package = unstable.neovim-unwrapped;
      defaultEditor = true;
      withRuby = false;
      withPython3 = false;
      plugins = with unstable.vimPlugins; [
        Navigator-nvim blink-cmp crates-nvim dressing-nvim fidget-nvim
        git-blame-nvim gitlinker-nvim gitsigns-nvim which-key-nvim
        lualine-nvim nvim-autopairs mini-nvim nvim-bacon
        nvim-treesitter-context nvim-ts-autotag nvim-web-devicons
        plenary-nvim rustaceanvim telescope-nvim text-case-nvim
        tokyonight-nvim vim-sneak vim-vsnip
        (nvim-treesitter.withPlugins (p: with p; [
          tree-sitter-bash tree-sitter-css tree-sitter-dockerfile
          tree-sitter-hcl tree-sitter-json tree-sitter-just
          tree-sitter-lua tree-sitter-make tree-sitter-markdown
          tree-sitter-nix tree-sitter-python tree-sitter-regex
          tree-sitter-rust tree-sitter-sql tree-sitter-toml
          tree-sitter-tsx tree-sitter-typescript tree-sitter-yaml
        ]))
      ];
      extraPackages = with unstable; [
        shellcheck
        bash-language-server dockerfile-language-server
        vscode-langservers-extracted typescript-language-server
        yaml-language-server
        luaformatter lua-language-server lua54Packages.luacheck
        deadnix statix nil
        terraform-lsp taplo yamllint
      ];
    };
    home.packages = with unstable; [
      black coursier eslint_d metals mypy nil
      nixpkgs-fmt pyright python3Packages.flake8
      python3Packages.isort stylua
    ];
    xdg.configFile = {
      "nvim/lua" = { source = ./lua; recursive = true; };
      "nvim/lsp" = { source = ./lsp; recursive = true; };
      "nvim/init.lua".source = ./init.lua;
    };
  };
}
