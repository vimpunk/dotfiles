" ==============================================================================
" Plugins
" ==============================================================================

" Download vim-plug if it's not installed on this machine.
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')

Plug 'rust-lang/rust.vim'
"Plug 'Valloric/YouCompleteMe'
"Plug 'w0rp/ale'

" Language Server Protocol
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" Fuzzy search utility.
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" For distraction free writing.
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'scrooloose/nerdcommenter'

" TODO test
"Plug 'majutsushi/tagbar' Plug 'ludovicchabant/vim-gutentags'

call plug#end()


" ==============================================================================
" Plugin specific settings
" ==============================================================================

let g:indentLine_color_term = 239
let g:goyo_width = 90
let g:limelight_conceal_ctermfg = 'DarkGray'

nnoremap <F10> :NERDTreeToggle<CR>

set hidden " (Required for operations modifying multiple buffers like rename.)
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'stable', 'rls'],
    \ }

"" ------------------------------------------------------------------------------
"" ALE
"" ------------------------------------------------------------------------------
"let g:ale_linters = {'rust': ['rls']}
"let g:ale_rust_rls_toolchain = 'stable'
"" Don't lint immediately.
"let g:ale_lint_delay = 1000
"" Don't lint when file is opened.
"let g:ale_lint_on_enter = 0
"" Navigate errors using ALE's builtins.
"nmap <silent> <C-k> <Plug>(ale_previous_wrap)
"nmap <silent> <C-j> <Plug>(ale_next_wrap) 

"" ------------------------------------------------------------------------------
"" YouCompleteMe
"" ------------------------------------------------------------------------------
"" Generate .c and .cpp compile_commands.json files.
"let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
"nnoremap <leader>g :YcmCompleter GoTo<CR>
"" TODO <leader>d doesn't work.
"nnoremap <C-d> :YcmCompleter GetDoc<CR>


" ==============================================================================
" Builtin settings
" ==============================================================================

filetype indent plugin on
set textwidth=80

" Don't pollute working directories (these need to exist, otherwise vim will
" bother you every time you want to save a file).
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

syntax on
set smartindent
set number
set relativenumber
set tabstop=4
set softtabstop=0
set expandtab
set shiftwidth=4
set smarttab
set nolist " Don't visualize tabs and line breaks.
set wrap
set linebreak " Don't break lines mid-word.
set breakat&vim " Reset chars at which line is broken to vim defaults.
set showcmd
set lazyredraw
set encoding=utf-8
set nocursorline
set diffopt=filler,vertical
set autoread " Reload file if it has been changed outside of vim but not inside.
set nrformats=hex,bin " Consider hex and bin when {in,de}crementing numbers.
set breakindent " Preserve indentation when wrapping lines.
set wildmenu " This changed my life.
set wildmode=full

" Hack to be able save read-only files.
cmap w!! w !sudo tee % >/dev/null

set scrolloff=5
" Due to scrollof, Shift+{H,L} no longer go to the top/bottom of the visible
" window, so we need to skip the rest of the way there with the movement
" commands.
nnoremap <S-H> <S-H>5k
nnoremap <S-L> <S-L>5j

" Quicker way to escape insert mode.
inoremap jj <Esc> 
inoremap jk <Esc> 

" ------------------------------------------------------------------------------
" Buffers
" ------------------------------------------------------------------------------
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>

" ------------------------------------------------------------------------------
" Tabs
" ------------------------------------------------------------------------------
nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>

" ------------------------------------------------------------------------------
" Mapleader mappings
" ------------------------------------------------------------------------------
let mapleader = " "
nnoremap <space> <nop>

" Open new line below and above current line.
nnoremap <leader>o o<esc>
nnoremap <leader>O O<esc>

" Shortcuts to quickly edit and source .vimrc.
nnoremap <leader>ev :tabe $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" ------------------------------------------------------------------------------
" Search
" ------------------------------------------------------------------------------
set hlsearch
set incsearch
set ignorecase smartcase
" Clear search highlight.
nnoremap <leader><space> :nohlsearch<CR>

