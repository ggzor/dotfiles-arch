" vim:fdm=marker

" General

" Editor options {{{

set nocompatible

" Replace tabs with spaces
set expandtab
" Set tab size for all options
set shiftwidth=2
set shiftwidth=2
set softtabstop=2

" Tab size overrides
augroup au_tab_size_override
  autocmd!
  " Use 4 spaces with Python
  autocmd FileType python setlocal shiftwidth=4 softtabstop=4 tabstop=4

  " Use tabs with Go
  autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=-1
augroup END

" Indent preserving indentation level
set autoindent
set smartindent

" Read file changes outside of vim automatically
set autoread
au FocusGained,BufEnter * if !len(getcmdwintype()) | :checktime | endif

" Show parenthesis match
set showmatch

" Better search behavior
set ignorecase
set smartcase

" File write behavior
set updatetime=100
set backupcopy=yes

set nobackup
set noswapfile

" File undo history
set undofile
set undolevels=250

if has('nvim')
  set undodir=~/.nvim/undo
else
  set undodir=~/.vim/undo
endif

" Changing to another file doesn't requires save
set hidden

" Change terminal title to file name
set title
augroup au_terminal_title
  au!
  autocmd BufEnter * let &titlestring = expand('%') . ' - vim'
augroup end

" }}}

" Visual options {{{

" Enable termguicolors if possible
if has('termguicolors')
  set termguicolors
endif

" Self explanatory
set cursorline
set noshowmode
set number nornu
set laststatus=2
set signcolumn=yes

set hlsearch
set incsearch

if has('nvim')
  " Preview replacements
  set inccommand=nosplit
endif

" Prefer splitting below and to the right
set splitbelow
set splitright

" Hide not useful messages
set shortmess+=cI

" Add a color column at the 89th char
call matchadd('ColorColumn', '\%89v', 100)
" Remove color column for the following filetypes
let s:exclude_cursor_column=['', 'man']
augroup au_color_col
  au!
  autocmd BufEnter,WinEnter,FileType * exec 'hi ColorColumn guifg=NONE guibg='
    \ .. (index(s:exclude_cursor_column, &ft) >= 0 ? 'NONE' : '#78808b')
augroup end

" Diff options
set diffopt=vertical,filler,foldcolumn:1

" Change cursor with mode
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" Change characters
" Vertical split char
set fillchars+=fold:.,vert:│

" }}}

" Plugins

" Pre-load {{{

" Agda
let g:agda_extraincpaths = ['/usr/share/agda/lib/stdlib']

" ale
let g:ale_completion_enabled = 0

" gitgutter
let g:gitgutter_map_keys = 0
" Use better change chars
let g:gitgutter_sign_added              = '▍'
let g:gitgutter_sign_modified           = '▍'
let g:gitgutter_sign_removed            = '▍'
let g:gitgutter_sign_modified_removed   = '▍'

" vim-polyglot
" treesitter handles all of these languages
let g:polyglot_disabled = [
  \ 'c',
  \ 'cs',
  \ 'clojure',
  \ 'cpp',
  \ 'css',
  \ 'fennel',
  \ 'go',
  \ 'graphql',
  \ 'html',
  \ 'java',
  \ 'javascript',
  \ 'jsx',
  \ 'javascriptreact',
  \ 'json',
  \ 'julia',
  \ 'kotlin',
  \ 'tex',
  \ 'lua',
  \ 'nix',
  \ 'python',
  \ 'rst',
  \ 'ruby',
  \ 'rust',
  \ 'sh',
  \ 'svelte',
  \ 'toml',
  \ 'typescript',
  \ 'tsx',
  \ 'idris']

"
augroup au_polyglot_md_disable_indentexpr
  autocmd!
  autocmd BufEnter *.md set indentexpr=
augroup END

augroup au_filetypes_rename
  autocmd!

  " Enable racket for rkt files
  autocmd BufNewFile,BufRead *.rkt setfiletype racket
  autocmd BufNewFile,BufRead *.json setfiletype jsonc
augroup END

