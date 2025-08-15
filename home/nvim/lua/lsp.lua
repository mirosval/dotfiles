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

  -- Autocompletion
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if client:supports_method('textDocument/completion') then
        vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
      end
    end,
  })

  -- Diagnostics
  vim.diagnostic.config({
    -- virtual_text = true,
    virtual_lines = true,
  })
end

return lsp
