" Turn off Vi compatibility. Has to be first.
set nocompatible

" ==============================================================================
" Plugins
" ==============================================================================

if has('nvim')
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
else
  " Download vim-plug if it's not installed on this machine.
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endif

" if the swap, backup,undo directories don't exist, create them
if empty(glob('~/.vim/swap'))
  silent !mkdir ~/.vim/swap
endif

if empty(glob('~/.vim/backup'))
  silent !mkdir ~/.vim/backup
endif

if empty(glob('~/.vim/undo'))
  silent !mkdir ~/.vim/undo
endif

function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release
    else
      !cargo build --release --no-default-features --features json-rpc
    endif
  endif
endfunction

call plug#begin('~/.vim/bundle')

" ------------------------------------------------------------------------------
" Editing
" ------------------------------------------------------------------------------
Plug 'scrooloose/nerdcommenter'
" Easily change, delete or add surroundings such as brackets, parentheses, quotes...
Plug 'tpope/vim-surround'
" Auto insert endings to structures like if, do, ifndef etc.
"
" NOTE: Disabled due to interference with coc.nvim autocompleteion.
"Plug 'tpope/vim-endwise'
" Auto insert matching brackets, parentheses, quotes etc
Plug 'jiangmiao/auto-pairs'
" Extend % matching to HTML tags and others.
Plug 'tmhedberg/matchit'
" Repeat plugin mappings.
Plug 'tpope/vim-repeat'
" Syntax aware visual selection.
Plug 'terryma/vim-expand-region' " TODO test
" Expand abbreviations (mostly for inserting HTML elements).
Plug 'mattn/emmet-vim' " TODO test

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
Plug 'danro/rename.vim'

" ------------------------------------------------------------------------------
" Languages
" ------------------------------------------------------------------------------
"Plug 'w0rp/ale' " Language server client and lint engine.
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'metakirby5/codi.vim' " REPL integration
Plug 'rust-lang/rust.vim'
Plug 'leafgarland/typescript-vim'
Plug 'elzr/vim-json'
Plug 'posva/vim-vue'
Plug 'gabrielelana/vim-markdown' " seems slow, TODO: profile
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'cespare/vim-toml'

" ------------------------------------------------------------------------------
" Git
" ------------------------------------------------------------------------------
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" browse git commits (it's great)
Plug 'junegunn/gv.vim'

" ------------------------------------------------------------------------------
" Distraction free writing
" ------------------------------------------------------------------------------
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'junegunn/limelight.vim'
"Plug 'junegunn/vim-journal'

" ------------------------------------------------------------------------------
" Color schemes
" ------------------------------------------------------------------------------
Plug 'mandreyel/vim-japanese-indigo'
Plug 'mandreyel/vim-mnd-solarized'
Plug 'mhartington/oceanic-next'
Plug 'altercation/vim-colors-solarized'
Plug 'nightsense/stellarized' " This is great.
Plug 'nightsense/seagrey'
Plug 'rakr/vim-one'
Plug 'junegunn/seoul256.vim' " light variant is great
Plug 'NLKNguyen/papercolor-theme' " good github alternative (less bright)
Plug 'cormacrelf/vim-colors-github'

Plug 'https://github.com/vim-scripts/pyte'
Plug 'https://github.com/reedes/vim-colors-pencil'
Plug 'https://github.com/zefei/cake16'

call plug#end()


" ==============================================================================
" Builtin settings
" ==============================================================================
" NOTE: this must go before all other mappings.
let mapleader = ' '
nnoremap <space> <nop>

filetype indent plugin on
syntax on

" To set the background automatically based on the time at which vim is
" launched.
"
" Light during the day, dark during night.
if (strftime('%H') >= 16 && strftime('%H') < 18)
  set bg=light
  colorscheme PaperColor
  "let g:github_colors_soft = 1
  "colorscheme github
else
  colorscheme mnd-solarized
endif

" Enable CTRL+V and other general shortcuts in gvim.
if has("gui_running")
  " backspace and cursor keys wrap to previous/next line
  " CTRL-X and SHIFT-Del are Cut
  " CTRL-C and CTRL-Insert are Copy
  " CTRL-V and SHIFT-Insert are Paste
  " Use CTRL-Q to do what CTRL-V used to do
  " Use CTRL-S for saving, also in Insert mode
  " CTRL-Z is Undo; not in cmdline though
  " CTRL-Y is Redo (although not repeat); not in cmdline though
  " Alt-Space is System menu
  " CTRL-A is Select all
  " CTRL-Tab is Next window
  " CTRL-F4 is Close window
  source $VIMRUNTIME/mswin.vim
  behave mswin
endif

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
set showcmd " Show current command.
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

" Shortcuts to quickly edit and source .vimrc. (~/.vimrc path is specified as in
" case of using neovim we want to edit vimrc and not init.vim)
nnoremap <leader>ve :e ~/.vimrc<CR>
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

let g:netrw_liststyle = 3
let g:netrw_winsize = 25
let g:netrw_browsex_viewer = "xdg-open"