" vim-plug download
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs'
    \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

  autocmd VimEnter * silent! PlugInstall --sync | silent! source $MYVIMRC
endif

" }}}

" Plugins list {{{

call plug#begin()

" Utilities
Plug 'airblade/vim-gitgutter'
Plug 'romainl/vim-qf'
Plug 'simnalamburt/vim-mundo'
Plug 'tpope/vim-fugitive'
Plug 'wsdjeg/vim-fetch'
Plug 'xolox/vim-misc'

" Extra text objects
Plug 'kana/vim-textobj-user'

Plug 'Julian/vim-textobj-variable-segment'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-syntax'
Plug 'saihoooooooo/vim-textobj-space'
Plug 'wellle/targets.vim'

" Extra operators
Plug 'andymass/vim-matchup'
Plug 'bronson/vim-visual-star-search'
Plug 'godlygeek/tabular'
Plug 'machakann/vim-sandwich'
Plug 'mattn/emmet-vim'
Plug 'svermeulen/vim-subversive'
Plug 'tmsvg/pear-tree'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'

" Extra old syntax
Plug 'dylon/vim-antlr'
Plug 'sheerun/vim-polyglot'
Plug 'luochen1990/rainbow'

" Easymotion like behavior
if has('nvim')
  Plug 'ggzor/hop.nvim'
else
  Plug 'easymotion/vim-easymotion'
endif

" fzf
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" LSP
if has('nvim')
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif

" treesitter
if has('nvim')
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/playground'
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
  Plug 'p00f/nvim-ts-rainbow'
endif

" NERDTree Like
if has('nvim')
  Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': ':UpdateRemotePlugins'}
else
  Plug 'preservim/nerdtree'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
endif

" Custom language plugins
Plug 'dense-analysis/ale'
Plug 'derekelkins/agda-vim'
Plug 'edwinb/idris2-vim'
Plug 'eraserhd/parinfer-rust', {'do': 'cargo build --release'}
Plug 'honza/vim-snippets'
Plug 'lervag/vimtex'
Plug 'Olical/conjure', {'tag': 'v4.3.1'}

" Visual plugins
Plug 'christoomey/vim-tmux-navigator'
Plug 'ggzor/night-owl2.vim'
Plug 'ggzor/ShowMotion'
Plug 'itchyny/lightline.vim'
Plug 'lpinilla/vim-codepainter'
Plug 'machakann/vim-highlightedyank'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'ryanoasis/vim-devicons'
Plug 'Yggdroot/indentLine'

call plug#end()

" }}}

" Post-load {{{

" ale
" Only enable for certain file types
let g:ale_enabled=0
let g:ale_fixers = {
  \  '*': ['trim_whitespace'],
  \}
let g:ale_fix_on_save = 1
" LSP capabilities are provided by Coc.vim
let g:ale_disable_lsp = 1

" vim-sandwich
runtime macros/sandwich/keymap/surround.vim

" nvim-treesitter
if has('nvim')
lua <<EOF
  require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained",
    highlight = {
      enable = true,
    },
    ident = {
      enable = true,
    },
    matchup = {
      enable = false,
    },
    rainbow = {
      enable = true,
      extend_mode = true,
    },
    playground = {
      enable = true,
      updatetime = 25,
      persist_queries = false,
    },
    textobjects = {
      select = {
        enable = true,
      },
    },
  }

  require'nvim-treesitter.highlight'
  local hlmap = vim.treesitter.highlighter.hl_map

  hlmap.error = nil
  hlmap["punctuation.delimiter"] = "Delimiter"
  hlmap["punctuation.bracket"] = nil
EOF
endif

" highlightedyank
let g:highlightedyank_highlight_duration = -1

" rainbow
let g:rainbow_active = 0
let g:rainbow_conf = {
  \ 'separately': {
  \   'racket': {
  \     'after': ['syn clear racketQuoted']
  \   },
  \   'agda': {
  \     'parentheses': [
  \       'start=/(/ end=/)/ fold',
  \       'start=/\[/ end=/\]/ fold',
  \       'start=/\v\{\ze[^-]/ end=/}/ fold'
  \     ],
  \   },
  \ }
  \ }

