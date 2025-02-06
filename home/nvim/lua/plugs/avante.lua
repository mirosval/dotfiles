require("avante_lib").load()
require("avante").setup({
  provider = "openrouter",
  vendors = {
    openrouter = {
      __inherited_from = "openai",
      endpoint = "https://openrouter.ai/api/v1",
      api_key_name = "OPENROUTER_API_KEY",
      model = "anthropic/claude-3.5-sonnet",
    }
  }
})
