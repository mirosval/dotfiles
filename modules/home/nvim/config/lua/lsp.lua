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
    virtual_text = false,
    virtual_lines = false,
    severity_sort = true,
    float = { border = "rounded", source = "if_many" },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },
    jump = {
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
      end,
    },
  })
end

return lsp
