local todo = require('todo-comments')
local lib = require('lib')
local nmap = lib.nmap

todo.setup({})

nmap(']t', todo.jump_next)
nmap('[t', todo.jump_prev)
nmap('<Leader>t', ':TodoTelescope<CR>')
