require("plugs.crates_setup")
require("plugs.tree_sitter_setup")
require("plugs.telescope_setup")
require("plugs.tmux_setup")
require("plugs.which_key_setup")
require("plugs.dressing")
require("plugs.lualine_setup")
require("plugs.mini_setup")
require("plugs.blink_cmp_setup")
require("nvim-autopairs").setup({})
require("nvim-ts-autotag").setup()
require("fidget").setup()
require("gitlinker").setup()
require("textcase").setup()
-- colorscheme
vim.opt.background = "dark"
vim.g.tokyonight_style = "night"
vim.cmd([[colorscheme tokyonight]])
