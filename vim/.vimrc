" ==============================================================================
" Plugins
" ==============================================================================

" Download vim-plug if it's not installed on this machine.
if has('nvim')
  if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
else
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
Plug 'jiangmiao/auto-pairs'
" Extend % matching to HTML tags and others.
Plug 'tmhedberg/matchit'
" Repeat plugin mappings.
Plug 'tpope/vim-repeat'

" ------------------------------------------------------------------------------
" Core enhancements
" ------------------------------------------------------------------------------
" Fuzzy searching: note that we're not actually using the fzf.vim plugin due to
" coc.nvim providing most of the functionality. Instead, we just let vim-plug
" manage the system fzf installation.
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
"Plug 'junegunn/fzf.vim'

" Utilities package used by many neovim plugins.
if has('nvim')
  Plug 'nvim-lua/plenary.nvim'
endif

" Telescope is a search interface like FZF, but more integrated with nvim.
if has('nvim')
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'fannheyward/telescope-coc.nvim'
  " Disable telescope for now as it seems incomplete. Matches are
  " consistently worse than that of coc-list.
  let b:use_telescope = 0
endif

" Mark indentation with thin vertical lines.
Plug 'Yggdroot/indentLine'
" Rename files more easily.
Plug 'danro/rename.vim'

" Plugin to improve the quicklist.
" This is amazing. It teleports the quickfix into the future.
Plug 'kevinhwang91/nvim-bqf', {'branch': 'main'}

" ------------------------------------------------------------------------------
" Languages
" ------------------------------------------------------------------------------
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'rust-lang/rust.vim'
Plug 'leafgarland/typescript-vim'
Plug 'elzr/vim-json'
Plug 'posva/vim-vue'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'cespare/vim-toml'
Plug 'towolf/vim-helm'

" ------------------------------------------------------------------------------
" Git
" ------------------------------------------------------------------------------
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" Browse git commits (it's great).
Plug 'junegunn/gv.vim'

" ------------------------------------------------------------------------------
" Writing
" ------------------------------------------------------------------------------
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'junegunn/limelight.vim'

" Note taking with vim.
Plug 'vimwiki/vimwiki'

" ------------------------------------------------------------------------------
" Color schemes
" ------------------------------------------------------------------------------
Plug 'mandreyel/vim-mnd-solarized'
Plug 'nightsense/seagrey'
Plug 'junegunn/seoul256.vim' " light variant is great
Plug 'NLKNguyen/papercolor-theme' " good github alternative (less bright)
Plug 'cormacrelf/vim-colors-github'
Plug 'Rigellute/shades-of-purple.vim'
Plug 'ayu-theme/ayu-vim'

" ------------------------------------------------------------------------------
" Plugins in test
" ------------------------------------------------------------------------------

" Syntax aware visual selection.
Plug 'terryma/vim-expand-region' " TODO: test
" Expand abbreviations (mostly for inserting HTML elements).
Plug 'mattn/emmet-vim' " TODO: test
Plug 'tpope/vim-dadbod', { 'on': 'DB' }

" Statusline for (n)vim.
Plug 'liuchengxu/eleline.vim'

" TODO: configure these
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ryanoasis/vim-devicons'

"" Render markdown documents in a less distracting way in a popup window.
"if has('nvim')
  "Plug 'ellisonleao/glow.nvim', {'do': ':GlowInstall', 'branch': 'main'}
"endif

call plug#end()


" ==============================================================================
" Builtin settings
" ==============================================================================
" NOTE: this must go before all other mappings.
let mapleader = ' '
nnoremap <space> <nop>

filetype indent plugin on
syntax on

" Set the background automatically based on the time at which vim is
" launched. Light during the day, dark at night.
if (strftime('%H') >= 8 && strftime('%H') <= 16)
  "set bg=light
  "colorscheme PaperColor
endif

set bg=dark
colorscheme mnd-solarized


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
set undofile

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

set spell spelllang=en