augroup au_rainbow_enable
  autocmd!
  autocmd FileType racket,agda,haskell RainbowToggleOn
augroup END

augroup au_rainbow_enter_fix
  autocmd!
  autocmd WinEnter *.agda RainbowToggleOn
augroup END

" vimtex
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_enabled = 0

" matchup
" Increase responsiveness deferring highlighting
let g:matchup_matchparen_deferred = 1
let g:matchup_matchparen_deferred_show_delay = 50
" Show surrounding parens
let g:matchup_matchparen_hi_surround_always = 1
" Don't match offscreen parens
let g:matchup_matchparen_offscreen = {}

" easymotion
let g:EasyMotion_off_screen_search = 0
" Don't map default mappings
let g:EasyMotion_do_mapping = 0
" Allow mapping differently start of line mappings and same column
let g:EasyMotion_startofline = 0
" Press space to select first
let g:EasyMotion_space_jump_first=1
" The fastest keys I press
let g:EasyMotion_keys = 'fasjuirwzmkhdoe'

" hop.nvim
if has('nvim')
lua << EOF
  require'hop'.setup {
      keys = 'fasjuirwzmkhdoe',
      teasing = false
    }
EOF
endif

" emmet-vim
let g:user_emmet_install_global = 0
" Load emmet only in certain file types
autocmd FileType html,css,javascript,typescript,javascriptreact,typescriptreact,xml EmmetInstall

" pear-tree
let g:pear_tree_smart_openers = 1
let g:pear_tree_smart_closers = 1
let g:pear_tree_smart_backspace = 1
let g:pear_tree_repeatable_expand = 0


" Code painter
let g:paint_color_idx = 0
let g:paint_colors = ['blue', 'yellow', 'green', 'red', 'gray']
function! CodePainterAdjustColor(amount) abort
  let g:paint_color_idx = (
    \ (g:paint_color_idx + a:amount + len(g:paint_colors)) % len(g:paint_colors))

  call codepainter#ChangeColorByName('paint'.g:paint_colors[g:paint_color_idx])
  if a:amount != 0
    echo "Using color: " . g:paint_colors[g:paint_color_idx]
  endif
endfunction
call CodePainterAdjustColor(0)

if has('nvim')
  set cmdheight=2

  autocmd CursorHold * silent call CocActionAsync('highlight')

  augroup au_coc_groups
    autocmd!
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end

  let g:coc_global_extensions = [
        \'coc-clangd',
        \'coc-css',
        \'coc-emmet',
        \'coc-emoji',
        \'coc-eslint',
        \'coc-go',
        \'coc-java',
        \'coc-json',
        \'coc-prettier',
        \'coc-pyright',
        \'coc-rust-analyzer',
        \'coc-sh',
        \'coc-snippets',
        \'coc-styled-components',
        \'coc-tsserver',
        \'coc-vimtex',
        \]
endif

" web-devicons
if exists("g:loaded_webdevicons")
  call webdevicons#refresh()
endif

" NERDTree like
if has('nvim')
  " CHADTree
  let g:chadtree_settings = {
    \   'theme': {
    \     'text_colour_set': 'env'
    \   },
    \   'view': {
    \     'open_direction': 'right',
    \   },
    \   'keymap': {
    \     'jump_to_current': ['<C-o>'],
    \     'stat': ['<C-g>'],
    \   },
    \ }

  " Auto close if CHADTree is the only window open
  autocmd BufEnter * if (winnr("$") == 1 && &ft == 'chadtree') | q | endif
else
  " nerdtree
  let g:NERDTreeWinPos = "right"
  let g:NERDTreeMinimalUI = 1

  " Auto close if NERDTree is the only window open
  autocmd BufEnter * if (winnr("$") == 1 && &ft == 'nerdtree') | q | endif
endif

" indentLine
let g:indentLine_enabled = 0
let g:indentLine_char = '|'
autocmd FileType python,go IndentLinesEnable

