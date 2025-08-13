-- Mini.nvim setup - collection of minimal, independent, and fast Lua modules
-- Documentation: https://github.com/echasnovski/mini.nvim

-- Initialize mini.nvim modules
-- Each module can be configured independently

-- mini.pairs - Auto-close brackets, quotes, etc.
require('mini.pairs').setup({
  -- Configuration for automatic pairing
  modes = { insert = true, command = false, terminal = false },
  -- skip autopair when next character is one of these
  skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
  -- skip autopair when the cursor is inside these treesitter nodes
  skip_ts = { 'string' },
  -- skip autopair when next character is closing pair and there are more closing pairs than opening pairs
  skip_unbalanced = true,
  -- better deal with markdown code blocks
  markdown = true,
})

-- mini.surround - Add/delete/replace surroundings (brackets, quotes, etc.)
require('mini.surround').setup({
  -- Configuration for surround mappings
  mappings = {
    add = 'sa', -- Add surrounding in Normal and Visual modes
    delete = 'sd', -- Delete surrounding
    find = 'sf', -- Find surrounding (to the right)
    find_left = 'sF', -- Find surrounding (to the left)
    highlight = 'sh', -- Highlight surrounding
    replace = 'sr', -- Replace surrounding
    update_n_lines = 'sn', -- Update `n_lines`
  },
})

-- mini.indentscope - Visualize and work with indent scope
require('mini.indentscope').setup({
  -- Configuration for indent scope visualization
  draw = {
    -- Delay (in ms) between event and start of drawing scope indicator
    delay = 100,
    -- Animation rule for scope's first drawing. A function which, given
    -- next and total step numbers, returns wait time (in ms). See
    -- |MiniIndentscope.gen_animation| for builtin options. To disable
    -- animation, use `require('mini.indentscope').gen_animation.none()`.
    animation = require('mini.indentscope').gen_animation.none(),
  },
  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Textobjects
    object_scope = 'ii',
    object_scope_with_border = 'ai',
    -- Motions (jump to respective border line; if not present - body line)
    goto_top = '[i',
    goto_bottom = ']i',
  },
  -- Options which control scope computation
  options = {
    -- Type of scope's border: which line(s) with smaller indent to
    -- categorize as border. Can be one of: 'both', 'top', 'bottom', 'none'.
    border = 'both',
    -- Whether to use cursor column when computing reference indent.
    -- Useful to see incremental scopes with horizontal cursor movements.
    indent_at_cursor = true,
    -- Whether to first check input line to be a border of adjacent scope.
    -- Use it if you want to place cursor on function header to get scope of
    -- its body.
    try_as_border = false,
  },
  -- Which character to use for drawing scope indicator
  symbol = '╎',
})

-- mini.hipatterns - Highlight patterns in text
require('mini.hipatterns').setup({
  highlighters = {
    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
    fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
    hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
    todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
    note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },
    
    -- Highlight hex color strings (`#rrggbb`) using that color
    hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
  },
})

-- TODO: Add more mini modules as needed:
-- - mini.pick (fuzzy finder, potential telescope replacement)
-- - mini.statusline (status line, potential lualine replacement)
-- - mini.diff (git diff functionality)
-- - mini.jump or mini.jump2d (fast movement, potential vim-sneak replacement)
-- - mini.operators (text transformations, potential text-case replacement)
-- - mini.clue (key binding hints, potential legendary replacement)
-- - mini.icons (file type icons, potential nvim-web-devicons replacement)