local legendary = require('legendary')
local textcase = require('textcase')
local todo = require('todo-comments')
local crates = require('crates')

local format = function()
  vim.lsp.buf.format({
    filter = function(filter_client)
      -- Remove tsserver from LSPs available for formatting
      return filter_client.name ~= "tsserver"
    end
  })
end

legendary.setup({
  keymaps = {
    { '<leader>a',  ':Legendary<CR>', description = 'Action runner' },
    {
      '<leader>w',
      ':write<CR>',
      description =
      'Save file (for use with a custom keyboard combo)'
    },
    { '<leader>ew', ':e %%<CR>',      description = 'Edit file' },
    { '<leader>es', ':sp %%<CR>',     description = 'Split horizontally' },
    { '<leader>ev', ':vsp %%<CR>',    description = 'Split vertically' },
    { '<leader>ff', format,           description = 'Reformat file' },
    -- Tmux Navigator
    {
      '<C-h>',
      ':NavigatorLeft<CR>',
      description = 'Tmux select pane to the left',
      opts = {
        silent = true }
    },
    {
      '<C-j>',
      ':NavigatorDown<CR>',
      description = 'Tmux select pane to the bottom',
      opts = {
        silent = true }
    },
    {
      '<C-k>',
      ':NavigatorUp<CR>',
      description = 'Tmux select pane to the top',
      opts = {
        silent = true }
    },
    {
      '<C-l>',
      ':NavigatorRight<CR>',
      description = 'Tmux select pane to the right',
      opts = {
        silent = true }
    },
    -- Telescope
    { '<C-p>',      ':Telescope find_files<CR>',           description = 'Search file names' },
    { '<leader>fg', ':Telescope live_grep<CR>',            description = 'Search inside files' },
    { '<leader>fd', ':Telescope lsp_document_symbols<CR>', description = 'Search LSP Document Symbols' },
    {
      '<leader>fw',
      ':Telescope lsp_dynamic_workspace_symbols<CR>',
      description = 'Search LSP Dynamic Workspace Symbols'
    },
    { 'gd',         ':Telescope lsp_definitions<CR>',     description = 'Search LSP Definitions' },
    { 'gr',         ':Telescope lsp_references<CR>',      description = 'Search LSP References' },
    { 'gi',         ':Telescope lsp_implementations<CR>', description = 'Search LSP Implementations' },
    { '[e',         vim.diagnostic.goto_next,             description = 'Next diagnostic' },
    { ']e',         vim.diagnostic.goto_prev,             description = 'Prev diagnostic' },
    { '<leader>ac', vim.lsp.buf.code_action,              description = 'LSP Code Action' },
    { '<leader>rn', vim.lsp.buf.rename,                   description = 'LSP Rename' },
    { 'K',          vim.lsp.buf.hover,                    description = 'LSP Hover' },
    { 'gd',         vim.lsp.buf.definition,               description = 'LSP Goto Definition' },
    { '<leader>o',  ':AerialToggle!<CR>',                 description = 'Aerial' },
    -- Text case
    {
      'gas',
      { n = textcase.operator('to_snake_case'), v = textcase.visual('to_snake_case') },
      description = 'To Snake Case'
    },
    {
      'gad',
      { n = textcase.operator('to_dash_case'), v = textcase.visual('to_dash_case') },
      description = 'To Dash Case'
    },
    {
      'gaca',
      { n = textcase.operator('to_camel_case'), v = textcase.visual('to_camel_case') },
      description = 'To Camel Case'
    },
    {
      'gaco',
      { n = textcase.operator('to_constant_case'), v = textcase.visual('to_constant_case') },
      description = 'To Constant Case'
    },
    {
      'gal',
      { n = textcase.operator('to_lower_case'), v = textcase.visual('to_lower_case') },
      description = 'To Lower Case'
    },
    {
      'gau',
      { n = textcase.operator('to_upper_case'), v = textcase.visual('to_upper_case') },
      description = 'To Upper Case'
    },
    -- TODO Comments
    { ']t',         todo.jump_next,                        description = 'Next TODO' },
    { '[t',         todo.jump_prev,                        description = 'Prev TODO' },
    { '<leader>t',  ':TodoTelescope<cr>',                  description = 'TODO Telescope' },
    -- Telekasten
    { '<leader>n',  ':Telekasten panel<cr>',               description = 'Notes Telekasten command palette' },
    { '<leader>nf', ':Telekasten find_notes<cr>',          description = 'Notes Telekasten find note' },
    { '<leader>ng', ':Telekasten search_notes<cr>',        description = 'Notes Telekasten search notes' },
    { '<leader>nd', ':Telekasten goto_today<cr>',          description = 'Notes Telekasten show todays note' },
    { '<leader>nz', ':Telekasten follow_link<cr>',         description = 'Notes Telekasten follow link' },
    { '<leader>nn', ':Telekasten new_note<cr>',            description = 'Notes Telekasten new link' },
    { '<leader>nc', ':Telekasten show_calendar<cr>',       description = 'Notes Telekasten show calendar' },
    { '<leader>nb', ':Telekasten show_backlinks<cr>',      description = 'Notes Telekasten show backlinks' },
    { '<leader>nI', ':Telekasten insert_img_link<cr>',     description = 'Notes Telekasten insert image link' },
    { '[[',         { i = ':Telekasten insert_link<cr>' }, description = 'Notes Telekasten insert image link' },
    -- Crates.nvim
  },
  functions = {
    { crates.upgrade_crate,                      description = 'Rust Crates Upgrade Crate' },
    { crates.expand_plain_crate_to_inline_table, description = 'Rust Crates Expand crate to table' },
    { crates.open_homepage,                      description = 'Rust Crates Open Homepage' },
    { crates.open_repository,                    description = 'Rust Crates Open Repository' },
    { crates.open_documentation,                 description = 'Rust Crates Open Documentation' },
    { crates.open_crates_io,                     description = 'Rust Crates Open Crates.io' },
    { crates.show_popup,                         description = 'Rust Crates Show Popup' },
  },
  autocmds = {
    {
      name = "LspFormatting",
      clear = true,
      {
        'BufWritePre',
        format
      }
    }
  }
})
