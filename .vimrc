"========
" Vundle
"========

" vundle begin
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" Keep Plugin commands between vundle#begin/end.
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" installed plugins
"Plugin 'vim-syntastic/syntastic'
Plugin 'rust-lang/rust.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'chrisbra/Colorizer'
" TODO test
Plugin 'Valloric/YouCompleteMe'
Plugin 'majutsushi/tagbar' 
Plugin 'junegunn/goyo.vim'
Plugin 'Yggdroot/indentLine'
Plugin 'w0rp/ale'
"Plugin 'junegunn/fzf.vim'

" themes
Plugin 'mhartington/oceanic-next'
Plugin 'cocopon/iceberg.vim'


" dumpster
"Plugin 'xtal8/traces.vim'
"Plugin 'haya14busa/incsearch.vim'

call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
" vundle end


"==========================
" Plugin specific settings
"==========================

fun! s:SetOceanicNextTheme()
    if (has("termguicolors"))
        set termguicolors
    endif
    colorscheme OceanicNext
endfun
"call s:SetOceanicNextTheme()

let g:indentLine_color_term = 239
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
"TODO make it 100 for code, 80 for normal text
let g:goyo_width = 80


"==================
" Builtin settings
"==================

syntax on
set smartindent
set number
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
set nolist wrap linebreak breakat&vim

let mapleader = " "
nnoremap <space> <nop>

set hlsearch
set incsearch

" properly coalesce two lines of comments
set formatoptions+=j
" auto format text
set formatoptions+=c
" experimental:
" navigate wrapped lines as though they were normal lines with line breaks
nnoremap j gj
nnoremap k gk
nnoremap $ g$
nnoremap 0 g0

set textwidth=0

inoremap jj <Esc> 
map <F2> :bp <CR> 
map <F3> :bn <CR>
map <F9> :tabp <CR> 
map <F10> :tabn <CR>
" hack to be able save read-only files
cmap w!! w !sudo tee % >/dev/null

" don't pollute working directories
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

" make n and N always go in the same direction, no matter what search
" direction you started off with, and always center the current match on the
" screen
nnoremap <expr> n  'Nn'[v:searchforward] . 'zz'
nnoremap <expr> N  'nN'[v:searchforward] . 'zz'

" shortcuts to quickly edit and source .vimrc
nnoremap <Leader>ev :tabe $MYVIMRC<CR>
nnoremap <Leader>sv :source $MYVIMRC<CR>


"=========
" Scripts
"=========

" Unobtrusively highlight column 91 to indicate that the line is too long.
" This is a less obtrusive way of doing "set colorcolumn".
fun! s:color()
    highlight LineWidthLimit ctermbg=red guibg=red
endfun
call s:color()
augroup ErrorHighlights
    autocmd!
    autocmd Colorscheme * call s:color()
    autocmd BufReadPost,BufNew * call matchadd('LineWidthLimit', '\%91v')

    " Highlight trailing spaces.
    "autocmd InsertLeave * silent! execute 'call matchdelete(w:trailid)' \ |
    "let w:trailid = matchadd('ErrorMsg', '\s\+\%#\@!$', -1)
augroup end


"==========
" Dumpster
"==========

" mark two or more spaces after some text as an error
"syntax match DoubleSpace /\S\zs {2,}/
"highlight link DoubleSpace Error

" syntastic begin
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 0
"let g:syntastic_check_on_wq = 0
"let g:syntastic_cpp_check_header = 1
"let g:syntactic_cpp_compiler = 'g++'
"let g:syntactic_cpp_compiler_optinos = ' -std=c++14'
" syntastic end

" space doesn't show up in the command corner, so if this is an issue:
"map <space> <Leader>

"map <Esc> :noh<CR>

"set cc=90
