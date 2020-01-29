" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim/plugged')

    " Language Server Plugin
    Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch': 'next',
        \ 'do': 'bash install.sh',
        \ }
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " Autocompletions
    Plug 'SirVer/ultisnips' " Snippets
    Plug 'aonemd/kuroi.vim' " Color Scheme
    Plug 'christoomey/vim-tmux-navigator' " Unify keyboard navigation between vim and tmux
    Plug 'janko-m/vim-test' " Run test under cursor
    Plug 'jiangmiao/auto-pairs' " Insert or delete brackets, parens, quotes in pair.
    Plug 'justinmk/vim-sneak' " Navigate with s{char}{char} and ;/,
    Plug 'liuchengxu/vim-clap', { 'do': function('clap#helper#build_all') } " Ctrl+p
    Plug 'mattn/emmet-vim' " Emmet for html/css completions
    Plug 'nelstrom/vim-visual-star-search' " Use * to search for word under cursor
    Plug 'romainl/vim-cool' " Stop matching after search is done.
    Plug 'sbdchd/neoformat' " Auto formatting
    Plug 'sheerun/vim-polyglot' " Additional language support
    Plug 'tomtom/tcomment_vim' " Commant with gc
    Plug 'tpope/vim-fugitive' " Git
    Plug 'tpope/vim-obsession' " Session management, to work with tmux resurrect
    Plug 'tpope/vim-repeat' " Repeat select commands (vim-surround) with .
    Plug 'tpope/vim-surround' " Surround selection with string
    Plug 'vim-airline/vim-airline' " Bottom status line
    Plug 'vimwiki/vimwiki' " Personal wiki

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
    set noswapfile
    set noundofile

    " Prevent deoplete from opening buffers on completion
    set completeopt="menu"
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
    set tabstop=4 " number of visual spaces per tab
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
map <leader>ew :e %% <cr>
map <leader>es :sp %% <cr>
map <leader>ev :vsp %% <cr>
map <leader>m :Gdiffsplit!<cr>

let g:LanguageClient_hoverPreview = 'always'
let g:LanguageClient_serverCommands = {
    \ 'dockerfile': ['docker-langserver', '--stdio'],
    \ 'go': ['gopls'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'javascript.jsx': ['javascript-typescript-stdio'],
    \ 'json': ['vscode-json-languageserver', '--stdio'],
    \ 'kotlin': ['~/work/kotlin-language-server/server/build/install/server/bin/kotlin-language-server'],
    \ 'python': ['/usr/local/bin/pyls'],
    \ 'ruby': ['~/.rbenv/shims/solargraph', 'stdio'],
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'scala': ['metals-vim'],
    \ 'sh': ['bash-language-server', 'start'],
    \ 'typescript': ['javascript-typescript-stdio'],
    \ 'typescript.tsx': ['javascript-typescript-stdio'],
    \ 'typescriptreact': ['javascript-typescript-stdio'],
    \ 'yaml': ['yaml-language-server', '--stdio'],
    \ }

let g:LanguageClient_rootMarkers = {
    \ 'javascript': ['jsconfig.json'],
    \ 'typescript': ['tsconfig.json'],
    \ }

let g:LanguageClient_loggingLevel = 'INFO'
let g:LanguageClient_virtualTextPrefix = ''
let g:LanguageClient_loggingFile =  expand('~/.local/share/nvim/LanguageClient.log')
let g:LanguageClient_serverStderr = expand('~/.local/share/nvim/LanguageServer.log')

" Enable formatting with LanguageClient using gq
set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()

nnoremap <silent> <leader>; :call LanguageClient_contextMenu()<CR>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>

" Clap
let g:clap_provider_grep_delay = 0
let g:clap_provider_grep_blink = [0, 0]
nnoremap <C-p> :Clap files<CR>
nnoremap <leader>ff :Clap<CR>
nnoremap <leader>fg :Clap grep<CR>
nnoremap <leader>fb :Clap buffers<CR>
nnoremap <leader>fs :Clap grep ++query=<cword><CR>

" NERDCommenter
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Use deoplete
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option({
\   'camel_case': v:true,
\ })

" Deoplete tab completion
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" UltiSnips
let g:UltiSnipsExpandTrigger="<s-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" Use Powerline font for airline
let g:airline_powerline_fonts = 1

" Use Ctrl+Z as Emmet Prefix
let g:user_emmet_leader_key='<C-Z>'
let g:user_emmet_mode='n'    "only enable normal mode functions.

" Map ctrl+move to move between split panels
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Save with \w
nnoremap <leader>w :w<cr>

" Colorscheme
set termguicolors
set background=dark
colorscheme kuroi
highlight EndOfBuffer cterm=NONE gui=NONE

" enable vim-repeat
silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)

" Enable Alt
" Run a given vim command on the results of alt from a given path.
" See usage below.
function! AltCommand(path, vim_command)
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


let g:neoformat_try_formatprg = 1

" Language Specific Settings {{{
autocmd FileType javascript setlocal formatprg=yarn\ --silent\ prettier\ --tab-width\ 4\ --print-width\ 100
autocmd FileType typescript setlocal formatprg=yarn\ --silent\ prettier\ --tab-width\ 4\ --print-width\ 100
autocmd FileType typescriptreact setlocal formatprg=yarn\ --silent\ prettier\ --tab-width\ 4\ --print-width\ 100

autocmd BufWritePre *.go Neoformat
" autocmd BufWritePre *.js Neoformat
autocmd BufWritePre *.py Neoformat
autocmd BufWritePre *.rs Neoformat
autocmd BufWritePre *.scala Neoformat
" autocmd BufWritePre *.ts Neoformat
" }}}
