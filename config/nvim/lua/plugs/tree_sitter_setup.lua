-- Treesitter Plugin Setup 
require('nvim-treesitter.configs').setup {
  ensure_installed = { 
    "lua", 
    "rust", 
    "toml",
    "yaml"
  },
  autopairs = {
    enable = true
  },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting=false,
  },
  ident = { enable = true }, 
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  }
}

-- Treesitter folding 
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevelstart = 99 -- no folds closed
vim.opt.foldlevel = 99 -- no folds closed