if has('mouse')
    set mouse=a
endif

set spelllang=en
set spell

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
" Indicate that a line continues beyond the screen in no-wrap mode (for vimdiff).
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

set formatoptions="" " Reset formatoptions.
set formatoptions+=j " Remove comment leader when joining comment lines.
set formatoptions+=c " Auto format text in plaintext files, or comments in source files.
set formatoptions+=r " Auto insert comment leader after hitting <Enter>.
set formatoptions+=o " Auto insert comment leader when hitting 'o' or 'O' in normal mode.
set formatoptions+=q " Allow formatting of comments with 'gq'.
set formatoptions+=l " Don't break long lines in insert mode.
" experimental:
set formatoptions+=1 " Break line before a single-letter word.
set formatoptions+=n " Recognize numbered lists.
set formatoptions+=2 " Indent paragraph based on the second line rather than the first.

" ------------------------------------------------------------------------------
" Buffers
" ------------------------------------------------------------------------------
nnoremap ]b :bnext<CR>
nnoremap [b :bprev<CR>

" ------------------------------------------------------------------------------
" Tabs
" ------------------------------------------------------------------------------
nnoremap ]t :tabn<CR>
nnoremap [t :tabp<CR>
nnoremap <leader>ft :tabfirst<CR>
nnoremap <leader>lt :tablast<CR>

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

" ----------------------------------------------------------------------------
" Statusline
" ----------------------------------------------------------------------------
" reset
set statusline=
" current file
set statusline+=\ %f
" whether current buffer is modified
set statusline+=\ %m


" ==============================================================================
" Scripts & Autocommands
" ==============================================================================

" Unobtrusively highlight column 82 to indicate that the line is too long (this
" is a less obtrusive way of doing "set colorcolumn"). TODO use tw
fun! s:HighlightCharLimit()
  highlight LineWidthLimit ctermfg=black ctermbg=grey guibg=#243447
endfun

if !has("gui_running")
  call s:HighlightCharLimit()
  augroup ErrorHighlights
    autocmd!
    autocmd Colorscheme * call s:HighlightCharLimit()
    autocmd BufReadPost,BufNew * call matchadd('LineWidthLimit', '\%82v')
  augroup end
endif

" Show relative line numbers when in command mode or switching to another
" buffer, and show absolute line numbers when in insert mode. However, only set
" relative number if number is also set. This avoids setting relative number
" when no number is set, e.g. in vim docs.
fun! s:SetRelativeNumber()
  if &number
    set relativenumber
  endif
endfun

fun! s:UnsetRelativeNumber()
  if &number
    set norelativenumber
  endif
endfun

augroup NumberToggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * call s:SetRelativeNumber()
  autocmd BufLeave,FocusLost,InsertEnter   * call s:UnsetRelativeNumber()
augroup end

augroup FileTypeSettings
  " .md file extensions should be treated as markdown rather than modula.
  autocmd BufNewFile,BufFilePre,BufRead *.md
              \ setl filetype=markdown.pandoc
              \ formatoptions-=a
              \ noautoindent
              \ textwidth=80

  " Dockerfile.builder is the conventional file name for builder docker files so
  " set file extensions to dockerfile.
  autocmd BufNewFile,BufFilePre,BufRead Dockerfile.builder set filetype=dockerfile

  " Overwriting `tw` in ftplugins/rust.vim doesn't work because I presume the
  " rust.vim plugin subsequently overwrites it, so in turn overwrite it here.
  autocmd FileType rust set textwidth=80

  " file types for which we want 2 space wide tabs
  autocmd FileType json,proto,vim,vue,yaml setl tabstop=2 shiftwidth=2
augroup end


" ==============================================================================
" Plugin settings
" ==============================================================================

let g:vim_json_syntax_conceal = 0

let g:indentLine_color_term = 246
let g:indentLine_color_gui = '#4f5b66'

let g:goyo_width = 90
let g:goyo_height = 100
let g:goyo_linenr = 1

let g:limelight_conceal_ctermfg = 'DarkGray'

let g:session_autosave = 'no'

nnoremap <F10> :NERDTreeToggle<CR>

" ------------------------------------------------------------------------------
" FZF
" ------------------------------------------------------------------------------
" Search of loaded buffer names.
nnoremap <leader>b :Buffers<CR>
" Recursive file name search starting from cwd.
nnoremap <leader>ff :Files<CR>
" Recursive file name search among all git-tracked files.
nnoremap <leader>gf :GFiles<CR>

" Search in project.
nnoremap <leader>ss :Ag<CR>
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
" COC
" ------------------------------------------------------------------------------

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=1000

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab to trigger completion with characters ahead and for completion
" navigation.
"
" NOTE: Use command ':verbose imap <tab>' and `:verbose imap <cr>` to make sure
" tab and cr are not mapped by other plugins before enabling this mapping.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>CheckBackSpace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:CheckBackSpace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if has('patch8.1.1068')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> <C-p> <Plug>(coc-diagnostic-prev)
nmap <silent> <C-n> <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> <leader>d <Plug>(coc-definition)
nmap <silent> <leader>y <Plug>(coc-type-definition)
nmap <silent> <leader>i <Plug>(coc-implementation)
nmap <silent> <leader>r <Plug>(coc-references)
nmap <silent> <leader>n <Plug>(coc-rename)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>ShowDocumentation()<CR>

function! s:ShowDocumentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup MyCocGroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected') tabstop=2 shiftwidth=2
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  " Autoformat file on save.
  "autocmd BufWritePost * Format
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>cap` for current paragraph
xmap <leader>c  <Plug>(coc-codeaction-selected)
nmap <leader>c  <Plug>(coc-codeaction-selected)

"" Remap keys for applying codeAction to the current line.
"" TODO: what's this?
"nmap <leader>ac  <Plug>(coc-codeaction)
"" Apply AutoFix to problem on the current line.
"nmap <leader>qf  <Plug>(coc-fix-current)

"" Introduce function text object
"" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
"" TODO: what's this?
"xmap if <Plug>(coc-funcobj-i)
"xmap af <Plug>(coc-funcobj-a)
"omap if <Plug>(coc-funcobj-i)
"omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
"nmap <silent> <TAB> <Plug>(coc-range-select)
"xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

"" Add `:Fold` command to fold current buffer.
"command! -nargs=? Fold :call     CocAction('fold', <f-args>)

"" Add `:OR` command for organize imports of the current buffer.
"command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <leader>a  :<C-u>CocList diagnostics<CR>
" Manage extensions.
nnoremap <silent> <leader>e  :<C-u>CocList extensions<CR>
" Show commands.
"nnoremap <silent> <leader>c  :<C-u>CocList commands<CR>
"" Find symbol of current document.
"nnoremap <silent> <leader>o  :<C-u>CocList outline<CR>
"" Search workspace symbols.
"nnoremap <silent> <leader>s  :<C-u>CocList -I symbols<CR>
"" Do default action for next item.
"nnoremap <silent> <leader>j  :<C-u>CocNext<CR>
"" Do default action for previous item.
"nnoremap <silent> <leader>k  :<C-u>CocPrev<CR> Resume latest coc list.
nnoremap <silent> <leader>p  :<C-u>CocListResume<CR>


"" ------------------------------------------------------------------------------
"" ALE
"" ------------------------------------------------------------------------------
"let g:ale_lint_on_text_changed = 1
"let g:ale_lint_on_insert_leave = 1
"let g:ale_close_preview_on_insert = 1
"let g:ale_set_balloons = 1

"let g:ale_completion_enabled = 1
"let g:ale_completion_max_suggestions = 30
"let g:ale_completion_delay = 500


"let g:ale_sign_error = "◉"
"let g:ale_sign_warning = "◉"
"let g:ale_sign_error = '✖'
"let g:ale_sign_warning = '⚠'

"" use unofficial rust-analyzer
"" https://github.com/dense-analysis/ale/issues/2832#issuecomment-596081235
"let g:ale_rust_rls_config = {
	"\ 'rust': {
		"\ 'all_targets': 1,
		"\ 'build_on_save': 1,
		"\ 'clippy_preference': 'on'
	"\ }
	"\ }
"let g:ale_rust_rls_toolchain = ''
"let g:ale_rust_rls_executable = 'rust-analyzer'
"let g:ale_linters = {
    "\ 'rust': ['rls']
    "\ }
"let g:ale_fixers = {
    "\ '*': ['remove_trailing_lines', 'trim_whitespace'],
    "\ 'rust': ['rustfmt']
    "\ }
"let g:ale_fix_on_save = 1 " autofix on saving

"nnoremap <leader>lh :ALEHover<CR>
"nnoremap <leader>lg :ALEGoToDefinition<CR>
"nnoremap <leader>lr :ALEFindReferences<CR>
"nnoremap <leader>ls :ALESymbolSearch
"nnoremap <leader>ld :ALEDetail<CR>
"nnoremap <C-p> :ALEPreviousWrap<CR>
"nnoremap <C-n> :ALENextWrap<CR>

"" Can't override ALE color highlights in the colorscheme, which is probably
"" loaded first, so overwrite them again here.
"hi link ALEError Error
"hi link ALEErrorLine Error
"hi link ALEErrorSign Error

"hi link ALEWarning Warning
"hi link ALEWarningLine Warning
"hi link ALEWarningSign Warning


"==========
" Dumpster
"==========
" Store currently unused or work-in-progress settings/scripts.

" Auto completion
"Plug 'maxboisvert/vim-simple-complete'

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

" Split navigations. currently conflicts with line movements
"nnoremap <C-J> <C-W><C-J>
"nnoremap <C-K> <C-W><C-K>
"nnoremap <C-L> <C-W><C-L>
"nnoremap <C-H> <C-W><C-H>

"" Automatically resize vertical splits.
":au WinEnter * :set winfixheight
":au WinEnter * :wincmd =

"command TrimWhitespace %s/\s\+$//e