" lightline
let g:lightline = {
      \   'active': {
      \     'left':[ [ 'mode', 'paste' ],
      \              [ 'gitbranch', 'readonly', 'filename' ]
      \     ],
      \     'right': [ [ 'lineinfo' ], [ 'filetype' ] ]
      \   },
      \   'inactive': {
      \     'left':[ [ 'filename' ]],
      \     'right': [ [ 'lineinfo' ] ]
      \   },
      \   'tab': {
      \     'active':[ 'filename' ],
      \     'inactive': [ 'filename' ]
      \   },
      \   'tabline': {
      \     'left':[ [ 'tabs' ]],
      \     'right': []
      \   },
      \   'component': {
      \     'lineinfo': ' %3l:%-2v',
      \   },
      \   'component_function': {
      \     'gitbranch': 'LightlineFugitive',
      \     'readonly': 'LightlineReadonly',
      \     'filename': 'GetFileNameIcon',
      \     'filetype': 'GetFileTypeIcon',
      \   },
      \   'tab_component_function': {
      \     'filename': 'GetTabFileNameIcon',
      \   },
      \   'mode_map': {
      \     'n': 'NORM',
      \     'i': 'INS',
      \     'R': 'REP',
      \     'v': 'VIS',
      \     'V': 'V-LINE',
      \     "\<C-v>": 'V-BLOCK',
      \     'c': 'COMM',
      \     's': 'SEL',
      \     'S': 'S-LINE',
      \     "\<C-s>": 'S-BLOCK',
      \     't': 'TERM',
      \   }
      \ }

" Auxiliar lightline functions {{{

function! LightlineFugitive()
  if exists('*fugitive#head')
    let branch = fugitive#head()
    return branch !=# '' ? ' '.branch : ''
  endif
  return ''
endfunction

function! LightlineReadonly()
  return &readonly ? '' : ''
endfunction

function! GetFileNameIcon()
  if winwidth(0) > 70
    if strlen(@%)
      return WebDevIconsGetFileTypeSymbol() . ' ' . @% . (&modified ? ' ●' : '')
    else
      return '[No Name]'
    endif
  else
    return ''
  endif
endfunction

function! GetFileTypeIcon()
  return winwidth(0) > 70
    \ ? (strlen(&filetype) ? &filetype.' '.WebDevIconsGetFileTypeSymbol() : 'no ft')
    \ : ''
endfunction

function! GetTabFileNameIcon(index)
  let bufnrlist = tabpagebuflist(a:index)

  let bufname = fnamemodify(bufname(bufnrlist[tabpagewinnr(a:index) - 1]), ':t')
  let icon = WebDevIconsGetFileTypeSymbol(bufname, 0)

  let modlabel = ''
  for bufnr in bufnrlist
    if getbufvar(bufnr, "&modified")
      let modlabel = '●'
      break
    endif
  endfor

  return printf(' %s %s %s', icon, len(bufname) ? bufname : '[No Name]', modlabel)
endfunction

" }}}

" vim-fugitive
" Set fugitive size
augroup fugitive_window_size
  au!
  au FileType fugitive 16wincmd_
augroup END

" vim-mundo
let g:mundo_right=1

" vim-qf
let g:qf_mapping_ack_style = 1

" fzf
let $FZF_DEFAULT_COMMAND = "fd --type f --hidden --exclude .git --follow"
let g:fzf_preview_window_min_width=100
let g:fzf_history_dir = '~/.fzf-vim-history'

" Get preview options depending on current window size
"   target_prev_width = The size of the preview window
"   switch_layout_width = The neovim windows size at which full screen mode is
"                         forced
function! FZFPreviewOptions(options, target_prev_width, switch_layout_width)
  let ww = &columns
  let wh = &lines
  let go_full = ww <= a:switch_layout_width

  let max_width = float2nr(3.0 * ww / 5.0)
  let preview_width = min([a:target_prev_width, max_width])
  let right_preview_string = 'right:'.preview_width.':noborder:nowrap'

  let preview_params = go_full ? 'up:71%:border:nowrap' : right_preview_string

  let options = fzf#vim#with_preview(a:options, preview_params)

  if !go_full
    let target_width = min([160, float2nr(0.9 * ww)])
    let target_height = min([60, float2nr(0.8 * wh)])
    call extend(options, { 'window': { 'width': target_width, 'height': target_height } })
  endif

  return [options, go_full]
