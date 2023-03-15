local telescope = require('telescope')
local lib = require('lib')
local nmap = lib.nmap

telescope.setup{
    defaults = {
        file_sorter =  require'telescope.sorters'.get_fzy_sorter,
    },
    extensions = {
        ["ui-select"] = {

        }
    }
}

nmap("<C-p>", function() require('telescope.builtin').find_files({ hidden = true }) end)
nmap("<Leader>fg", ':Telescope live_grep<CR>')
nmap("<Leader>fd", ':Telescope lsp_document_symbols<CR>')
nmap("<Leader>fw", ':Telescope lsp_dynamic_workspace_symbols<CR>')
nmap("gd", ':Telescope lsp_definitions<CR>')
nmap("gr", ':Telescope lsp_references<CR>')
nmap("gi", ':Telescope lsp_implementations<CR>')
