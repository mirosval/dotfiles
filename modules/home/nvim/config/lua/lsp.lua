local lsp = {}

function lsp.setup()
  vim.lsp.enable({
    'lua',
    'nil_ls',
    'pyright',
    'ts',
  })

  -- Enable Inlay hints for all langs
  vim.lsp.inlay_hint.enable()

  -- Diagnostics
  vim.diagnostic.config({
    -- virtual_text = true,
    virtual_lines = true,
  })
end

return lsp
