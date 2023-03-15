local lib = {}

function lib.nmap(lhs, rhs, options)
  vim.keymap.set('n', lhs, rhs, options)
end

function lib.vmap(lhs, rhs, options)
  vim.keymap.set('v', lhs, rhs, options)
end

function lib.nvmap(lhs, rhs, options)
  lib.nmap(lhs, rhs, options)
  lib.vmap(lhs, rhs, options)
end

return lib
