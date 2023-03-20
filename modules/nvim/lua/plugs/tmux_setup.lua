local tmux_nav = require('nvim-tmux-navigation')

local function nav(direction)
  local m = {
    up = tmux_nav.NvimTmuxNavigateUp,
    down = tmux_nav.NvimTmuxNavigateDown,
    left = tmux_nav.NvimTmuxNavigateLeft,
    right = tmux_nav.NvimTmuxNavigateRight,
  }

  return m[direction]
end


vim.keymap.set('n', "<C-h>", nav("left"))
vim.keymap.set('n', "<C-l>", nav("right"))
vim.keymap.set('n', "<C-k>", nav("up"))
vim.keymap.set('n', "<C-j>", nav("down"))
