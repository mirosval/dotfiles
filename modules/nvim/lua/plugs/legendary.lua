local legendary = require('legendary')
local textcase = require('textcase')
local todo = require('todo-comments')

legendary.setup({
  keymaps = {
    {'<leader>a', ':Legendary<CR>', description = 'Action runner'},
    {'<leader>w', ':write<CR>', description = 'Save file (for use with a custom keyboard combo)'},
    {'<leader>ew', ':e %%<CR>', description = 'Edit file'},
    {'<leader>es', ':sp %%<CR>', description = 'Split horizontally'},
    {'<leader>ev', ':vsp %%<CR>', description = 'Split vertically'},
    -- Tmux Navigator
    {'<C-h>', ':NavigatorLeft<CR>', description = 'Tmux select pane to the left', opts = { silent = true }},
    {'<C-j>', ':NavigatorDown<CR>', description = 'Tmux select pane to the bottom', opts = { silent = true }},
    {'<C-k>', ':NavigatorUp<CR>', description = 'Tmux select pane to the top', opts = { silent = true }},
    {'<C-l>', ':NavigatorRight<CR>', description = 'Tmux select pane to the right', opts = { silent = true }},
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
    {'[e', vim.diagnostic.goto_next, description = 'Next diagnostic'},
    {']e', vim.diagnostic.goto_prev, description = 'Prev diagnostic'},
    {'<leader>ac', vim.lsp.buf.code_action, description = 'LSP Code Action'},
    {'<leader>rn', vim.lsp.buf.rename, description = 'LSP Rename'},
    {'K', vim.lsp.buf.hover, description = 'LSP Hover'},
    {'gd', vim.lsp.buf.definition, description = 'LSP Goto Definition'},
    {'<leader>o', ':AerialToggle!<CR>', description = 'Aerial'},
    -- Text case
    {
      'gas',
      { n = textcase.operator('to_snake_case'), v = textcase.visual('to_snake_case')},
      description = 'To Snake Case'
    },
    {
      'gad',
      { n = textcase.operator('to_dash_case'), v = textcase.visual('to_dash_case')},
      description = 'To Dash Case'
    },
    {
      'gaca',
      { n = textcase.operator('to_camel_case'), v = textcase.visual('to_camel_case')},
      description = 'To Camel Case'
    },
    {
      'gaco',
      { n = textcase.operator('to_constant_case'), v = textcase.visual('to_constant_case')},
      description = 'To Constant Case'
    },
    {
      'gal',
      { n = textcase.operator('to_lower_case'), v = textcase.visual('to_lower_case')},
      description = 'To Lower Case'
    },
    {
      'gau',
      { n = textcase.operator('to_upper_case'), v = textcase.visual('to_upper_case')},
      description = 'To Upper Case'
    },
    -- TODO Comments
    { ']t', todo.jump_next, description = 'Next TODO' },
    { '[t', todo.jump_prev, description = 'Prev TODO' },
    { '<leader>t', ':TodoTelescope<cr>', description = 'TODO Telescope' }
  },
  autocmds = {
    {
      name = "LspFormatting",
      clear = true,
      {
        'BufWritePre',
        function()
          vim.lsp.buf.format({
            filter = function(filter_client)
              -- Remove tsserver from LSPs available for formatting
              return filter_client.name ~= "tsserver"
            end
          })
        end
      }
    }
  }
})
