vim.g.rustaceanvim = {
  tools = {},
  server = {
    -- on_attach = function(_client, _bufnr) end,
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          buildScripts = {
            enable = true,
          },
        },
      },
    },
  },
}