" Make n and N always go in the same direction, no matter what search
" direction you started off with, and always center the current match on the
" screen.
nnoremap <expr> n 'Nn'[v:searchforward] . 'zz'
nnoremap <expr> N 'nN'[v:searchforward] . 'zz'

" ------------------------------------------------------------------------------ 
" Formatting
" ------------------------------------------------------------------------------ 
" Properly join two lines of comments by deleting the joined line's comment symbol(s).
set formatoptions+=j
" Auto format text.
set formatoptions+=c,a

" ------------------------------------------------------------------------------ 
" Movement
" ------------------------------------------------------------------------------ 
" Navigate wrapped lines as though they were normal lines with line breaks.
nnoremap j gj
nnoremap k gk
nnoremap $ g$
nnoremap 0 g0

" Movement in insert mode
inoremap <C-h> <C-o>h
inoremap <C-l> <C-o>a
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k

" Make Y behave like other capitalized movement commands.
nnoremap Y y$

" ----------------------------------------------------------------------------
" Moving lines up and down
" ----------------------------------------------------------------------------
nnoremap <silent> <C-k> :move-2<cr>
xnoremap <silent> <C-k> :move-2<cr>gv
nnoremap <silent> <C-j> :move+<cr>
xnoremap <silent> <C-j> :move'>+<cr>gv


" ==============================================================================
" Scripts
" ==============================================================================

" Unobtrusively highlight column 91 to indicate that the line is too long
" (this is a less obtrusive way of doing "set colorcolumn").
fun! s:color()
    highlight LineWidthLimit ctermfg=black ctermbg=white guibg=white
endfun
call s:color()
augroup ErrorHighlights
    autocmd!
    autocmd Colorscheme * call s:color()
    autocmd BufReadPost,BufNew * call matchadd('LineWidthLimit', '\%91v')
augroup end

" Show relative line numbers when in command mode or switching to another
" buffer, and show absolute line numbers when in insert mode.
:augroup NumberToggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END


"==========
" Dumpster
"==========
" Store currently unused or work-in-progress settings/scripts.

" Mark two or more spaces after some text as an error.
"syntax match DoubleSpace /\S\zs {2,}/
"highlight link DoubleSpace Error

" These only work when vim is compiled with +clipboard flag set:
" Copy to system clipboard.
"vnoremap <Leader>y "+y
"nnoremap <Leader>Y "+yg_
"nnoremap <Leader>y "+y

" Paste from system clipboard.
"nnoremap <Leader>p "+p
"nnoremap <Leader>P "+P
"vnoremap <Leader>p "+p
"vnoremap <leader>P "+P

" Instead of always linting, which is highly distracting, only lint when
" insert mode is left.
"let g:ale_lint_on_text_changed = 'never'
"let g:ale_lint_on_insert_leave = 1



"nnoremap <silent> <leader>lk :call LanguageClient_textDocument_hover()<CR>
"nnoremap <silent> <leader>ld :call LanguageClient_textDocument_definition()<CR>
"nnoremap <silent> <leader>lr :call LanguageClient_textDocument_rename()<CR>
"nnoremap <silent> <leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
"let g:LanguageClient_loggingLevel = 'DEBUG'


" Auto-completion.
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"let g:deoplete#enable_at_startup = 1
" deoplete dependencies:
"Plug 'roxma/nvim-yarp'
"Plug 'roxma/vim-hug-neovim-rpc'

" deoplete TAB completion
"inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" :
    "\ <SID>check_back_space() ? "\<TAB>" :
    "\ deoplete#mappings#manual_complete()
"function! s:check_back_space() abort "{{{
    "let col = col('.') - 1
    "return !col || getline('.')[col - 1]  =~ '\s'
"endfunction"}}}

" Split navigations. currently conflicts with line movements
"nnoremap <C-J> <C-W><C-J>
"nnoremap <C-K> <C-W><C-K>
"nnoremap <C-L> <C-W><C-L>
"nnoremap <C-H> <C-W><C-H>
