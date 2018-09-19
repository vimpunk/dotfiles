" Turn off Vi compatibility. Has to be first.
set nocompatible

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

" ------------------------------------------------------------------------------ 
" Editing
" ------------------------------------------------------------------------------ 
Plug 'scrooloose/nerdcommenter'
" Easily change, delete or add surroundings such as brackets, parentheses, quotes...
Plug 'tpope/vim-surround'
" Auto insert endings to structures like if, do, ifndef etc
Plug 'tpope/vim-endwise'
" Auto insert matching brackets, parentheses, quotes etc
Plug 'jiangmiao/auto-pairs'
" Extend % matching to HTML tags and others.
Plug 'tmhedberg/matchit'
" Repeat plugin mappings.
Plug 'tpope/vim-repeat'
" Syntax aware visual selection.
Plug 'terryma/vim-expand-region'
" Expand abbreviations (mostly for inserting HTML elements).
Plug 'mattn/emmet-vim'

" ------------------------------------------------------------------------------ 
" Core enhancements
" ------------------------------------------------------------------------------ 
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Fuzzy searching
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Start screen
Plug 'mhinz/vim-startify'
" Mark indentation with thin vertical lines.
Plug 'Yggdroot/indentLine'
" Enhanced session management (the first one is a dependency).
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'

" ------------------------------------------------------------------------------ 
" Distraction free writing
" ------------------------------------------------------------------------------ 
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'junegunn/limelight.vim'
"Plug 'junegunn/vim-journal'

" ------------------------------------------------------------------------------ 
" Colorschemes
" ------------------------------------------------------------------------------ 
Plug 'mandreyel/vim-japanese-indigo'
Plug 'mandreyel/vim-mnd-solarized'
Plug 'mhartington/oceanic-next'
Plug 'arcticicestudio/nord-vim'
Plug 'chriskempson/base16-vim/'
Plug 'altercation/vim-colors-solarized'
Plug 'nightsense/stellarized' " This is great.
Plug 'nightsense/seagrey'
Plug 'nightsense/office'

" WIP
Plug '~/code/seasmoke'

" ------------------------------------------------------------------------------ 
" Languages
" ------------------------------------------------------------------------------ 
" Language Server Protocol
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" Async completion TODO get this to work
"if has('nvim')
  "Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"else
  "Plug 'roxma/vim-hug-neovim-rpc'
  "Plug 'roxma/nvim-yarp'
  "Plug 'Shougo/deoplete.nvim'
"endif

" Light weight language server plugin
"Plug 'natebosch/vim-lsc'

" Auto completion
"Plug 'maxboisvert/vim-simple-complete'

" Tab key completion
Plug 'ajh17/VimCompletesMe'
" TODO try this as an alternative: https://github.com/ervandew/supertab

Plug 'metakirby5/codi.vim' " REPL integration
Plug 'rust-lang/rust.vim'
Plug 'elzr/vim-json'
Plug 'posva/vim-vue'
Plug 'skammer/vim-css-color'
Plug 'gabrielelana/vim-markdown'

" ------------------------------------------------------------------------------ 
" Syntax
" ------------------------------------------------------------------------------ 
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'cespare/vim-toml'
Plug 'posva/vim-vue'

" ------------------------------------------------------------------------------ 
" Git
" ------------------------------------------------------------------------------ 
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/gv.vim'
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on':  'NERDTreeToggle' }

call plug#end()


" ==============================================================================
" Builtin settings
" ==============================================================================
" NOTE: this must go before all other mappings.
let mapleader = ' '
nnoremap <space> <nop>

filetype indent plugin on
syntax on

colorscheme mnd-solarized

" Don't pollute working directories (these need to exist, otherwise vim will
" bother you every time you want to save a file).
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

" Don't unload buffers when they're abandoned (also required for LSP operations
" modifying multiple buffers like rename).
set hidden

set number
set relativenumber
set showcmd " Show last command.
set lazyredraw
set encoding=utf-8
set nocursorline
set diffopt=filler,vertical
set autoread " Reload file if it has been changed outside of vim but not inside.
set nrformats=hex,bin " Consider hex and bin when {in,de}crementing numbers.
set wildmenu " This changed my life.
set wildmode=full
set laststatus=2 " Always display the statusline.

" Always leave 5 lines above/below the cursor when nearing the top/bottom of the
" window.
set scrolloff=5
" Due to scrollof, Shift+{H,L} no longer go to the top/bottom of the visible
" window, so we need to skip the rest of the way there with the movement
" commands.
nnoremap <S-h> <S-h>5k
nnoremap <S-l> <S-l>5j

" Quicker way to escape insert mode.
inoremap jj <Esc> 
inoremap jj <Esc> 
inoremap JJ <Esc> 
inoremap jk <Esc> 
inoremap Jk <Esc> 
inoremap JK <Esc> 

" Quicker way to resize a window.
nnoremap <F2> <C-w><
nnoremap <F3> <C-w>>

" Shortcuts to quickly edit and source .vimrc.
nnoremap <leader>ve :e $MYVIMRC<CR>
nnoremap <leader>vs :source $MYVIMRC<CR>

" Hack to be able to save read-only files.
cmap w!! w !sudo tee % >/dev/null

" Map commonly mistyped commands.
command! W w
command! Q q
command! WQ wq
command! Wq wq
command! Wqa wqa

" Visually select the text that was last edited/pasted (Vimcast#26).
noremap gV `[v`]
" Reselect visual block after indent.
vnoremap < <gv
vnoremap > >gv

