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
Plugin 'vim-syntastic/syntastic'
Plugin 'rust-lang/rust.vim'
Plugin 'scrooloose/nerdtree'

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

" syntastic begin
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_cpp_check_header = 1
let g:syntactic_cpp_compiler = 'g++'
let g:syntactic_cpp_compiler_optinos = ' -std=c++14'
" syntastic end

syntax on
set smartindent
set number
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
set cc=90
highlight ColorColumn ctermbg=235 guibg=#2c2d27
highlight LineNr ctermfg=grey
inoremap jj <Esc> 
map <F2> :bp <CR> 
map <F3> :bn <CR>
map <F7> :tabp <CR> 
map <F8> :tabn <CR>
set nolist wrap linebreak breakat&vim
set hlsearch
