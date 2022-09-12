local lib = require('lib')
local nmap = lib.nmap

local lsp = {}

function lsp.on_attach(client, bufnr)
  require("aerial").on_attach(client, bufnr)
end

function lsp.setup()
  nmap("[e", vim.lsp.diagnostic.goto_prev)
  nmap("]e", vim.lsp.diagnostic.goto_next)
  nmap("<Leader>ac", vim.lsp.buf.code_action)
  -- nmap("<Leader>ac", vim.lsp.buf.code_action) -- TODO: Add code range support
  nmap("K", vim.lsp.buf.hover)
  nmap("gd", vim.lsp.buf.definition)
end

return lsp
