local lsp = {}

function lsp.setup()
  require("lspconfig").ts_ls.setup({})
  require("lspconfig").pyright.setup({})
  require("lspconfig").nil_ls.setup({})
  require("lspconfig").jsonls.setup({})
  require("lspconfig").yamlls.setup({})
  require("lspconfig").dockerls.setup({})
  require("lspconfig").lua_ls.setup({})
  require("lspconfig").bashls.setup({})

  -- Enable Inlay hints for all langs
  vim.lsp.inlay_hint.enable()
end

return lsp
