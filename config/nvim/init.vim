" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim/plugged')

    Plug 'aonemd/kuroi.vim' " Color Scheme
    Plug 'christoomey/vim-tmux-navigator' " Unify keyboard navigation between vim and tmux
    Plug 'janko-m/vim-test' " Run test under cursor
    Plug 'jiangmiao/auto-pairs' " Insert or delete brackets, parens, quotes in pair.
    Plug 'justinmk/vim-sneak' " Navigate with s{char}{char} and ;/,
    Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' } " Ctrl+p
    Plug 'mattn/emmet-vim' " Emmet for html/css completions
    Plug 'mhinz/vim-signify'
    Plug 'nelstrom/vim-visual-star-search' " Use * to search for word under cursor
    " Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'} " CoC TypeScript support
    " Plug 'neoclide/coc.nvim', {'branch': 'release'} " Language Server Suport
    Plug 'nicwest/vim-camelsnek' " Camel case to Snek case or Kebab case
    Plug 'puremourning/vimspector' " Debugging in vim
    Plug 'romainl/vim-cool' " Stop matching after search is done.
    Plug 'sheerun/vim-polyglot' " Additional language support
    Plug 'tomtom/tcomment_vim' " Commant with gc
    Plug 'tpope/vim-fugitive' " Git
    Plug 'tpope/vim-obsession' " Session management, to work with tmux resurrect
    Plug 'tpope/vim-repeat' " Repeat select commands (vim-surround) with .
    Plug 'tpope/vim-surround' " Surround selection with string
    Plug 'vim-airline/vim-airline' " Bottom status line
    Plug 'neovim/nvim-lspconfig' " Collection of common configurations for the Nvim LSP client
    Plug 'tjdevries/lsp_extensions.nvim' " Extensions to built-in LSP, for example, providing type inlay hints
    Plug 'nvim-lua/completion-nvim' " Autocompletion framework for built-in LSP
    Plug 'nvim-lua/diagnostic-nvim' " Diagnostic navigation and settings for built-in LSP

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

    " Prevent deoplete from opening buffers on completion
    set completeopt=menuone,noinsert,noselect

    " Update faster
    set updatetime=300

    " don't give |ins-completion-menu| messages.
    set shortmess+=c

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
    set ttyfast " faster redrawing
    set diffopt+=vertical
    set laststatus=2 " show the satus line all the time
    set wildmenu " enhanced command line completion
    set hidden " current buffer can be put into background
    set showcmd " show incomplete commands
    set noshowmode " don't show which mode disabled for PowerLine
    set wildmode=list:longest " complete files like a shell
    set shell=$SHELL
    set cmdheight=2 " command bar height
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

" Clap
let g:clap_provider_grep_delay = 0
let g:clap_provider_grep_blink = [0, 0]
let g:clap_provider_grep_opts = '--with-filename --no-heading --vimgrep --hidden -g "!.git/"'
nnoremap <C-p> :Clap files ++finder=fd --type f --hidden --no-ignore --exclude '.git' --exclude 'target' --exclude '.cache' --exclude 'node_modules' --exclude 'dist' --exclude '.mypy_cache'<CR>
nnoremap <leader>ff :Clap<CR>
nnoremap <leader>fg :Clap grep2<CR>
nnoremap <leader>fb :Clap buffers<CR>
nnoremap <leader>fs :Clap grep ++query=<cword><CR>

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

" Enable Alt
" Run a given vim command on the results of alt from a given path.
" See usage below.
function! AltCommand(path, vim_command) abort
  let l:alternate = system("alt " . a:path)
  if empty(l:alternate)
    echo "No alternate file for " . a:path . " exists!"
  else
    exec a:vim_command . " " . l:alternate
  endif
endfunction

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

" https://github.com/neovim/nvim-lspconfig#rust_analyzer
lua <<EOF

local nvim_lsp = require'nvim_lsp'

-- attach completion and diag on setup
local on_attach = function(client) 
    require'completion'.on_attach(client)
    require'diagnostic'.on_attach(client)
end

nvim_lsp.rust_analyzer.setup({ on_attach=on_attach })

EOF

" Trigger completion with <Tab>
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ completion#trigger_completion()

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Code navigation shortcuts
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>

" Visualize diagnostics
let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_trimmed_virtual_text = '40'
" Don't show diagnostics while in insert mode
let g:diagnostic_insert_delay = 1

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hold
autocmd CursorHold * lua vim.lsp.util.show_line_diagnostics()

" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>PrevDiagnosticCycle<cr>
nnoremap <silent> g] <cmd>NextDiagnosticCycle<cr>

" have a fixed column for the diagnostics to appear in
" this removes the jitter when warnings/errors flow in
set signcolumn=yes

" Enable type inlay hints
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
\ lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment" }

set termguicolors
" set background=dark
augroup Highlights
    autocmd!
    autocmd ColorScheme * highlight EndOfBuffer cterm=NONE gui=NONE
                      \ | highlight LineNr guifg=Grey
                      \ | highlight Cursor guifg=white guibg=red
                      \ | highlight iCursor guifg=white guibg=red
                      \ | highlight MatchParen cterm=underline ctermbg=black ctermfg=red
                      \ | highlight MatchParen gui=underline guibg=black guifg=red
augroup end
colorscheme kuroi
