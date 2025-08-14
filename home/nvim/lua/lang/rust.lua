vim.g.rustaceanvim = {
  tools = {},
  server = {
    settings = {
      ["rust-analyzer"] = {
        files = {
          excludeDirs = {
            ".cargo",
            ".direnv", -- Prevent Rust Analyzer from getting stuck on "Roots Scanned"
            ".git",
            ".jj",
            "target",
          },
        },
      },
    },
  },
}
