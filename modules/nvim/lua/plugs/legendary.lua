local legendary = require('legendary')

legendary.setup({
  keymaps = {
    {'<leader>a', ':Legendary<CR>', description = 'Action runner'},
    {'<leader>w', ':write<CR>', description = 'Save file (for use with a custom keyboard combo)'},
    {'<leader>ew', ':e %%<CR>', description = 'Edit file'},
    {'<leader>es', ':sp %%<CR>', description = 'Split horizontally'},
    {'<leader>ev', ':vsp %%<CR>', description = 'Split vertically'},
  }
})
