local lsp = {}

function lsp.setup()
  require'lspconfig'.tsserver.setup({})
  require'lspconfig'.pyright.setup({})
  require'lspconfig'.rnix.setup({})
  require'lspconfig'.jsonls.setup({})
  require'lspconfig'.yamlls.setup({})
  require'lspconfig'.dockerls.setup({})
  require'lspconfig'.lua_ls.setup({})
  require'lspconfig'.bashls.setup({})
end

return lsp