" Highlight embedded code syntax.
let g:vimsyn_embed = 1

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
set laststatus=2 " Always display the statusline.
"" reset
"set statusline=
"" current file
"set statusline+=\ %f
"" whether current buffer is modified
"set statusline+=\ %m


" TODO: assign this to something sensible, currently conflicts with live_grep
"nnoremap <leader>gc /<<<<<<< HEAD\\|=======\\|>>>>>>><CR>

" ==============================================================================
" Scripts & Autocommands
" ==============================================================================

" Abuse jumplist to quickly navigate between files in the jumplist, rather than
" individual jump locations. From:
" https://www.reddit.com/r/vim/comments/cl7yns/buffer_switching_using_most_recent_buffers_list/evtpgd0?utm_source=share&utm_medium=web2x&context=3.
function! GoToRecentBuffer(direction)
  let limit = 0
  let start = bufname('%')
  let current = bufname('%')

  while (start == current) && (a:direction == 'previous' ? limit < 100 : limit <= 100)
    execute a:direction == 'previous' ? 'normal! \<C-o>' : 'normal! \<C-i>'

    let current = bufname('%')
    let limit += 1
  endwhile

  if start == current
    echo 'No ' . a:direction . ' file.'
  endif
endfunction

nnoremap <leader>o :call GoToRecentBuffer('previous')<CR>
nnoremap <leader>i :call GoToRecentBuffer('next')<CR>

" Show relative line numbers when in command mode or switching to another
" buffer, and show absolute line numbers when in insert mode. However, only set
" relative number if number is also set. This avoids setting relative number
" when no number is set, e.g. in vim docs.
function! s:SetRelativeNumber()
  if &number
    set relativenumber
  endif
endfunction

function! s:UnsetRelativeNumber()
  if &number
    set norelativenumber
  endif
endfunction

augroup NumberToggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * call s:SetRelativeNumber()
  autocmd BufLeave,FocusLost,InsertEnter   * call s:UnsetRelativeNumber()
augroup end

augroup FileTypeSettings
  autocmd!
  " .md file extensions should be treated as markdown rather than modula.
  autocmd BufNewFile,BufFilePre,BufRead *.md setlocal filetype=markdown

  " Dockerfile.builder is the conventional file name for builder docker files so
  " set file extensions to dockerfile.
  autocmd BufNewFile,BufFilePre,BufRead Dockerfile.builder set filetype=dockerfile

  " Python should have a max line length of 79, otherwise the linter complains.
  autocmd FileType python setlocal textwidth=79

  " Overwriting `tw` in ftplugins/rust.vim doesn't work because I presume the
  " rust.vim plugin subsequently overwrites it, so in turn overwrite it here.
  autocmd FileType rust setlocal textwidth=80

  " file types for which we want 2 space wide tabs
  autocmd FileType json,proto,vim,vue,yaml,helm,lua setlocal tabstop=2 shiftwidth=2
augroup end

augroup ResumeSettings
  autocmd!
  " Jump to last edit position on opening file
  " https://github.com/jonhoo/configs/blob/master/editor/.config/nvim/init.vim#L439
  " https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
  autocmd BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup end

" ==============================================================================
" General plugin settings
" ==============================================================================

" Don't conceal quotes in JSON files: it makes editing them annoying and doesn't
" really make it all that more readable.
let g:vim_json_syntax_conceal = 0

let g:indentLine_color_term = 246
let g:indentLine_color_gui = '#4f5b66'

let g:goyo_width = 80
let g:goyo_height = 100
let g:goyo_linenr = 1

let g:limelight_conceal_ctermfg = 'DarkGray'

let g:session_autosave = 'no'

" ==============================================================================
" Vimwiki
" ==============================================================================

" List of wikis. Note that these are backed up via different means, so make sure
" to initialize them before use as otherwise vimwiki will create a new wiki.
let g:vimwiki_list = [
      \ {
          \ 'path': '~/exobrain',
          \ 'syntax': 'markdown',
          \ 'ext': 'md',
          \ 'auto_toc': 1,
          \ 'links_space_char': '-',
      \ },
      \ {
          \ 'path': '~/diary',
          \ 'syntax': 'markdown',
          \ 'ext': 'md',
          \ 'auto_toc': 1,
          \ 'links_space_char': '-',
      \ },
      \ {
          \ 'path': '~/algotrading',
          \ 'syntax': 'markdown',
          \ 'ext': 'md',
          \ 'auto_toc': 1,
          \ 'links_space_char': '-',
      \ },
      \]

