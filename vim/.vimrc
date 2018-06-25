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

" Language Server Protocol
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" REPL integration
Plug 'metakirby5/codi.vim'

" Async completion
"if has('nvim')
  "Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"else
  "Plug 'Shougo/deoplete.nvim'
  "Plug 'roxma/nvim-yarp'
  "Plug 'roxma/vim-hug-neovim-rpc'
"endif

" Fuzzy searching
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Distraction free writing
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'junegunn/limelight.vim'
Plug 'junegunn/vim-journal'

Plug 'Yggdroot/indentLine'

" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'scrooloose/nerdcommenter'
" Easily change, delete or add surroundings such as brackets, parentheses, quotes...
Plug 'tpope/vim-surround'
" Auto insert endings to structures like if, do, ifndef etc
Plug 'tpope/vim-endwise'
" Auto insert matching brackets, parentheses, quotes etc
Plug 'jiangmiao/auto-pairs'
"Plug 'Yggdroot/hiPairs'

" Start screen
Plug 'mhinz/vim-startify'

" Colorschemes
"Plug 'mhartington/oceanic-next'
Plug 'arcticicestudio/nord-vim'
"Plug 'mandreyel/vim-japanese-indigo'
Plug 'chriskempson/base16-vim/'
Plug 'altercation/vim-colors-solarized'
" WIP
Plug '~/code/seasmoke'
Plug '~/code/vim-japanese-indigo'

call plug#end()


" ==============================================================================
" Builtin settings
" ==============================================================================

let g:netrw_liststyle = 3
let g:netrw_winsize = 25

" NOTE: this must go before all other mappings.
let mapleader = ' '
nnoremap <space> <nop>

filetype indent plugin on

" Don't pollute working directories (these need to exist, otherwise vim will
" bother you every time you want to save a file).
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

syntax on
colorscheme JapaneseIndigo

set number
set relativenumber
set nolist " Don't visualize tabs and line breaks.
set linebreak " Don't break lines mid-word.
set showcmd
set lazyredraw
set encoding=utf-8
set nocursorline
set diffopt=filler,vertical
set autoread " Reload file if it has been changed outside of vim but not inside.
set nrformats=hex,bin " Consider hex and bin when {in,de}crementing numbers.
set wildmenu " This changed my life.
set wildmode=full
set laststatus=2 " Always display the statusline.

" Hack to be able to save read-only files.
cmap w!! w !sudo tee % >/dev/null

" Always leave 5 lines above/below the cursor when nearing the top/bottom of the
" window.
set scrolloff=5
" Due to scrollof, Shift+{H,L} no longer go to the top/bottom of the visible
" window, so we need to skip the rest of the way there with the movement
" commands.
nnoremap <S-H> <S-H>5k
nnoremap <S-L> <S-L>5j

" Quicker way to escape insert mode.
inoremap jj <Esc> 
inoremap jk <Esc> 

" Shortcuts to quickly edit and source .vimrc.
nnoremap <leader>ev :e $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" ------------------------------------------------------------------------------ 
" Formatting
" ------------------------------------------------------------------------------ 
set wrap
set breakindent " Preserve indentation when wrapping lines.
set breakat&vim " Reset chars at which line is broken to vim defaults.
set textwidth=80

set softtabstop=0 " Turn off.
set expandtab " Use spaces for tabs.
set tabstop=4 " Length of <Tab> in spaces.
set shiftwidth=4 " Number of spaces to use for auto indent.
set smarttab
set cindent " Stricter rules for C/C++ programs.
set autoindent

set formatoptions="" " Reset fo.
set formatoptions+=j " Remove comment leader when joining comment lines.
set formatoptions+=c " Auto format text in plaintext files, or comments in source files.
set formatoptions+=r " Auto insert comment leader after hitting <Enter>.
set formatoptions+=o " Auto insert comment leader when hitting 'o' or 'O' in normal mode.
set formatoptions+=q " Allow formatting of comments with 'gq'.
set formatoptions+=l " Don't break long lines in insert mode.
" experimental:
set formatoptions+=1 " Break line before a single-letter word.
set formatoptions+=n " Recognize numbered lists.
"set formatoptions+=a " Auto format text every time text is changed.
"set formatoptions+=2 " Indent paragraph based on the second line rather than the first.

