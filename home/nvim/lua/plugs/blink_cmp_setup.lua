require("blink-cmp").setup({
  keymap = {
    preset = 'super-tab',
  },
  completion = {
    ghost_text = {
      enabled = true,
    },
    list = {
      selection = {
        preselect = function(_) return not require('blink-cmp').snippet_active({ direction = 1 }) end
      }
    }
  },
  cmdline = {
    keymap = { preset = 'inherit' },
    completion = { menu = { auto_show = true } },
  },
})
