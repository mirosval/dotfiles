local lsp_config = require('lspconfig')
local configs = require('lspconfig.configs')
local lsp_signature = require('lsp_signature')
local lsp_status = require('lsp-status')
local rust_tools = require('rust-tools')
local py_lsp = require('py_lsp')
lsp_status.register_progress()


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}
capabilities = vim.tbl_extend('keep', capabilities or {}, lsp_status.capabilities)

-- nvim-cmp integration
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local on_attach = function(client, bufnr)
    lsp_status.on_attach(client, bufnr)
    lsp_signature.on_attach(client, bufnr)
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                vim.lsp.buf.formatting_sync()
                vim.cmd(':EslintFixAll')
            end,
        })
    end
end

rust_tools.setup({
    server = {
        on_attach = on_attach,
        capabilities = capabilities,
    }
})

lsp_config.jsonls.setup {
    capabilities = capabilities,
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
        end
      }
    },
    on_attach = on_attach
}

lsp_config.dockerls.setup{
    capabilities = capabilities,
    on_attach = on_attach
}

lsp_config.html.setup{
    capabilities = capabilities,
    on_attach = on_attach
}

lsp_config.jsonls.setup {
    capabilities = capabilities,
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
        end
      }
    }
}

lsp_config.yamlls.setup{
    capabilities = capabilities,
    on_attach = on_attach
}

py_lsp.setup{ 
    capabilities = capabilities,
    on_attach = on_attach
}

lsp_config.terraformls.setup{
    capabilities = capabilities,
    on_attach = on_attach
}

lsp_config.tsserver.setup{
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
    end
}

lsp_config.vimls.setup{
    capabilities = capabilities,
    on_attach = on_attach
}

if not configs.ls_emmet then
  configs.ls_emmet = {
    default_config = {
      cmd = { 'ls_emmet', '--stdio' };
      filetypes = {
        'html',
        'css',
        'scss',
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'haml',
        'xml',
        'xsl',
        'pug',
        'slim',
        'sass',
        'stylus',
        'less',
        'sss',
        'hbs',
        'handlebars',
      };
      root_dir = function(fname)
        return vim.loop.cwd()
      end;
      settings = {};
    };
  }
end

lsp_config.ls_emmet.setup { 
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
    end
}

lsp_config.eslint.setup { 
    capabilities = capabilities,
    on_attach = on_attach
}
