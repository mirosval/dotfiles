local lib = require('lib')
local nmap = lib.nmap

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
          filter = function(client)
            return client.name ~= "tsserver"
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

  nmap("[e", vim.diagnostic.goto_prev)
  nmap("]e", vim.diagnostic.goto_next)
  nmap("<Leader>ac", vim.lsp.buf.code_action)
  nmap("<Leader>rn", vim.lsp.buf.rename)
  nmap("K", vim.lsp.buf.hover)
  nmap("gd", vim.lsp.buf.definition)
end

return lsp
