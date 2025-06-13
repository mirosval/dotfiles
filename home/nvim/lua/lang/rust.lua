local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
local lsp_attach = function(_client, buf)
  vim.api.nvim_buf_set_option(buf, "formatexpr", "v:lua.vim.lsp.formatexpr()")
  vim.api.nvim_buf_set_option(buf, "omnifunc", "v:lua.vim.lsp.omnifunc")
  vim.api.nvim_buf_set_option(buf, "tagfunc", "v:lua.vim.lsp.tagfunc")
end

vim.g.rustaceanvim = {
  tools = {},
  server = {
    capabilities = capabilities,
    on_attach = lsp_attach,
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          buildScripts = {
            enable = true,
          },
        },
        files = {
          excludeDirs = {
            ".cargo",
            ".direnv", -- Prevent Rust Analyzer from getting stuck on "Roots Scanned"
            ".git",
            "target",
          },
        },
      },
    },
  },
}
