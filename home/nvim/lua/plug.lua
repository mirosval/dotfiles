require('plugs.crates')
require('plugs.tree_sitter_setup')
require('plugs.telescope_setup')
require('plugs.tmux_setup')
require('plugs.aerial_setup')
require('plugs.todo_comments_setup')
require('plugs.legendary')
require('plugs.dressing')
require('plugs.lualine_setup')
require('plugs.null_ls_setup')
require('plugs.telekasten')
require("nvim-surround").setup({})
require("nvim-autopairs").setup {}
require('Comment').setup()
require('ibl').setup()
require('gitsigns').setup()
require('nu').setup({})
-- colorscheme
vim.opt.background = "dark"
vim.g.tokyonight_style = "night"
vim.cmd [[colorscheme tokyonight]]
