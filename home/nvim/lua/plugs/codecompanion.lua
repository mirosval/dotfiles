require("codecompanion").setup({
  adapters = {
    openrouter = function()
      return require("codecompanion.adapters").extend("openai", {
        name = "openrouter",
        url = "https://openrouter.ai/api/v1/chat/completions",
        env = {
          api_key = "OPENROUTER_API_KEY",
        },
        schema = {
          model = {
            default = "anthropic/claude-3.5-sonnet",
          },
        },
      })
    end
  },
  strategies = {
    chat = {
      adapter = "openrouter"
    },
    inline = {
      adapter = "openrouter"
    }
  },
  opts = {
    log_level = "INFO",
  }
})
-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
