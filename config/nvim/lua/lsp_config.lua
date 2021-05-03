local lsp_config = require('lspconfig')
local lsp_signature = require('lsp_signature')
local lsp_status = require('lsp-status')
lsp_status.register_progress()


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = vim.tbl_extend('keep', capabilities or {}, lsp_status.capabilities)

local on_attach = function(client, bufnr)
    lsp_status.on_attach(client, bufnr)
    lsp_signature.on_attach(client, bufnr)
end

lsp_config.rust_analyzer.setup{
    capabilities = capabilities,
    on_attach = on_attach
}

lsp_config.jsonls.setup {
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
        end
      }
    },
    on_attach = on_attach
}

lsp_config.diagnosticls.setup{
    on_attach = on_attach
}

lsp_config.dockerls.setup{
    on_attach = on_attach
}

-- lsp_config.gopls.setup{
--     on_attach = on_attach
-- }

-- lsp_config.graphql.setup{
--     on_attach = on_attach
-- }

lsp_config.html.setup{
    on_attach = on_attach
}

-- lsp_config.jdtls.setup{
--     on_attach = on_attach
-- }

lsp_config.jsonls.setup {
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
        end
      }
    }
}

-- lsp_config.kotlin_language_server.setup{
--     on_attach = on_attach
-- }

-- lsp_config.sqlls.setup{
--     on_attach = on_attach
-- }

lsp_config.yamlls.setup{
    on_attach = on_attach
}

lsp_config.pyright.setup{
    on_attach = on_attach
}

lsp_config.terraformls.setup{
    on_attach = on_attach
}

lsp_config.tsserver.setup{
    on_attach = on_attach
}

lsp_config.vimls.setup{
    on_attach = on_attach
}

-- lsp_config.metals.setup{
--     on_attach = on_attach
-- }
