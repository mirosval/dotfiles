local lib = require('lib')

require('aerial').setup({
  on_attach = function()
    lib.nmap('<Leader>o', '<cmd>AerialToggle!<cr>')
  end
})