endfunction

" Open a file in the current directory
function! FZFFiles()
  let [options, go_full] = FZFPreviewOptions({}, 95, 110)
  call fzf#vim#files('', options, go_full)
endfunction

" Search for a regex pattern
function! RipgrepFzf(query, fullscreen)
  let command_fmt =
    \ 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')

  let options = [
    \ '--disabled',
    \ '--query', a:query,
    \ '--bind', 'change:reload:'.reload_command
    \ ]

  let [options, go_full] = FZFPreviewOptions({ 'options': options }, 100, 180)
  call fzf#vim#grep(initial_command, 1, options, go_full)
endfunction

function! RipgrepFzfFuzzy(query, fullscreen, preview)
  let command = 'rg --column --line-number --no-heading --color=always --smart-case ""'
  let shared_options = ['--delimiter', ':', '--nth', '3..', '--preview-window']

  if a:fullscreen && winwidth(0) < g:fzf_preview_window_min_width
    let options = shared_options + ['up:80%:noborder']
  else
    let options = shared_options + ['right:95:noborder']
  endif

  let spec = {'options': options }
  call fzf#vim#grep(command, 1, a:preview ? fzf#vim#with_preview(spec) : {}, a:fullscreen)
endfunction

" Hide status line
if has('nvim') && !exists('g:fzf_layout')
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noruler nonumber nornu
    \| autocmd BufLeave <buffer> set laststatus=2 ruler
endif

" }}}

" Custom configuration

" Custom functions {{{

function! ShowSyntaxGroupUnderCursor()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

