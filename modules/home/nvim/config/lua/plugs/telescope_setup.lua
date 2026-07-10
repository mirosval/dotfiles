local telescope = require("telescope")
-- local lib = require('lib')
-- local nmap = lib.nmap

telescope.setup({
  defaults = {
    file_sorter = require("telescope.sorters").get_fzy_sorter,
    path_display = {
      "truncate",
    },
  },
  pickers = {
    find_files = {
      -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
  },
  extensions = {
    ["ui-select"] = {},
  },
})
