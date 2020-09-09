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
    Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'} " CoC TypeScript support
    Plug 'neoclide/coc.nvim', {'branch': 'release'} " Language Server Suport
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
    set completeopt="menu"

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

vnoremap CK :Kebab<cr>
vnoremap CS :Snek<cr>
vnoremap CC :Camel<cr>

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json,rust setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Coc Actions
" Remap for do codeAction of selected region
function! s:cocActionsOpenFromSelected(type) abort
  execute 'CocCommand actions.open ' . a:type
endfunction
xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@

" Clap
let g:clap_provider_grep_delay = 0
let g:clap_provider_grep_blink = [0, 0]
let g:clap_provider_grep_opts = '--with-filename --no-heading --vimgrep --hidden -g "!.git/"'
nnoremap <C-p> :Clap files ++finder=fd --type f --hidden --no-ignore --exclude '.git' --exclude 'target'<CR>
nnoremap <leader>ff :Clap<CR>
nnoremap <leader>fg :Clap grep<CR>
nnoremap <leader>fb :Clap buffers<CR>
nnoremap <leader>fs :Clap grep ++query=<cword><CR>

" NERDCommenter
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

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
highlight LineNr guifg=Grey
highlight Cursor guifg=white guibg=red
highlight iCursor guifg=white guibg=red

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
