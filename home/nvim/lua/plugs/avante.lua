require("avante_lib").load()
require("avante").setup({
  provider = "openai",
  openai = {
    model = "gpt-4o-mini"
  }
})
