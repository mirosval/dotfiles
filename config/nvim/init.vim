" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim/plugged')

    " General {{{
        
        set autoread " detect when file is changed	
        set number
        set relativenumber
        set showmatch

        set history=1000
        set textwidth=120

        set backspace=indent,eol,start " make backspace behave in a sane manner
        set clipboard=unnamed

        set scrolloff=30 " keep the cursor centered vertically
        
        if has('mouse')
            set mouse=a
        endif

        " Searching
        set ignorecase " case insensitive searching
        set smartcase " case-sensitive if expresson contains a capital letter
        set hlsearch " highlight search results
        set incsearch " set incremental search, like modern browsers
        set nolazyredraw " don't redraw while executing macros

        set magic " Set magic on, for regex

        " error bells
        set noerrorbells
        set visualbell
        set t_vb=
        set tm=500

    " }}} General
    
    " Appearance {{{

        set number " show line numbers
        set wrap " turn on line wrapping
        set wrapmargin=8 " wrap lines when coming within n characters from side
        set linebreak " set soft wrapping
        set showbreak=… " show ellipsis at breaking
        set autoindent " automatically set indent of new line
        set ttyfast " faster redrawing
        set diffopt+=vertical
        set laststatus=2 " show the satus line all the time
        set so=7 " set 7 lines to the cursors - when moving vertical
        set wildmenu " enhanced command line completion
        set hidden " current buffer can be put into background
        set showcmd " show incomplete commands
        set noshowmode " don't show which mode disabled for PowerLine
        set wildmode=list:longest " complete files like a shell
        set shell=$SHELL
        set cmdheight=1 " command bar height
        set title " set terminal title
        set showmatch " show matching braces
        set mat=2 " how many tenths of a second to blink

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
        set listchars=tab:→\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
        set showbreak=↪

        " highlight conflicts
        match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

    " }}} Tabs and spaces

    Plug 'nelstrom/vim-visual-star-search'

    Plug 'w0rp/ale'

    Plug 'janko-m/vim-test'

    Plug 'ensime/ensime-vim', { 'do': ':UpdateRemotePlugins' }

    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

    Plug 'cloudhead/neovim-fuzzy'

    Plug 'tpope/vim-surround'

    Plug 'vim-airline/vim-airline'

    Plug 'rust-lang/rust.vim'

    if executable("scalac")
        Plug 'derekwyatt/vim-scala', { 'for': 'scala' }
    endif

" Initialize plugin system
call plug#end()

" Use deoplete
let g:deoplete#enable_at_startup = 1

" Deoplete tab completion
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" fuzzy finder with ctrl-p
nnoremap <C-p> :FuzzyOpen<CR>

" Use Powerline font for airline
let g:airline_powerline_fonts = 1

" Map ctrl+move to move between split panels
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