" Filter only visually selected region
" See: https://stackoverflow.com/questions/9637921/vim-filter-only-visual-selection-not-the-entire-line
function! ProgramFilter(vt, ...)
    let [qr, qt] = [getreg('"'), getregtype('"')]
    let [oai, ocin, osi, oinde] = [&ai, &cin, &si, &inde]
    setl noai nocin nosi inde=

    let [sm, em] = ['[<'[a:0], ']>'[a:0]]
    exe 'norm!`' . sm . a:vt . '`' . em . 'x'

    call inputsave()
    let cmd = input('!')
    call inputrestore()

    let g:out = system(cmd, @")
    let g:out = substitute(g:out, '\n$', '', '')
    exe "norm!i\<c-r>=g:out\r"

    let [&ai, &cin, &si, &inde] = [oai, ocin, osi, oinde]
    call setreg('"', qr, qt)
endfunction

function! OpenDirUnderCursor()
  let directory = expand('<cfile>')
  let path = glob(directory)

  if empty(path)
    echohl ErrorMsg
    echom 'Directory "' . directory . "\" doesn't exists"
    echohl None
    return
  endif

  if !isdirectory(path)
    echohl ErrorMsg
    echom 'The given path is not a directory: ' . directory
    echohl None
    return
  endif

  call system('kitty --directory ' . shellescape(path) . ' zsh -i &')
endfunction

" }}}

" Hacks {{{

" Diff mode hacks {{{

if has('nvim')

  " To be called with a keybinding
  function ToggleGitDiffMode()
    if &diff
      " Go to first window and quit
      exec "normal! 1\<C-w>w"
      exec "quit"
    else
      " Split and go to last window
      exec ":Gvdiffsplit | normal! \<C-w>l"
    endif
  endfunction

  " Unfortunately, the option &diff is set some time after entering diff mode,
  " so an asynchronous re-configuration must be made
  augroup aug_diffs
    au!
    " Inspect whether some windows are in diff mode, and apply changes for such windows
    au WinEnter,BufEnter * call timer_start(50, 'FixDiffParameters')
    " Update diff colors for window position
    " This way the left window has reddish colors and the right one greenish
    au WinEnter,BufEnter * call s:UpdateDiffColors()

    " Highlight VCS conflict markers
    au VimEnter,WinEnter * if !exists('w:_vsc_conflict_marker_match') |
          \   let w:_vsc_conflict_marker_match = matchadd('ErrorMsg', '^\(<\|=\||\|>\)\{7\}\([^=].\+\)\?$') |
          \ endif
  augroup END

  function! FixDiffParameters(timer) abort
    let curwin = winnr()

    " Check each window
    for _win in range(1, winnr('$'))
      " Go to window without triggering autocmd's
      silent! exe "noautocmd " . _win . "wincmd w"

      " Cursor line must be disabled in diff mode
      silent! call s:change_option_in_diffmode("w:", "cursorline", 0, 1)
    endfor

    " Get back to original window
    silent! exe "noautocmd " . curwin . "wincmd w"
  endfunction

  " Set option depending on diff state
  " Detect window or buffer local option is in sync with diff mode
  function s:change_option_in_diffmode(scope, option, value, ...)
    let isBoolean = get(a:, "1", 0)
    let backupVarname = a:scope . "_old_" . a:option

    " Entering diff mode
    if &diff && !exists(backupVarname)
      exe "let " . backupVarname . "=&" . a:option
      call s:set_option(a:option, a:value, 1, isBoolean)
    endif

    " Exiting diff mode
    if !&diff && exists(backupVarname)
      let oldValue = eval(backupVarname)
      call s:set_option(a:option, oldValue, 1, isBoolean)
      exe "unlet " . backupVarname
    endif
  endfunction

  " Set option using set or setlocal, be it string or boolean value
  function s:set_option(option, value, ...)
    let isLocal = get(a:, "1", 0)
    let isBoolean = get(a:, "2", 0)
    if isBoolean
      exe (isLocal ? "setlocal " : "set ") . (a:value ? "" : "no") . a:option
    else
      exe (isLocal ? "setlocal " : "set ") . a:option . "=" . a:value
    endif
  endfunction

  " Update diff color depending on window index
  function! s:UpdateDiffColors() abort
    let curwin = winnr()

    for _win in range(1, winnr('$'))
      silent! exe "noautocmd " . _win . "wincmd w"

      if _win == 1
        setlocal winhighlight=DiffAdd:DiffOldAdd,
              \DiffChange:DiffOldChange,
              \DiffText:DiffOldText
      elseif _win == 2
        setlocal winhighlight=""
      endif
    endfor

    " Get back to original window
    silent! exe "noautocmd " . curwin . "wincmd w"
  endfunction

endif

" }}}

" Deletes an item from quickfix list
function! RemoveQFItem()
  function! GetCurrentQFId()
    return getqflist({ 'id': 0 }).id
  endfunction

  function! InsertUndoDictQF(item)
    if !exists('g:qf_undo_history')
      let g:qf_undo_history = {}
    endif

    if !exists('g:qf_undo_history.' . GetCurrentQFId())
      let g:qf_undo_history[GetCurrentQFId()] = []
    endif

    call insert(g:qf_undo_history[GetCurrentQFId()], a:item)
  endfunction

  let curqfidx = line('.') - 1
  let qfall = getqflist()
  call InsertUndoDictQF([curqfidx, get(qfall, curqfidx)])

  call remove(qfall, curqfidx)
  call setqflist(qfall, 'r')
  execute curqfidx + 1 . "cfirst"
  :copen
endfunction

" Restores a previously deleted item from quickfix list
function! RestoreQFItem()
  if exists('g:qf_undo_history') && !empty(g:qf_undo_history[GetCurrentQFId()])
    let [idx, last] = remove(g:qf_undo_history[GetCurrentQFId()], -1)
    let qfall = getqflist()
    call insert(qfall, last, idx)
    call setqflist(qfall, 'r')
    execute idx + 1 . "cfirst"
    :copen
  else
    echohl WarningMsg
    echom "No items to restore"
    echohl None
  endif
endfunction

" }}}

" Keymappings and text objects

" General mappings {{{
let g:mapleader = ' '

" Make Y similar to C and D
noremap Y y$

" Navigate to alternate file
nnoremap <silent> ña <C-^>

" No highlight
nnoremap <silent> ñn :<C-u>nohlsearch<CR>

" }}}

" Custom mappings {{{

if has('nvim')
  nmap <silent> <leader>gh :call ToggleGitDiffMode()<CR>
endif

" Visual selection filter
nnoremap <silent> <leader>1 :set opfunc=ProgramFilter<cr>g@
vnoremap <silent> <leader>1 :call ProgramFilter(visualmode(), 1)<cr>

" Delete and restore from quickfix
autocmd FileType qf nmap <silent> <buffer> dd :call RemoveQFItem()<cr>
autocmd FileType qf nmap <silent> <buffer> u :call RestoreQFItem()<cr>

" Go to directory under cursor
nmap <silent> <leader>d :<C-u>call OpenDirUnderCursor()<CR>

" }}}

" Plugin mappings {{{

" fzf
nnoremap <silent> ñf :call FZFFiles()<CR>
nnoremap <silent> ñj :Buffers<CR>
nnoremap <silent> ñl :BLines<CR>
nnoremap <silent> ññ :History:<CR>
nnoremap <silent> ñh :Helptags<CR>
" nnoremap <silent> ñr :call RipgrepFzfFuzzy('', 0, 1)<CR>
" nnoremap <silent> ñR :call RipgrepFzfFuzzy('', 1, 1)<CR>
nnoremap <silent> ñg :call RipgrepFzf('', 0)<CR>
nnoremap <silent> ñG :call RipgrepFzf('', 1)<CR>

" coc.nvim
if has('nvim')
  " Select completion option
  inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  " Complete with <c-space>
  inoremap <silent><expr> <c-space> coc#refresh()

  " Replicate vscode code action behavior
  " Unfortunately, Ctrl-. cannot be mapped, so a custom char sequence is
  " used, and then this sequence is mapped with the terminal emulator
  nmap <silent> ñp v<Plug>(coc-codeaction-selected)<Esc>
  vmap <silent> ñp <Plug>(coc-codeaction-selected)

  " Navigate through diagnostics
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  " GoTo code navigation.
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Use K to show documentation in preview window.
  nnoremap <silent> ñk :call CocAction('doHover')<CR>

  " Symbol renaming
  nmap <leader>r <Plug>(coc-rename)
  " Remap keys for applying codeAction to the current line.
  nmap <leader>a <Plug>(coc-codeaction)
  " Apply AutoFix to problem on the current line.
  nmap <leader>q  <Plug>(coc-fix-current)

  " Refresh Coc
  inoremap <silent><expr> <C-space> coc#refresh()

  " Use <TAB> for selections ranges.
  " NOTE: Requires 'textDocument/selectionRange' support from the language server.
  " coc-tsserver, coc-python are the examples of servers that support it.
  nmap <silent><leader><TAB> <Plug>(coc-range-select)
  xmap <silent><leader><TAB> <Plug>(coc-range-select)

  " Scroll float documentation
  nnoremap <silent><nowait><expr> <A-j> coc#float#has_scroll()
        \ ? coc#float#scroll(1) : ""
  nnoremap <silent><nowait><expr> <A-k> coc#float#has_scroll()
        \ ? coc#float#scroll(0) : ""

  inoremap <silent><nowait><expr> <A-j> coc#float#has_scroll()
        \ ? "\<c-r>=coc#float#scroll(1)\<cr>" : ""
  inoremap <silent><nowait><expr> <A-k> coc#float#has_scroll()
        \ ? "\<c-r>=coc#float#scroll(0)\<cr>" : ""

  vnoremap <silent><nowait><expr> <A-j> coc#float#has_scroll()
        \ ? coc#float#scroll(1) : ""
  vnoremap <silent><nowait><expr> <A-k> coc#float#has_scroll()
        \ ? coc#float#scroll(0) : ""
endif

" emmet
let g:user_emmet_leader_key='<C-y>'

" vim-subversive
nmap s <plug>(SubversiveSubstitute)

" gitgutter
nmap <silent> ]c <Plug>(GitGutterNextHunk)
nmap <silent> [c <Plug>(GitGutterPrevHunk)
nmap <silent> <leader>gr <Plug>(GitGutterUndoHunk)
nmap <silent> <leader>gs :GitGutterStageHunk <bar> GitGutterNextHunk <bar> normal! zz<CR>

omap ih <Plug>(GitGutterTextObjectInnerPending)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)

