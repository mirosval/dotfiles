local o = vim.opt
local g = vim.g

o.swapfile = false
o.backup = false
o.writebackup = false

--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
o.completeopt = {'menuone', 'noselect', 'noinsert'}
o.shortmess = vim.opt.shortmess + { c = true}
vim.api.nvim_set_option('updatetime', 300) 

o.autoread = true
o.clipboard:append('unnamed')
o.scrolloff = 15

-- TODO: enable mouse?

-- search
o.ignorecase = true -- case insensitive searching
o.smartcase = true -- case sensitive if expression contaisn a capital letter
o.hlsearch = true -- highlight search results
o.incsearch = true -- set incremental search like modern browsers

-- split in the correct direction
o.splitright = true
o.splitbelow = true

-- appearance
o.number = true
o.relativenumber = true

-- tabs and spaces
o.shiftwidth = 2 -- indent using > number of visual spaces per tab 
o.tabstop = 8 -- this should remain at 8 https://www.reddit.com/r/vim/wiki/tabstop
o.softtabstop = 2 -- edit as if the tabs are 4 characters wide
o.expandtab = true
o.smarttab = true
o.autoindent = true
o.copyindent = true
o.shiftround = true

-- keymaps
g.mapleader = "\\"

local lib = require('lib')
local nmap = lib.nmap

nmap('<Leader>w', ':write<CR>') -- save file
nmap('<Leader>ew', ':e %%<CR>') -- edit file
nmap('<Leader>es', ':sp %%<CR>') -- split file
nmap('<Leader>ev', ':vsp %%<CR>') -- vertical split file

-- nmap('<Leader>o', ':Other<CR>') -- Alternative files
