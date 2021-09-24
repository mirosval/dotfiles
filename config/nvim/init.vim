" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim/plugged')

    Plug 'Yggdroot/indentLine' " Indent line guide 
    Plug 'christoomey/vim-tmux-navigator' " Unify keyboard navigation between vim and tmux
    Plug 'folke/lsp-trouble.nvim' " LSP Diagnostics
    Plug 'folke/tokyonight.nvim'
    Plug 'glepnir/lspsaga.nvim'
    Plug 'hashivim/vim-terraform'
    Plug 'hoob3rt/lualine.nvim'
    Plug 'hrsh7th/nvim-compe'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'justinmk/vim-sneak' " Navigate with s{char}{char} and ;/,
    Plug 'kosayoda/nvim-lightbulb'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'lewis6991/gitsigns.nvim' " gitgutter replacement
    Plug 'lukas-reineke/indent-blankline.nvim' " Indent line guide also on blank lines
    Plug 'mattn/emmet-vim' " Emmet for html/css completions
    Plug 'nelstrom/vim-visual-star-search' " Use * to search for word under cursor
    Plug 'neovim/nvim-lspconfig' " Collection of common configurations for the Nvim LSP client
    Plug 'nicwest/vim-camelsnek' " Camel case to Snek case or Kebab case
    Plug 'nvim-lua/lsp-status.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'rafamadriz/friendly-snippets' " Snippet presets for vsnip
    Plug 'ray-x/lsp_signature.nvim' " Function signatures
    Plug 'romainl/vim-cool' " Stop matching after search is done.
    Plug 'ryanoasis/vim-devicons'
    Plug 'scalameta/nvim-metals' " Scala LSP
    Plug 'tomtom/tcomment_vim' " Commant with gc
    Plug 'tpope/vim-obsession' " Session management, to work with tmux resurrect
    Plug 'tpope/vim-repeat' " Repeat select commands (vim-surround) with .
    Plug 'tpope/vim-surround' " Surround selection with string
    Plug 'windwp/nvim-autopairs' " Pair parentheses

" Initialize plugin system
call plug#end()

" General {{{

    set autoread " detect when file is changed	

    set history=1000
    set textwidth=120

    set backspace=indent,eol,start " make backspace behave in a sane manner
    set clipboard+=unnamedplus

    set scrolloff=15 " keep the cursor centered vertically

    if has('mouse')
        set mouse=a
    endif

    " Searching
    set ignorecase " case insensitive searching
    set smartcase " case-sensitive if expresson contains a capital letter
    set hlsearch " highlight search results
    set incsearch " set incremental search, like modern browsers

    set magic " Set magic on, for regex

    " Replace
    set inccommand=nosplit " Live editing preview of the substitute command

    " error bells
    set noerrorbells
    set visualbell
    set t_vb=
    set tm=500

    " scroll the viewport faster
    nnoremap <C-e> 3<C-e>
    nnoremap <C-y> 3<C-y>

    " split in the correct direction
    set splitright
    set splitbelow

    " Disable backups, we have git
    set nobackup
    set nowritebackup
    set noswapfile
    set noundofile

    set completeopt=menuone,noselect

    " Update faster
    set updatetime=300

    " don't give |ins-completion-menu| messages.
    set shortmess+=c
    set shortmess-=F

    " Always show signcolumns
    set signcolumn=yes
" }}} General

" Appearance {{{

    set number " show line numbers
    set relativenumber " Show relative line numbers
    set wrap " turn on line wrapping
    set wrapmargin=8 " wrap lines when coming within n characters from side
    set linebreak " set soft wrapping
    set showbreak=… " show ellipsis at breaking
    set autoindent " automatically set indent of new line
    set diffopt+=vertical
    set laststatus=2 " show the satus line all the time
    set wildmenu " enhanced command line completion
    set hidden " current buffer can be put into background
    set showcmd " show incomplete commands
    set noshowmode " don't show which mode disabled for PowerLine
    set wildmode=list:longest " complete files like a shell
    set shell=$SHELL
    set cmdheight=1 " command bar height
    set title " set terminal title
    set showmatch " show matching braces

    " switch cursor to line when in insert mode, and block when not
    set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
    \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
    \,sm:block-blinkwait175-blinkoff150-blinkon175

" }}} Appearance

" Tabs and Spaces {{{

    set shiftwidth=4 " indent using >
    " number of visual spaces per tab this should remain at 8
    " https://www.reddit.com/r/vim/wiki/tabstop
    set tabstop=8 
    set softtabstop=4 " edit as if the tabs are 4 characters wide
    set expandtab
    set smarttab
    set autoindent
    set copyindent
    set shiftround

    " code folding settings
    set foldmethod=syntax " fold based on indent
    set foldlevelstart=99
    set foldnestmax=10 " deepest fold is 10 levels
    set nofoldenable " don't fold by default
    set foldlevel=1

    " toggle invisible characters
    set list
    set listchars=tab:→\ ,trail:⋅,extends:❯,precedes:❮
    set showbreak=↪

    " highlight conflicts
    match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" }}} Tabs and spaces

