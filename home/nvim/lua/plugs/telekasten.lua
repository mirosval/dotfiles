local notes_path = "~/notes"
local templates_dir = '/templates'
require('telekasten').setup({
  home = vim.fs.normalize(notes_path), -- Put the name of your notes directory here
  dailies = vim.fs.normalize(notes_path .. '/daily'),
  weeklies = vim.fs.normalize(notes_path .. '/weekly'),
  templates = vim.fs.normalize(notes_path .. templates_dir),
  template_new_note = vim.fs.normalize(notes_path .. templates_dir .. '/new.md'),
  template_new_daily = vim.fs.normalize(notes_path .. templates_dir .. '/daily.md'),
  template_new_weekly = vim.fs.normalize(notes_path .. templates_dir .. '/weekly.md')
})
