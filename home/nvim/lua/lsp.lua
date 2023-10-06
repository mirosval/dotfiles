local lsp = {}

function lsp.setup()
  require'lspconfig'.tsserver.setup({})
  require'lspconfig'.pyright.setup({})
  require'lspconfig'.rnix.setup({})
end

return lsp
