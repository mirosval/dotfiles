-- which-key.nvim configuration - replaces legendary.nvim
local wk = require("which-key")
local textcase = require("textcase")
local crates = require("crates")

-- Helper functions (migrated from legendary)
local format = function()
  vim.lsp.buf.format({
    filter = function(filter_client)
      -- Remove tsserver from LSPs available for formatting
      return filter_client.name ~= "tsserver"
    end,
  })
end

local function find_related()
  require("telescope.builtin").find_files({ cwd = vim.fn.expand("%:p:h") })
end

-- Setup which-key with configuration
wk.setup({
  preset = "modern", -- Use modern preset for better defaults
  delay = 200,       -- Delay before which-key popup appears
  expand = 1,        -- Expand groups when <= 1
  notify = true,     -- Show notification when registering keymaps
  triggers = {
    { "<auto>", mode = "nixsotc" },
  },
})

-- Register all keymaps
wk.add({
  -- Save file
  { "<leader>w",  ":write<CR>",                                   desc = "Save file" },

  -- File operations group
  { "<leader>e",  group = "Edit/Split" },
  { "<leader>ew", ":e %%<CR>",                                    desc = "Edit file" },
  { "<leader>es", ":split<CR>",                                   desc = "Split horizontally" },
  { "<leader>ev", ":vsplit<CR>",                                  desc = "Split vertically" },

  -- Format
  { "<leader>ff", format,                                         desc = "Reformat file" },

  -- Tmux Navigator
  { "<C-h>",      ":NavigatorLeft<CR>",                           desc = "Tmux select pane left",       silent = true },
  { "<C-j>",      ":NavigatorDown<CR>",                           desc = "Tmux select pane down",       silent = true },
  { "<C-k>",      ":NavigatorUp<CR>",                             desc = "Tmux select pane up",         silent = true },
  { "<C-l>",      ":NavigatorRight<CR>",                          desc = "Tmux select pane right",      silent = true },

  -- Rustacean
  { "gu",         ":RustLsp parentModule<CR>",                    desc = "Go to parent Rust mod",       silent = true },

  -- Bacon
  { "gb",         ":BaconLoad<CR>:w<CR>:BaconNext<CR>",           desc = "Bacon Next",                  silent = true },

  -- Telescope group
  { "<leader>f",  group = "Find" },
  { "<C-p>",      ":Telescope find_files<CR>",                    desc = "Search file names" },
  { "<leader>fg", ":Telescope live_grep<CR>",                     desc = "Search inside files" },
  { "<leader>fd", ":Telescope lsp_document_symbols<CR>",          desc = "Search LSP Document Symbols" },
  { "<leader>fw", ":Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Search LSP Workspace Symbols" },
  { "<leader>fr", find_related,                                   desc = "Find related files" },

  -- LSP group
  { "g",          group = "Go to" },
  { "grt",        ":Telescope lsp_definitions<CR>",               desc = "Search LSP Definitions" },
  { "grr",        ":Telescope lsp_references<CR>",                desc = "Search LSP References" },
  { "gri",        ":Telescope lsp_implementations<CR>",           desc = "Search LSP Implementations" },
  { "gd",         vim.lsp.buf.definition,                         desc = "LSP Goto Definition" },
  { "gr",         ":Telescope lsp_references<CR>",                desc = "LSP References" },
  { "gi",         ":Telescope lsp_implementations<CR>",           desc = "LSP Implementations" },

  -- LSP actions
  { "<leader>a",  group = "Actions" },
  { "<leader>ac", vim.lsp.buf.code_action,                        desc = "LSP Code Action" },
  { "<leader>rn", vim.lsp.buf.rename,                             desc = "LSP Rename" },
  { "K",          vim.lsp.buf.hover,                              desc = "LSP Hover" },

  -- Diagnostics
  { "]e",         vim.diagnostic.goto_next,                       desc = "Next diagnostic" },
  { "[e",         vim.diagnostic.goto_prev,                       desc = "Prev diagnostic" },

  -- LSP split navigation
  { "gl",         group = "LSP split" },
  {
    "gldv",
    function()
      vim.cmd("vsplit")
      vim.lsp.buf.definition()
    end,
    desc = "Go to definition in vertical split"
  },
  {
    "gldx",
    function()
      vim.cmd("split")
      vim.lsp.buf.definition()
    end,
    desc = "Go to definition in horizontal split"
  },

  -- Aerial
  { "<leader>o", ":AerialToggle!<CR>",                desc = "Toggle Aerial outline" },

  -- GitLink
  { "gl",        group = "Git link" },
  { "gllc",      function() vim.cmd("GitLink") end,   desc = "Copy GH link to clipboard", mode = { "n", "v" } },
  { "gllo",      function() vim.cmd("GitLink!") end,  desc = "Open GH link in browser",   mode = { "n", "v" } },

  -- Clear search highlights
  { "<esc>",     function() vim.cmd.nohlsearch() end, desc = "Clear search highlighting", mode = "n" },

  -- Copy file path and position
  { "<leader>c", group = "Copy" },
  {
    "<leader>cc",
    function()
      local s, e = vim.fn.line("'<"), vim.fn.line("'>")
      if s == 0 then
        s = vim.fn.line('.')
        e = vim.fn.line('.')
      end
      vim.fn.setreg('+', string.format("%s:%s%s", vim.fn.expand('%:p'), s, s == e and '' or '-' .. e))
    end,
    desc = "Copy file path and position",
    mode = { "n", "v" }
  },

  -- Text case transformations
  { "ga",   group = "Text case" },
  { "gas",  { n = textcase.operator("to_snake_case"), v = textcase.visual("to_snake_case") },       desc = "To snake_case" },
  { "gad",  { n = textcase.operator("to_dash_case"), v = textcase.visual("to_dash_case") },         desc = "To dash-case" },
  { "gaca", { n = textcase.operator("to_camel_case"), v = textcase.visual("to_camel_case") },       desc = "To camelCase" },
  { "gaco", { n = textcase.operator("to_constant_case"), v = textcase.visual("to_constant_case") }, desc = "To CONSTANT_CASE" },
  { "gal",  { n = textcase.operator("to_lower_case"), v = textcase.visual("to_lower_case") },       desc = "To lowercase" },
  { "gau",  { n = textcase.operator("to_upper_case"), v = textcase.visual("to_upper_case") },       desc = "To UPPERCASE" },
})

-- Setup autocmds (migrated from legendary)
local group = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  callback = format,
})

-- Register crates functions to be callable via which-key's command palette
-- Note: which-key doesn't have a direct equivalent to legendary's functions,
-- but these can be called via commands or custom mappings if needed
local function register_crates_commands()
  vim.api.nvim_create_user_command("CratesUpgrade", crates.upgrade_crate, { desc = "Rust Crates Upgrade Crate" })
  vim.api.nvim_create_user_command("CratesExpand", crates.expand_plain_crate_to_inline_table,
    { desc = "Rust Crates Expand crate to table" })
  vim.api.nvim_create_user_command("CratesHomepage", crates.open_homepage, { desc = "Rust Crates Open Homepage" })
  vim.api.nvim_create_user_command("CratesRepository", crates.open_repository, { desc = "Rust Crates Open Repository" })
  vim.api.nvim_create_user_command("CratesDocumentation", crates.open_documentation,
    { desc = "Rust Crates Open Documentation" })
  vim.api.nvim_create_user_command("CratesCratesIo", crates.open_crates_io, { desc = "Rust Crates Open Crates.io" })
  vim.api.nvim_create_user_command("CratesPopup", crates.show_popup, { desc = "Rust Crates Show Popup" })
end

register_crates_commands()

