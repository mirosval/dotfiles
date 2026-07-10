{ pkgs }:
with pkgs.vimPlugins; [
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
]