" Automatically change to the wiki directory. This is used so that own fuzzy
" searcher over files can be used instead of the more limited builtin searcher.
let g:vimwiki_auto_chdir = 1

" Automatically generate the page title based on the original link name.
let g:vimwiki_auto_header = 1

" Don't treat non-wiki markdown files as part of vimwiki.
let g:vimwiki_global_ext = 0

" Append `.md` extension to links.
let g:vimwiki_markdown_link_ext = 1

" ==============================================================================
" COC.nvim
" ==============================================================================

set updatetime=200

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Coc plugins
let g:coc_global_extensions = [
      \ 'coc-json', 
      \ 'coc-lists', 
      \ 'coc-sh', 
      \ 'coc-rust-analyzer', 
      \ 'coc-yaml', 
      \ 'coc-sql', 
      \ 'coc-prettier', 
      \ ]

" ----------------------------------------------------------------------------
" Completion
" ----------------------------------------------------------------------------
" Use tab to trigger completion with characters ahead and for completion
" navigation.
"
" NOTE: Use command ':verbose imap <tab>' and `:verbose imap <cr>` to make sure
" tab and cr are not mapped by other plugins before enabling this mapping.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_backspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_backspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" ----------------------------------------------------------------------------
" CodeAction
" ----------------------------------------------------------------------------
" Applying codeAction to the selected region.
" Example: `<leader>cap` for current paragraph
"xmap <leader>c <Plug>(coc-codeaction-selected)
"nmap <leader>c <Plug>(coc-codeaction-selected)
" Apply codeAction to the current line.
nmap <leader>qc  <Plug>(coc-codeaction-cursor)
nmap <leader>ql  <Plug>(coc-codeaction-line)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

nmap <silent> <leader>n <Plug>(coc-rename)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

augroup MyCocGroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
      \ tabstop=2 shiftwidth=2
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  " Autoformat file on save.
  autocmd BufWritePost *.rs Format
  " TODO: this causes issues with autoformat on save
  "" Disable coc for mardkdown buffers, as it slows vim down unbearably.
  "autocmd BufNew,BufEnter *.md let b:coc_enabled = 0
augroup end

