local legendary = require("legendary")
local filters = require("legendary.filters")
local textcase = require("textcase")
local crates = require("crates")

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

legendary.setup({
  keymaps = {
    {
      "<C-Space>",
      function()
        legendary.find({ filters = { filters.mode("n"), filters.keymaps() } })
      end,
      description = "Show Legendary (normal)",
      mode = "n",
    },
    {
      "<C-Space>",
      function()
        legendary.find({ filters = { filters.mode("i"), filters.keymaps() } })
      end,
      description = "Show Legendary (insert)",
      mode = "i",
    },
    {
      "<C-Space>",
      function()
        legendary.find({ filters = { filters.mode("v"), filters.keymaps() } })
      end,
      description = "Show Legendary (visual)",
      mode = "v",
    },
    {
      "<leader>w",
      ":write<CR>",
      description = "Save file (for use with a custom keyboard combo)",
    },
    { "<leader>ew", ":e %%<CR>",   description = "Edit file" },
    { "<leader>es", ":split<CR>",  description = "Split horizontally" },
    { "<leader>ev", ":vsplit<CR>", description = "Split vertically" },
    { "<leader>ff", format,        description = "Reformat file" },
    -- Tmux Navigator
    {
      "<C-h>",
      ":NavigatorLeft<CR>",
      description = "Tmux select pane to the left",
      opts = {
        silent = true,
      },
    },
    {
      "<C-j>",
      ":NavigatorDown<CR>",
      description = "Tmux select pane to the bottom",
      opts = {
        silent = true,
      },
    },
    {
      "<C-k>",
      ":NavigatorUp<CR>",
      description = "Tmux select pane to the top",
      opts = {
        silent = true,
      },
    },
    {
      "<C-l>",
      ":NavigatorRight<CR>",
      description = "Tmux select pane to the right",
      opts = {
        silent = true,
      },
    },
    -- rustaceanvim
    {
      "gu",
      ":RustLsp parentModule<CR>",
      description = "Go to the parent Rust mod",
      opts = {
        silent = true,
      },
    },
    -- bacon
    {
      "gb",
      ":BaconLoad<CR>:w<CR>:BaconNext<CR>",
      description = "Bacon Next",
      opts = {
        silent = true,
      },
    },
    -- Telescope
    { "<C-p>",      ":Telescope find_files<CR>",           description = "Search file names" },
    { "<leader>fg", ":Telescope live_grep<CR>",            description = "Search inside files" },
    { "<leader>fd", ":Telescope lsp_document_symbols<CR>", description = "Search LSP Document Symbols" },
    {
      "<leader>fw",
      ":Telescope lsp_dynamic_workspace_symbols<CR>",
      description = "Search LSP Workspace Symbols",
    },
    { "<leader>fr", find_related,                         description = "Find related files" },
    { "gd",         ":Telescope lsp_definitions<CR>",     description = "Search LSP Definitions" },
    { "gr",         ":Telescope lsp_references<CR>",      description = "Search LSP References" },
    { "gi",         ":Telescope lsp_implementations<CR>", description = "Search LSP Implementations" },
    { "[e",         vim.diagnostic.goto_next,             description = "Next diagnostic" },
    { "]e",         vim.diagnostic.goto_prev,             description = "Prev diagnostic" },
    { "<leader>ac", vim.lsp.buf.code_action,              description = "LSP Code Action" },
    { "<leader>rn", vim.lsp.buf.rename,                   description = "LSP Rename" },
    { "K",          vim.lsp.buf.hover,                    description = "LSP Hover" },
    { "gd",         vim.lsp.buf.definition,               description = "LSP Goto Definition" },
    { "<leader>o",  ":AerialToggle!<CR>",                 description = "Aerial" },
    {
      "gldv",
      function()
        vim.cmd("vsplit")
        vim.lsp.buf.definition()
      end,
      description = "LSP Go to definition in vertical split",
    },
    {
      "gldx",
      function()
        vim.cmd("split")
        vim.lsp.buf.definition()
      end,
      description = "LSP Go to definition in horizontal split",
    },
    -- GitLink
    {
      "gllc",
      function()
        vim.cmd("GitLink")
      end,
      description = "GitLink copy link to GH into clipboard",
      mode = { "n", "v" },
    },
    {
      "gllo",
      function()
        vim.cmd("GitLink!")
      end,
      description = "GitLink open link to GH in the browser",
      mode = { "n", "v" },
    },
    {
      "<esc>",
      function()
        vim.cmd.nohlsearch()
      end,
      description = "Erase search highlighting",
      mode = { "n" }
    },
    --    Text case
    -- Copy current file & position to clipboard
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
      description = "Copy current file path and position to clipboard",
      mode = { "n", "v" },
    },
    -- Text case
    {
      "gas",
      { n = textcase.operator("to_snake_case"), v = textcase.visual("to_snake_case") },
      description = "To Snake Case",
    },
    {
      "gad",
      { n = textcase.operator("to_dash_case"), v = textcase.visual("to_dash_case") },
      description = "To Dash Case",
    },
    {
      "gaca",
      { n = textcase.operator("to_camel_case"), v = textcase.visual("to_camel_case") },
      description = "To Camel Case",
    },
    {
      "gaco",
      { n = textcase.operator("to_constant_case"), v = textcase.visual("to_constant_case") },
      description = "To Constant Case",
    },
    {
      "gal",
      { n = textcase.operator("to_lower_case"), v = textcase.visual("to_lower_case") },
      description = "To Lower Case",
    },
    {
      "gau",
      { n = textcase.operator("to_upper_case"), v = textcase.visual("to_upper_case") },
      description = "To Upper Case",
    },
  },
  functions = {
    { crates.upgrade_crate,                      description = "Rust Crates Upgrade Crate" },
    { crates.expand_plain_crate_to_inline_table, description = "Rust Crates Expand crate to table" },
    { crates.open_homepage,                      description = "Rust Crates Open Homepage" },
    { crates.open_repository,                    description = "Rust Crates Open Repository" },
    { crates.open_documentation,                 description = "Rust Crates Open Documentation" },
    { crates.open_crates_io,                     description = "Rust Crates Open Crates.io" },
    { crates.show_popup,                         description = "Rust Crates Show Popup" },
  },
  autocmds = {
    {
      name = "LspFormatting",
      clear = true,
      {
        "BufWritePre",
        format,
      },
    },
  },
})
