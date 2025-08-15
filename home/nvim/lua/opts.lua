local o = vim.opt
local g = vim.g

o.swapfile = false
o.backup = false
o.writebackup = false

-- disabled, managed by blink-cmp
-- o.completeopt = { 'fuzzy', 'menu', 'menuone', 'noselect', 'popup' }
o.shortmess = vim.opt.shortmess + { c = true }
vim.api.nvim_set_option('updatetime', 300)

o.autoread = true
o.clipboard:append('unnamed')
o.scrolloff = 15

-- TODO: enable mouse?

-- search
o.ignorecase = true -- case insensitive searching
o.smartcase = true  -- case sensitive if expression contaisn a capital letter
o.hlsearch = true   -- highlight search results
o.incsearch = true  -- set incremental search like modern browsers

-- split in the correct direction
o.splitright = true
o.splitbelow = true

-- appearance
o.number = true
o.relativenumber = true

-- tabs and spaces
o.shiftwidth = 2  -- indent using > number of visual spaces per tab
o.tabstop = 8     -- this should remain at 8 https://www.reddit.com/r/vim/wiki/tabstop
o.softtabstop = 2 -- edit as if the tabs are 4 characters wide
o.expandtab = true
o.smarttab = true
o.autoindent = true
o.copyindent = true
o.shiftround = true

-- keymaps
g.mapleader = "\\"

-- folds
o.foldmethod = "indent"
o.foldlevel = 99
o.foldlevelstart = 99

vim.o.winborder = 'rounded'
