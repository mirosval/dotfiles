local rt = require('rust-tools')

rt.setup({
  server = {
    -- FIXME: This on_attach should be centrally specified for all LSPs
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
      -- require 'illuminate'.on_attach(client)
    end,
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy"
      }, 
    },
  },
})