" ------------------------------------------------------------------------------
" Buffers
" ------------------------------------------------------------------------------
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>

" Circular split window navigation.
nnoremap <tab>   <c-w>w
nnoremap <S-tab> <c-w>W

" ------------------------------------------------------------------------------
" Tabs
" ------------------------------------------------------------------------------
nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>

" ------------------------------------------------------------------------------
" Search
" ------------------------------------------------------------------------------
set hlsearch
set incsearch
set ignorecase
set smartcase
" Clear search highlight.
nnoremap <leader><space> :nohlsearch<CR>

" Make n and N always go in the same direction, no matter what search
" direction you started off with, and always center the current match on the
" screen.
nnoremap <expr> n 'Nn'[v:searchforward] . 'zz'
nnoremap <expr> N 'nN'[v:searchforward] . 'zz'

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

" Open new line below and above current line.
nnoremap <leader>o o<esc>
nnoremap <leader>O O<esc>

" ----------------------------------------------------------------------------
" Moving lines up and down
" ----------------------------------------------------------------------------
nnoremap <silent> <C-k> :move-2<CR>
xnoremap <silent> <C-k> :move-2<CR>gv
nnoremap <silent> <C-j> :move+<CR>
xnoremap <silent> <C-j> :move'>+<CR>gv


" ==============================================================================
" Scripts
" ==============================================================================

" Unobtrusively highlight column 91 to indicate that the line is too long
" (this is a less obtrusive way of doing "set colorcolumn").
fun! s:color()
    highlight LineWidthLimit ctermfg=black ctermbg=grey guibg=#243447
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


" ==============================================================================
" Plugin specific settings
" ==============================================================================

let g:indentLine_color_term = 246
let g:indentLine_color_gui = '#4f5b66'

let g:goyo_width = 80
let g:goyo_linenr = 1

let g:limelight_conceal_ctermfg = 'DarkGray'

let g:japanese_indigo_bg = 'normal'
let g:japanese_indigo_fg = 'normal'

"let g:deoplete#enable_at_startup = 1
"let g:deoplete#enable_smart_case = 1

nnoremap <F10> :NERDTreeToggle<CR>

" ------------------------------------------------------------------------------
" FZF
" ------------------------------------------------------------------------------
" Fuzzy search of loaded buffer names.
nnoremap <leader>b :Buffers<CR>
" Fuzzy recursive search starting from cwd. Abbrev.:
nnoremap <leader>f :Files<CR>
" Fuzzy recursive search among all git-tracked files.
nnoremap <leader>gf :GFiles<CR>
" Fuzzy search in loaded buffers.
nnoremap <leader>ss :Lines<CR>
" Fuzzy search in current buffer.
nnoremap <leader>sl :BLines<CR>
" Ag (non-fuzzy) code search.
nnoremap <leader>ag :Ag<CR>

" ------------------------------------------------------------------------------
" LanguageClient
" ------------------------------------------------------------------------------
set hidden " (Required for operations modifying multiple buffers like rename.)

" Language servers
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'stable', 'rls'],
    \ 'cpp': ['cquery', '--log-file=/tmp/cq.log', '--init={"index": {"comments": 2}, "cacheDirectory": "/tmp/cquery"}'],
    \ 'c': ['cquery', '-std=c99', '--log-file=/tmp/cq.log', '--init={"index": {"comments": 2}, "cacheDirectory": "/tmp/cquery"}'],
    \ 'python': ['pyls'],
    \ 'ruby': ['~/.gem/ruby/2.5.0/bin/language_server-ruby'],
    \ 'sh': ['bash-language-server', 'start'],
    \ }
let g:LanguageClient_changeThrottle = 1

nnoremap <leader>lh :call LanguageClient_textDocument_hover()<CR>
nnoremap <leader>lg :call LanguageClient_textDocument_definition()<CR>
nnoremap <leader>lr :call LanguageClient_textDocument_rename()<CR>
nnoremap <leader>lo :call LanguageClient_textDocument_references()<CR>
nnoremap <leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
nnoremap <leader>lf :call LanguageClient_textDocument_rangeFormatting()<CR>


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

"" Automatically resize vertical splits.
":au WinEnter * :set winfixheight
":au WinEnter * :wincmd =
