


" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim/plugged')

Plug 'ensime/ensime-vim', { 'do': ':UpdateRemotePlugins' }

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'cloudhead/neovim-fuzzy'

Plug 'tpope/vim-surround'

Plug 'rust-lang/rust.vim'

if executable("scalac")
	Plug 'derekwyatt/vim-scala', { 'for': 'scala' }
endif

" Initialize plugin system
call plug#end()

" Use deoplete
let g:deoplete#enable_at_startup = 1

" fuzzy finder with ctrl-p
nnoremap <C-p> :FuzzyOpen<CR>

" Tabs and Spaces {{{
set tabstop=4 " number of visual spaces per tab
set expandtab
set autoindent
set copyindent
" }}} Tabs and spaces

" UI
set number
set showmatch
