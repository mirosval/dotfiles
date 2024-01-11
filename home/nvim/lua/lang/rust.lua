local rt = require('rust-tools')
local capabilities = require("cmp_nvim_lsp").default_capabilities()
rt.setup({
  server = {
    capabilities = capabilities,
    on_attach = function(_, bufnr)
      -- Hover actions
      -- vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
      -- require 'illuminate'.on_attach(client)
      vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
      vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
    end,
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy"
      },
    },
  },
})
