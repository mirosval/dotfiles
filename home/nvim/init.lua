-- general vim options
require("opts")
-- load/install plugins
require("plug")
-- neovim diagnostics
require("diag")
-- neovim lsp
require("lsp").setup()
-- neovim completions
-- setup languages
require("lang.rust")
require("lang.scala")
-- setup plugins
require("plugs.cmp_setup")
