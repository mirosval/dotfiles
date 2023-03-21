local legendary = require('legendary')

legendary.setup({
  keymaps = {
    {'<leader>a', ':Legendary<CR>', description = 'Action runner'},
    {'<leader>w', ':write<CR>', description = 'Save file (for use with a custom keyboard combo)'},
    {'<leader>ew', ':e %%<CR>', description = 'Edit file'},
    {'<leader>es', ':sp %%<CR>', description = 'Split horizontally'},
    {'<leader>ev', ':vsp %%<CR>', description = 'Split vertically'},
    -- Tmux Navigator
    {'<C-h>', ':NavigatorLeft<CR>', description = 'Tmux select pane to the left'},
    {'<C-j>', ':NavigatorDown<CR>', description = 'Tmux select pane to the bottom'},
    {'<C-k>', ':NavigatorUp<CR>', description = 'Tmux select pane to the top'},
    {'<C-l>', ':NavigatorRight<CR>', description = 'Tmux select pane to the right'},
    -- Telescope
    {'<C-p>', ':Telescope find_files<CR>', description = 'Search file names'},
    {'<leader>fg', ':Telescope live_grep<CR>', description = 'Search inside files'},
    {'<leader>fd', ':Telescope lsp_document_symbols<CR>', description = 'Search LSP Document Symbols'},
    {
      '<leader>fw',
      ':Telescope lsp_dynamic_workspace_symbols<CR>',
      description = 'Search LSP Dynamic Workspace Symbols'
    },
    {'gd', ':Telescope lsp_definitions<CR>', description = 'Search LSP Definitions'},
    {'gr', ':Telescope lsp_references<CR>', description = 'Search LSP References'},
    {'gi', ':Telescope lsp_implementations<CR>', description = 'Search LSP Implementations'},
  }
})
