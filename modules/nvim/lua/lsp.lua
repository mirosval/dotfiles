local lsp = {}
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local function format(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({
          filter = function(filter_client)
            return filter_client.name ~= "tsserver"
          end,
          bufnr = bufnr,
        })
      end,
    })
  end
end

function lsp.on_attach(client, bufnr)
  format(client, bufnr)
end

function lsp.setup()
  require'lspconfig'.tsserver.setup({})
  require'lspconfig'.pyright.setup({})
  require'lspconfig'.rnix.setup({})
end

return lsp