" vim-mundo
nmap <leader>u :<C-u>MundoToggle<CR>

" vim-qf
nmap <leader>{ <Plug>(qf_qf_previous)
nmap <leader>} <Plug>(qf_qf_next)
nmap <buffer> <Left>  <Plug>(qf_older)
nmap <buffer> <Right> <Plug>(qf_newer)
nmap <leader>q <Plug>(qf_qf_toggle_stay)

" tree-sitter mappings
if has('nvim')
lua <<EOF
  require'nvim-treesitter.configs'.setup {
    playground = {
      keybindings = {
        toggle_query_editor = 'o',
        toggle_hl_groups = 'i',
        toggle_injected_languages = 't',
        toggle_anonymous_nodes = 'a',
        toggle_language_display = 'I',
        focus_language = 'f',
        unfocus_language = 'F',
        update = 'R',
        goto_node = '<cr>',
        show_help = '?',
      }
    },
    textobjects = {
      select = {
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
    },
  }
EOF
endif

" NERDTree like
if has('nvim')
  nmap <C-n> :CHADopen<CR>
else
  nmap <C-n> :NERDTreeToggle<CR>
endif

" Code Painter
vnoremap <silent> gp :<c-u> call codepainter#paintText(visualmode())<cr>
nnoremap <silent> gp <nop>
nnoremap <silent> gP :<c-u> PainterEraseLine<cr>

nnoremap <silent> g- :<c-u> call CodePainterAdjustColor(1)<cr>
nnoremap <silent> g+ :<c-u> call CodePainterAdjustColor(-1)<cr>

" Agda
nnoremap <localleader>0 :<c-u>AgdaLoad<cr>

" ShowMotion
nmap f <Plug>(show-motion-f)
nmap F <Plug>(show-motion-F)
nmap t <Plug>(show-motion-t)
nmap T <Plug>(show-motion-T)
nmap ; <Plug>(show-motion-;)
nmap , <Plug>(show-motion-,)

" Easymotion like
if has('nvim')
  function! s:hop_add_mapping(key, f, ft)
    let prefix = len(a:ft) > 0 ? 'autocmd FileType '.a:ft.' ' : ''

    exec prefix.'nmap <silent> '.a:key." :lua require'hop'.".a:f.'()<CR>'
    exec prefix.'vmap <silent> '.a:key.
      \ " :lua require'hop'.".a:f.'({ extend_visual = true })<CR>'
  endfunction

  let s:hop_mappings = {
    \ 'ñw': 'hint_words_same_line',
    \ 'ñb': 'hint_backwords_same_line',
    \ 'ñe': 'hint_word_ends_same_line',
    \ 'ñE': 'hint_backword_ends_same_line',
    \
    \ 'K': 'hint_lines_to_top',
    \ 'J': 'hint_lines_to_bottom',
    \ '<leader>k': 'hint_lines_to_top_same',
    \ '<leader>j': 'hint_lines_to_bottom_same',
    \ }

  for [key, f] in items(s:hop_mappings)
    call s:hop_add_mapping(key, f, '')
  endfor

  augroup hop_chad
    au!
    call s:hop_add_mapping('K', 'hint_lines_sol_to_top', 'CHADTree')
    call s:hop_add_mapping('J', 'hint_lines_sol_to_bottom', 'CHADTree')
  augroup end
else
  map ñw <Plug>(easymotion-wl)
  map ñb <Plug>(easymotion-bl)
  map ñe <Plug>(easymotion-el)
  map ñE <Plug>(easymotion-ge)

  map J <Plug>(easymotion-sol-j)
  map K <Plug>(easymotion-sol-k)
  map <leader>j <Plug>(easymotion-j)
  map <leader>k <Plug>(easymotion-k)
endif

" }}}

" End of File configuration
colorscheme nightowl2
