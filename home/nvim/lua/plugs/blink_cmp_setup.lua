require("blink-cmp").setup({
  keymap = {
    preset = 'super-tab',
    completion = {
      list = {
        selection = {
          preselect = function(_) return not require('blink-cmp').snippet_active({ direction = 1 }) end
        }
      }
    }
  }
})
