local null_ls = require('null-ls')
local lsp = require('lsp')
null_ls.setup({
  on_attach = lsp.on_attach,
  sources = {
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.diagnostics.luacheck,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.eslint_d,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.nixpkgs_fmt,
    null_ls.builtins.formatting.rustfmt,
    null_ls.builtins.formatting.stylua
  }
})