" Remap <C-f> and <C-b> for scroll float windows/popups.
" Note coc#float#scroll works on neovim >= 0.4.0 or vim >= 8.2.0750
" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add (Neo)Vim's native statusline support.
set statusline+=%{coc#status()}%{get(b:,'coc_current_function','')}

nnoremap <F10> :CocCommand explorer<CR>

" ----------------------------------------------------------------------------
" Search & lists: coc-lists (vim) or Telescope (nvim)
" 
" The coc-lists fuzzy ranker is very often frustrating and therefore when neovim
" is used, Telescope is used for search instead of Coc.
" ----------------------------------------------------------------------------

" TODO: add shortcut to live_grep for current word under cursor with <leader>*

" Show extensions.
" TODO: Telescope?
nnoremap <silent> <leader>e :<C-u>CocList extensions<CR>

function! s:use_telescope()
  return has('nvim') && b:use_telescope
endfunction

function! s:register_list(key, tel_cmd, coc_cmd)
  if s:use_telescope()
    " like: nnoremap <leader>a:key <cmd>Telescope a:tel_cmd<CR>
    exe 'nnoremap <leader>' . a:key . ' <cmd>Telescope ' . a:tel_cmd . ' theme=get_dropdown<CR>'
  else
    " like: nnoremap <silent> <leader>a:key :<C-u>CocList a:coc_cmd<CR>
    exe 'nnoremap <silent> <leader>' . a:key . ' :<C-U>CocList ' . a:coc_cmd . '<CR>'
  endif
endfunction

" Resume previous search.
if s:use_telescope()
  call s:register_list('p', 'resume', '')
else
  nnoremap <silent> <leader>p :<C-u>CocListResume<CR>
endif

" Show extensions.
" TODO: Telescope?
nnoremap <silent> <leader>e :<C-u>CocList extensions<CR>

" Search files in $(pwd) in most recently used order.
" Not sure what the difference is between oldfiles and find_files, but the
" latter doesn't seem to provide any MRU ordering capabilities. However,
" oldfiles once crashed a large project so it could be that it is not async,
" so find_files is used until a better MRU capability exists.
call s:register_list('f', 'find_files', 'files')
" Search files in MRU order.
call s:register_list('m', 'oldfiles', 'mru')
" Search words in $(pwd).
call s:register_list('g', 'live_grep', 'grep')
" Search among currently opened buffers.
call s:register_list('b', 'buffers sort_mru=true', 'buffers')
" Show all diagnostics.
" workspace_diagnostics shows diagnostics for the entire project.
call s:register_list('a', 'coc workspace_diagnostics', 'diagnostics')
" Search for lines in current buffer.
call s:register_list('/', 'current_buffer_fuzzy_find', 'lines')
" Search command history.
call s:register_list('hc', 'command_history', 'cmdhistory')
" Search search history.
call s:register_list('h/', 'search_history', 'searchhistory')

" ----------------------------------------------------------------------------
" Navigation
" ----------------------------------------------------------------------------
" Navigate diagnostics.
nmap <silent> <C-p> <Plug>(coc-diagnostic-prev)
nmap <silent> <C-n> <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> <leader>d <Plug>(coc-definition)
nmap <silent> <leader>y <Plug>(coc-type-definition)

" Implementation and references are both lists, so let's take advantage of
" Telescope here.
" TODO: maybe also include definitions, in very rare cases that results in a list too

" TODO: find a suitable mapping, <leader>i clashes with GoToRecentBuffer('next')
"if has('nvim')
  "nnoremap <leader>i <cmd>Telescope coc implementations theme=get_dropdown<CR>
  "s:register_list('i', 'coc implementations', '')
"else
  "nmap <silent> <leader>i <Plug>(coc-implementation)
"endif

if s:use_telescope()
  call s:register_list('r', 'coc references', '')
else
  nmap <silent> <leader>r <Plug>(coc-references)
endif

" ==============================================================================
" Better Quickfix
" ==============================================================================
" NOTE: experimental

" :h CocLocationsChange for detail
let g:coc_enable_locationlist = 0
aug Coc
    au!
    au User CocLocationsChange ++nested call Coc_qf_jump2loc(g:coc_jump_locations)
aug END

nnoremap <silent> <leader>qd <Cmd>call Coc_qf_diagnostic()<CR>

function! Coc_qf_diagnostic() abort
    let diagnostic_list = CocAction('diagnosticList')
    let items = []
    let loc_ranges = []
    for d in diagnostic_list
        let text = printf('[%s%s] %s', (empty(d.source) ? 'coc.nvim' : d.source),
                    \ (d.code ? ' ' . d.code : ''), split(d.message, '\n')[0])
        let item = {'filename': d.file, 'lnum': d.lnum, 'col': d.col, 'text': text, 'type':
                    \ d.severity[0]}
        call add(loc_ranges, d.location.range)
        call add(items, item)
    endfor
    call setqflist([], ' ', {'title': 'CocDiagnosticList', 'items': items,
                \ 'context': {'bqf': {'lsp_ranges_hl': loc_ranges}}})
    botright copen
endfunction

function! Coc_qf_jump2loc(locs) abort
    let loc_ranges = map(deepcopy(a:locs), 'v:val.range')
    call setloclist(0, [], ' ', {'title': 'CocLocationList', 'items': a:locs,
                \ 'context': {'bqf': {'lsp_ranges_hl': loc_ranges}}})
    let winid = getloclist(0, {'winid': 0}).winid
    if winid == 0
        aboveleft lwindow
    else
        call win_gotoid(winid)
    endif
endfunction
