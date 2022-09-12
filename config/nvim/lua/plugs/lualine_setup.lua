local lualine = require('lualine')
local lsp_progress = {
    'lsp_progress',
    display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' }},
    spinner_symbols = { '🌑 ', '🌒 ', '🌓 ', '🌔 ', '🌕 ', '🌖 ', '🌗 ', '🌘 ' }
}

lualine.setup({
    options = {
        theme = 'tokyonight'
    },
    sections = {
        lualine_c = { 'filename', 'diff', lsp_progress },
        lualine_x = { 'encoding', 'fileformat', 'filetype' }
    }
})