let g:netrw_liststyle = 3
let g:netrw_winsize = 25

if has('mouse')
    set mouse=a
endif

" ------------------------------------------------------------------------------ 
" Formatting
" ------------------------------------------------------------------------------ 
set wrap
set linebreak " Don't break lines mid-word.
if exists('&breakindent')
    set breakindent " Preserve indentation when wrapping lines.
endif
set breakat&vim " Reset chars at which line is broken to vim defaults.
set textwidth=80
set nolist " Don't visualize tabs and line breaks.

" Show tabs (since space is preferred).
set listchars=tab:▸\ 
set listchars+=trail:⋅ " Show trailing spaces.
" Indicate that a line continues beyond the screen in no-wrap mode.
set listchars+=extends:❯,precedes:❮
let &showbreak='↳ ' " Pretty line break signaler.

" Tabs
set expandtab " Use spaces for tabs.
set tabstop=4 " Length of <Tab> in spaces.
set shiftwidth=4 " Number of spaces to use for auto indent.
set softtabstop=0 " Turn off. TODO why?
set smarttab

" Indentation
set smartindent " Instead of cindent as that seems to work poorly with non-C files.

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
set formatoptions+=a " Auto format text every time text is changed.
set formatoptions+=2 " Indent paragraph based on the second line rather than the first.

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
nnoremap <leader>ft :tabfirst<cr>
nnoremap <leader>lt :tablast<cr>

" Circular tab navigation.
nnoremap <leader><tab>   :tabn<cr>
nnoremap <leader><S-tab> :tabp<cr>

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
" Scripts & Autocommands
" ==============================================================================

" Unobtrusively highlight column 91 to indicate that the line is too long (this
" is a less obtrusive way of doing "set colorcolumn"). TODO use tw
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
augroup NumberToggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" .md file extensions should be treated as markdown rather than modula.
autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc

" ==============================================================================
" Plugin specific settings
" ==============================================================================

let g:indentLine_color_term = 246
let g:indentLine_color_gui = '#4f5b66'

let g:goyo_width = 80
let g:goyo_linenr = 1

let g:limelight_conceal_ctermfg = 'DarkGray'

let g:session_autosave = 'no'

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

nnoremap <F10> :NERDTreeToggle<CR>

" ------------------------------------------------------------------------------
" FZF
" ------------------------------------------------------------------------------
" Search of loaded buffer names.
nnoremap <leader>b :Buffers<CR>
" Recursive file name search starting from cwd.
nnoremap <leader>f :Files<CR>
" Recursive file name search among all git-tracked files.
nnoremap <leader>gf :GFiles<CR>

" Search in project.
nnoremap <leader>ss :Rg<CR>
" Search in current buffer.
nnoremap <leader>/ :BLines<CR>
nnoremap <leader>? :BLines<CR>

" Command search.
nnoremap <leader>sc :Commands<CR>
" Command history search.
nnoremap <leader>hc :History:<CR>
" File history search.
nnoremap <leader>hf :History<CR>
" Search history search.
nnoremap <leader>h/ :History/<CR>

" Customize fzf colors to always match current color scheme.
let g:fzf_colors = {
    \ 'fg':      ['fg', 'Normal'],
    \ 'bg':      ['bg', 'Normal'],
    \ 'hl':      ['fg', 'Comment'],
    \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
    \ 'hl+':     ['fg', 'Statement'],
    \ 'info':    ['fg', 'PreProc'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'Conditional'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment']
    \ }

" ------------------------------------------------------------------------------
" LanguageClient
" ------------------------------------------------------------------------------
" Language servers
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'stable', 'rls'],
    \ 'c': ['cquery', '--log-file=/tmp/cq.log', '--init={"extraClangArguments": ["-std=c99"],"index": {"comments": 2}, "cacheDirectory": "/tmp/cquery"}'],
    \ 'python': ['pyls'],
    \ 'ruby': ['~/.gem/ruby/2.5.0/bin/language_server-ruby'],
    \ 'sh': ['bash-language-server', 'start'],
    \ 'vue': ['vls'],
    \ }

" TODO something about the cpp langserver is really slowing down vim
"\ 'cpp': ['cquery', '--log-file=/tmp/cq.log', '--init={"extraClangArguments": ["-std=c++17"], "index": {"comments": 2}, "cacheDirectory": "/tmp/cquery"}'],
" Only run error checker once every second.
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

"command TrimWhitespace %s/\s\+$//e

" vim-lsc:
"let g:lsc_server_commands = {
    "\ 'rust': 'rustup run stable rls',
    "\ 'cpp': 'start-cquery-cpp',
    "\ 'c': 'start-cquery-c',
    "\ 'python': 'pyls',
    "\ 'ruby': '~/.gem/ruby/2.5.0/bin/language_server-ruby',
    "\ 'sh': 'bash-language-server start',
    "\ }

"let g:lsc_auto_map = {
    "\ 'GoToDefinition': '<leader>lg',
    "\ 'FindReferences': '<leader>lo',
    "\ 'Rename': '<leader>lr',
    "\ 'NextReference': '<C-n>',
    "\ 'PreviousReference': '<C-p>',
    "\ 'FindCodeActions': '<leader>la',
    "\ 'ShowHover': '<leader>lh',
    "\ 'DocumentSymbol': '<leader>ls',
    "\ 'FindImplementations': '<leader>li',
    "\ 'Completion': 'completefunc',
    "\}

"highlight lscDiagnosticError guifg='#9d5057'
"autocmd CompleteDone * silent! pclose