let mapleader = "\\"

" Expand to the current directory
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
noremap <leader>ew :e %% <cr>
noremap <leader>es :sp %% <cr>
noremap <leader>ev :vsp %% <cr>
noremap <leader>m :Gdiffsplit!<cr>

vnoremap CK :Kebab<cr>
vnoremap CS :Snek<cr>
vnoremap CC :Camel<cr>

syntax enable
filetype plugin indent on

" NERDCommenter
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Use Powerline font for airline
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1

" Use Ctrl+Z as Emmet Prefix
let g:user_emmet_leader_key='<c-y>'
let g:user_emmet_mode='n'    "only enable normal mode functions.

" Map ctrl+move to move between split panels
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

" Save with \w
nnoremap <leader>w :w<cr>

" enable vim-repeat
silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)

" Find the alternate file for the current path and open it
nnoremap <leader>. :w<cr>:call AltCommand(expand('%'), ':e')<cr>

" IDEA {{{
if !has('nvim')
    set ideajoin " allows ctrl+j in idea
    set surround " emulates vim-surround in idea
    map gd :action GotoDeclaration<CR>
    map K :action QuickJavaDoc<CR>
endif
" }}}

set termguicolors
let g:tokyonight_style = 'night'
colorscheme tokyonight

" Statusline
function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction

" LSP Saga
lua << EOF

require'lsp_config'
require'treesitter'
require'compe_config'

local saga = require 'lspsaga'
saga.init_lsp_saga()


require('telescope').setup{
  defaults = {
    file_sorter =  require'telescope.sorters'.get_fzy_sorter,
  }
}

require('nvim-autopairs').setup()

require('gitsigns').setup()

local function lsp_status_segment()
    return require'lsp-status'.status()
end

require('lualine').setup{
    options = {
        theme = 'tokyonight'
    },
    sections = {
        lualine_c = { 'filename', 'diff' },
        lualine_x = { 'encoding', 'fileformat', 'filetype', lsp_status_segment }
    }
}

require("trouble").setup {
}

EOF

nnoremap <silent> <A-d> :Lspsaga open_floaterm<CR>
nnoremap <silent> <C-b> <cmd>lua require('lspsaga.hover').smart_scroll_hover(-1)<CR>
nnoremap <silent> <C-f> <cmd>lua require('lspsaga.hover').smart_scroll_hover(1)<CR>
nnoremap <silent> <leader>cd :Lspsaga show_line_diagnostics<CR>
nnoremap <silent> [e :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> ]e :Lspsaga diagnostic_jump_prev<CR>
nnoremap <silent><leader>ac <cmd>Telescope lsp_code_actions<CR>
vnoremap <silent><leader>ac :<C-U>Telescope lsp_range_code_actions<CR>
nnoremap <silent>K :Lspsaga hover_doc<CR>
nnoremap <silent>gD <cmd>lua vim.lsp.buf.declaration()<CR>
" nnoremap <silent>gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent>gd :Telescope lsp_definitions<CR>
nnoremap <silent>gh :Lspsaga lsp_finder<CR>
nnoremap <silent>gr :Telescope lsp_references<CR>
" nnoremap <silent>gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent>gi :Telescope lsp_implementations<CR>
nnoremap <silent>gpd :Lspsaga preview_definition<CR>
nnoremap <silent>gs :Lspsaga signature_help<CR>
nnoremap <silent>rn :Lspsaga rename<CR>
tnoremap <silent> <A-d> <C-\><C-n>:Lspsaga close_floaterm<CR>

nnoremap <C-p> <cmd>lua require('telescope.builtin').find_files({ hidden = true })<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<CR>
nnoremap <leader>fd <cmd>Telescope lsp_document_symbols<CR>
nnoremap <leader>fw <cmd>Telescope lsp_dyncamic_workspace_symbols<CR>

" Trouble
nnoremap <leader>xx <cmd>LspTroubleToggle<cr>
nnoremap <leader>xw <cmd>LspTroubleToggle lsp_workspace_diagnostics<cr>
nnoremap <leader>xd <cmd>LspTroubleToggle lsp_document_diagnostics<cr>
nnoremap <leader>xq <cmd>LspTroubleToggle quickfix<cr>
nnoremap <leader>xl <cmd>LspTroubleToggle loclist<cr>
nnoremap gR <cmd>LspTroubleToggle lsp_references<cr>

augroup Formatting
    autocmd!
    autocmd BufWritePre *.rs,*.ts,*.tsx,*.js,*.jsx lua vim.lsp.buf.formatting_sync(nil, 1000)
augroup end

" nvim-compe
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

" use treesitter for folds
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

augroup lsp
    au!
    au FileType scala,sbt lua require("metals").initialize_or_attach({})
augroup end
