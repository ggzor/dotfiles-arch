" vim:fdm=marker

" Global variables
let g:theme      = 'nightowl'
let g:mapleader  = ' '
let g:tabsize    = 2
let g:use_icons  = 1

" Computed options {{{

" Default configuration path
let g:configPath = stdpath('config')

" Check if vim is embedded
let g:env = exists('g:vscode')              ? 'vscode'
       \: ( exists('g:started_by_firenvim') ? 'firenvim'
       \: ( exists('g:athame')              ? 'athame'
       \                                    : 'vim'
       \  ))

" Features:
"   easymotion    Easymotion support
"   fzf           Fuzzy finder support
"   icons         Use only if a NERD Font is available
"   insert        Insert mode enhancers
"   lsp           Language Server Protocol plugins
"   operators     Additional operators that might break non-vim hosts
"   syntax        Syntax highlighting
"   textobj       Additional text objects
"   themes        Self-descripting

let g:env_options = {
  \ 'vscode': ['easymotion', 'insert', 'operators', 'textobj'],
  \ 'firenvim': [ 'easymotion', 'insert', 'operators', 'syntax', 'textobj', 'themes' ],
  \ 'athame': [ 'insert', 'operators', 'syntax', 'textobj', 'themes' ],
  \ 'vim': [ 'easymotion', 'fzf', 'icons', 'insert', 'lsp', 'operators',
  \          'syntax', 'textobj', 'themes'],
  \ }

let s:current_options = g:env_options[g:env]

for env_option in s:current_options
  execute printf('let s:use_%s = 1', env_option)
endfor

" Configuration overrides
if exists('s:use_icons')
  let s:use_icons = s:use_icons && g:use_icons
endif

" }}}

" Editor options {{{

" Note: 'let &option = x' is equivalent to 'set option=x'
"       but the former allows x to be a variable

" Preview replacements
set inccommand=nosplit

" Replace tabs with spaces
set expandtab

" Set tab size for all options
let &shiftwidth  = g:tabsize
let &softtabstop = g:tabsize
let &tabstop     = g:tabsize

" Tab size overrides
" Python: 4
autocmd FileType python setlocal shiftwidth=4 softtabstop=4 tabstop=4
" Go: 4 and use tabs
autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=-1

" Indent preserving indentation level
set autoindent
set smartindent

" Read file changes outside of vim automatically
set autoread
au FocusGained,BufEnter * :checktime

" Show parenthesis match
set showmatch

" Better search behavior
set ignorecase
set smartcase

" File write behavior
set updatetime=100
set backupcopy=yes

" File undo history
set undofile
set undolevels=250
set undodir=~/.vim/undo

" Changing to another file doesn't requires save
set hidden

" Change terminal title to file name
set title
augroup au_terminal_title
  au!
  auto BufEnter * let &titlestring = expand("%") . " - vim"
augroup end

" }}}

" Visual options {{{

syntax enable
if has("termguicolors")
  set termguicolors
endif

" Self explanatory
set cursorline
set noshowmode
set number nornu

" Prefer splitting below and to the right
set splitbelow
set splitright

" Hide not useful mesages
set shortmess+=cI

" Add a color column at the 89th char
call matchadd('ColorColumn', '\%89v', 100)
let s:exclude_cursor_column=['', 'man']
augroup au_color_col
  au!
  autocmd BufEnter,WinEnter,FileType * exec 'hi ColorColumn guifg=none guibg='
        \.. (index(s:exclude_cursor_column, &ft) >= 0 ? 'none' : '#78808b')
augroup end

" Invisibles
augroup au_list
  au!
  autocmd FileType asm set list
augroup end
set listchars=tab:››,trail:⋅,space:⋅,extends:»,precedes:«,nbsp:⣿

" Disable cursor line highlighting in insert mode if not in diff
augroup aug_cursor_line
  au!
  au InsertEnter * if !&diff | setlocal nocursorline | endif
  au InsertLeave * if !&diff | setlocal cursorline | endif
augroup END

" Diff options
set diffopt=vertical,filler,foldcolumn:1

" }}}

" Plugin before configuration {{{

" ALE
" Only load in certain file types
let g:ale_completion_enabled = 0


" gitgutter
let g:gitgutter_sign_added              = '▍'
let g:gitgutter_sign_modified           = '▍'
let g:gitgutter_sign_removed            = '▍'
let g:gitgutter_sign_modified_removed   = '▍'

" vim-polyglot
" Use my own fork for this specific filetype
let g:polyglot_disabled = [
  \ 'javascriptreact',
  \ 'typescriptreact',
  \ 'javascript',
  \ 'tsx', 'jsx',
  \ 'python', 'idris', 'haskell' ]

" vim-sandwich
let g:sandwich_no_default_key_mappings = 1
let g:operator_sandwich_no_default_key_mappings = 1

" }}}

" Plugins {{{

" Auto-install vim-plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source g:configPath."/init.vim"
endif

" vscode requires another directory for plugins
if g:env == 'vscode'
  call plug#begin(g:configPath.'/plugged-vs')
else
  " Regular vim-plug directory
  call plug#begin()
endif

" Utilities for other plugins
Plug 'xolox/vim-misc'
Plug 'machakann/vim-highlightedyank'
Plug 'lervag/vimtex'

" Variables s:use_<option> are set in Computed Options section
if s:use_textobj
  Plug 'kana/vim-textobj-user'

  Plug 'wellle/targets.vim'
  Plug 'kana/vim-textobj-entire'
  Plug 'kana/vim-textobj-indent'
  Plug 'kana/vim-textobj-line'
  Plug 'saihoooooooo/vim-textobj-space'
  Plug 'kana/vim-textobj-syntax'
  Plug 'Julian/vim-textobj-variable-segment'
endif

" New operators or enhancements
if s:use_operators
  Plug 'godlygeek/tabular'
  Plug 'tpope/vim-abolish'
  Plug 'tpope/vim-commentary'
  Plug 'andymass/vim-matchup'
  Plug 'machakann/vim-sandwich'
  Plug 'christoomey/vim-sort-motion'
  Plug 'svermeulen/vim-subversive'
  Plug 'bronson/vim-visual-star-search'
  Plug 'vim-scripts/vis'
endif

function! VisualCountWords() range
    let n = @n
    silent! normal gv"ny
    echo "Result" . system("printf '" . @n . "' | wc -c")
    let @n = n
    " bonus: restores the visual selection
    normal! gv
endfunction

if s:use_easymotion
  if g:env == 'vscode'
    " easymotion/vim-easymotion won't work in vscode
    Plug 'asvetliakov/vim-easymotion'
  else
    Plug 'easymotion/vim-easymotion'
    Plug 'ggzor/ShowMotion'
    Plug 'ggzor/hop.nvim'
  endif
endif

" Plugins that modify insert mode behavior
if s:use_insert
  Plug 'mattn/emmet-vim'
  Plug 'tmsvg/pear-tree'
  Plug 'eraserhd/parinfer-rust', {'do':
          \  'cargo build --release'}
endif

" Syntaxes and syntax enhancers
if s:use_syntax
  Plug 'dylon/vim-antlr'
  Plug 'hail2u/vim-css3-syntax'
  Plug 'lpinilla/vim-codepainter'
  Plug 'sheerun/vim-polyglot'

  Plug 'pangloss/vim-javascript'
  Plug 'maxmellon/vim-jsx-pretty'

  Plug 'honza/vim-snippets'
  Plug 'luochen1990/rainbow'

  " Custom syntax
  Plug 'ggzor/python-syntax', { 'branch': 'dev' }

  " Idris
  Plug 'edwinb/idris2-vim'

  " Agda
  Plug 'derekelkins/agda-vim'
endif

if s:use_themes
  Plug 'haishanh/night-owl.vim'
  Plug 'dylanaraps/wal.vim'
endif

" Fuzzy finder plugins
if s:use_fzf
  Plug 'antoinemadec/coc-fzf'
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
endif

" Language Server Protocol specific plugins
if s:use_lsp
  Plug 'dense-analysis/ale'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif

if s:use_icons
  Plug 'ryanoasis/vim-devicons'
endif

" Environment specific

" Only load if inside firenvim
if g:env == 'firenvim'
  Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
endif

" These plugins only make sense inside vim
if g:env == 'vim'
  Plug 'Olical/conjure', {'tag': 'v4.3.1'}
  Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': ':UpdateRemotePlugins'}
  Plug 'junegunn/goyo.vim'
  Plug 'junegunn/gv.vim'
  Plug 'Yggdroot/indentLine'
  Plug 'itchyny/lightline.vim'
  Plug 'junegunn/limelight.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'wsdjeg/vim-fetch'
  Plug 'airblade/vim-gitgutter'
  Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
  Plug 'simnalamburt/vim-mundo'
  Plug 'romainl/vim-qf'
  Plug 'vim-test/vim-test'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'simeji/winresizer'
endif

call plug#end()

" }}}

" Plugin after configuration {{{

let g:highlightedyank_highlight_duration = -1

let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_enabled = 0

if s:use_textobj

endif

if s:use_operators

  " matchup
  " Increase responsiveness deferring highlighting
  let g:matchup_matchparen_deferred = 1
  let g:matchup_matchparen_deferred_show_delay = 50
  " Show surrounding parens
  let g:matchup_matchparen_hi_surround_always = 1
  " Don't match offscreen parens
  let g:matchup_matchparen_offscreen = {}

endif

if s:use_easymotion

  " easymotion
  let g:EasyMotion_off_screen_search = 0
  " Don't map default mappings
  let g:EasyMotion_do_mapping = 0
  " Allow mapping differently start of line mappings and same column
  let g:EasyMotion_startofline = 0
  " Press space to select first
  let g:EasyMotion_space_jump_first=1
  " The fastest keys I press
  let g:EasyMotion_keys = '_fasjuirwzmkhdoe'

  " hop
  lua require'hop'.setup { keys = 'fasjuirwzmkhdoe' }

endif

if s:use_insert

  " emmet-vim
  let g:user_emmet_install_global = 0
  " Load emmet only in certain file types
  autocmd FileType html,css,javascriptreact,typescriptreact,xml EmmetInstall

  " pear-tree
  let g:pear_tree_smart_openers = 1
  let g:pear_tree_smart_closers = 1
  let g:pear_tree_smart_backspace = 1
  let g:pear_tree_repeatable_expand = 0

endif

if s:use_syntax

  let g:rainbow_active = 0

endif

if s:use_themes
  " Code painter

  let g:paint_color_idx = 0
  let g:paint_colors = ['blue', 'yellow', 'green', 'red', 'gray']

  " Code painter
  func! CodePainterAdjustColor(amount) abort
    let g:paint_color_idx = ((g:paint_color_idx + a:amount + len(g:paint_colors)) % len(g:paint_colors))
    call codepainter#ChangeColorByName('paint'.g:paint_colors[g:paint_color_idx])
    if a:amount != 0
      echo "Using color: " . g:paint_colors[g:paint_color_idx]
    endif
  endfunc
  call CodePainterAdjustColor(0)

endif


if s:use_fzf
  " coc-fzf
  let g:coc_fzf_preview='right:60%'

endif

if s:use_lsp

  " ALE
  " Only enable for certain file types
  let g:ale_enabled=0
  let g:ale_fixers = {
  \   '*': ['trim_whitespace'],
  \}
  let g:ale_fix_on_save = 1
  " LSP capabilities are provided by Coc.vim
  let g:ale_disable_lsp = 1


  " Coc
  " Only use larger cmdheight with lsp
  set cmdheight=2
  " Enable sign column if on lsp
  set signcolumn=yes

  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')

  augroup au_coc_groups
    autocmd!
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end

  let g:coc_global_extensions = [
        \'coc-css',
        \'coc-emmet',
        \'coc-eslint',
        \'coc-json',
        \'coc-prettier',
        \'coc-pyright',
        \'coc-rust-analyzer',
        \'coc-snippets',
        \'coc-tsserver',
        \'coc-clangd',
        \'coc-java',
        \'coc-go',
        \'coc-styled-components',
        \'coc-vimtex'
        \]

  " Function textobj provided by LSP
  xmap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap if <Plug>(coc-funcobj-i)
  omap af <Plug>(coc-funcobj-a)

endif

if s:use_icons

  " web-devicons
  " From FAQ: How do I solve issues after re-sourcing my vimrc?
  if exists("g:loaded_webdevicons")
    call webdevicons#refresh()
  endif

endif

if g:env == 'vim'

  " FIXME: Allow easymotion up and down line
  " CHADTree
  let g:chadtree_settings = {
    \ 'theme': {
    \   'text_colour_set': 'env'
    \ },
    \ 'view': {
    \   'open_direction': 'right',
    \ },
    \ 'keymap': {
    \   'jump_to_current': ['<C-o>'],
    \   'stat': ['<C-g>'],
    \ },
    \ }
  " Auto close if CHADTree is the only window open
  autocmd BufEnter * if (winnr("$") == 1 && &ft == 'chadtree') | q | endif

  " goyo.vim
  let g:goyo_width = 95
  " goyo functions {{{

  function! s:goyo_enter()
    if executable('tmux') && strlen($TMUX)
      silent !tmux set status off
      silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
    endif
    highlight EndOfBuffer guifg=bg guibg=bg
    set noshowcmd
    set laststatus=0
    set cmdheight=1
    set nolist
  endfunction

  function! s:goyo_leave()
    if executable('tmux') && strlen($TMUX)
      silent !tmux set status on
      silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
    endif
    call RefreshTheme()
    set showcmd
    set laststatus=2
    set cmdheight=2
    set list

    " Redefine rnu group
    augroup aug_rnu
      au InsertEnter * if !&diff | setlocal nornu | endif
      au InsertLeave * if !&diff | setlocal rnu | endif
    augroup end
  endfunction

  " Call functions for goyo events
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()

  " }}}

  " indentLine
  let g:indentLine_enabled = 0
  let g:indentLine_char = '|'
  autocmd FileType python IndentLinesEnable

  " lightline
  let g:lightline = {
        \   'active': {
        \     'left':[ [ 'mode', 'paste' ],
        \              [ 'gitbranch', 'readonly', 'filename' ]
        \     ],
        \     'right': [ [ 'lineinfo' ], [ 'percent' ], [ 'filetype' ] ]
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
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
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

  function RefreshLightline()
    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
  endfunction
  " }}}

  " vim-fugitive
  " Set fugitive size
  augroup fugitive_window_size
    au!
    au FileType fugitive 16wincmd_
  augroup END

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

  " vim-mundo
  let g:mundo_right=1

  " vim-qf
  let g:qf_mapping_ack_style = 1

  " vim-test
  let g:test#transformation = 'typescript'
  let g:test#javascript#mocha#file_pattern = '\v.*\.spec\.(ts|tsx)$'
  function! TypeScriptTransform(cmd) abort
    return substitute(a:cmd, '\v(.*)mocha', 'yarn mocha -r ts-node/register', '')
  endfunction
  let g:test#custom_transformations = {'typescript': function('TypeScriptTransform')}

endif

" Environment specific
if g:env == 'firenvim'
  set laststatus=0

  let g:firenvim_config = {
    \ 'globalSettings': {
        \ 'alt': 'all',
    \  },
    \ 'localSettings': {
        \ '.*': {
            \ 'cmdline': 'neovim',
            \ 'priority': 0,
            \ 'selector': 'textarea',
            \ 'takeover': 'always',
        \ },
      \ }
    \ }

  let fc = g:firenvim_config['localSettings']

  let fc['.*'] = {
        \ 'selector': 'textarea:not([readonly]), div[role="textbox"], input:not([readonly])',
        \ 'takeover': 'always',
        \ 'cmdline': 'firenvim'
        \ }
endif

" }}}

" Custom functions {{{

function! DeleteEmptyBuffers()
    let [i, n; empty] = [1, bufnr('$')]
    while i <= n
        if bufexists(i) && bufname(i) == ''
            call add(empty, i)
        endif
        let i += 1
    endwhile
    if len(empty) > 0
        exe 'bdelete' join(empty)
    endif
endfunction

function! ShowSyntaxGroupUnderCursor()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

function! ExitFloatingMode()
  exec 'normal gg_vG$"+y'
  call system("xclip -in -selection clipboard", getreg('+'))
  quit!
endfunction

function! PrepareFloatingMode()
  exec 'normal "+P'

  " Exit either saving or quitting
  nnoremap <silent> ñq :call ExitFloatingMode()<CR>
  nnoremap <silent> ñs :call ExitFloatingMode()<CR>
endfunction

" FZF {{{

" Hide status line
if has('nvim') && !exists('g:fzf_layout')
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noruler nonumber nornu
    \| autocmd BufLeave <buffer> set laststatus=2 ruler
endif

" FZF Full Screen preview to the right
let $FZF_DEFAULT_COMMAND = "fd --type f --hidden --exclude .git --follow"
let g:fzf_preview_window_min_width=100

function! FZFFiles(fullscreen)
  let ww = winwidth(0)
  let wh = winheight(0)
  let go_full = a:fullscreen || ww <= 100

  let preview_width = min([95, float2nr(0.50 * ww)])
  let right_preview_string = 'right:'.preview_width.':noborder:nowrap'

  let preview_params = go_full
        \ ? fzf#vim#with_preview(ww <= 100 ? 'down:61%:border:nowrap' : right_preview_string)
        \ : right_preview_string
  let options = fzf#vim#with_preview(preview_params)

  if !go_full
    let target_width = min([160, float2nr(0.9 * ww)])
    let target_height = min([60, float2nr(0.8 * wh)])
    call extend(options, { 'window': { 'width': target_width, 'height': target_height } })
  endif

  call fzf#vim#files('', options, go_full)
endfunction

let g:fzf_history_dir = '~/.fzf-vim-history'

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

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let options = ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]
  let spec = {'options': options }
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

" }}}

" Visual mode {{{

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

" }}}

" Quickfix {{{

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

" }}}

" Workarounds/Hacks {{{

" FIXME: Configure in theme
let g:indentLine_color_gui = '#283646'

" Diff mode hacks {{{

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

  function FixDiffParameters(timer)
     let curwin = winnr()

    " Check each window
    for _win in range(1, winnr('$'))
      " Go to window without triggering autocmd's
      exe "noautocmd " . _win . "wincmd w"

      " Cursor line must be disabled in diff mode
      call s:change_option_in_diffmode("w:", "cursorline", 0, 1)
    endfor

    " Get back to original window
    exe "noautocmd " . curwin . "wincmd w"
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
  function s:UpdateDiffColors()
    let curwin = winnr()

    for _win in range(1, winnr('$'))
      exe "noautocmd " . _win . "wincmd w"

      if _win == 1
        setlocal winhighlight=DiffAdd:DiffOldAdd,
              \DiffChange:DiffOldChange,
              \DiffText:DiffOldText
      elseif _win == 2
        setlocal winhighlight=""
      endif
    endfor

    " Get back to original window
    exe "noautocmd " . curwin . "wincmd w"
  endfunction

" }}}

" }}}

" Text objects {{{

"" Text object for hunks
omap ih <Plug>(GitGutterTextObjectInnerPending)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)


" }}}

" Keybindings and Text objects {{{

" General

" Filter selection with program
nnoremap <silent> <leader>1 :set opfunc=ProgramFilter<cr>g@
vnoremap <silent> <leader>1 :call ProgramFilter(visualmode(), 1)<cr>

" Make Y similar to C and D
noremap Y y$

" Navigate to alternate file
nnoremap <silent> ña <C-^>

" No highlight
nnoremap <silent> ñn :<C-u>nohlsearch<CR>

" Plugins
if s:use_operators

  " vim-sandwich
  " add
  nmap ñi <Plug>(operator-sandwich-add)
  xmap ñi <Plug>(operator-sandwich-add)
  " delete
  nmap ñd <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
  xmap ñd <Plug>(operator-sandwich-delete)
  nmap ñdd <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
  " replace
  nmap ñr <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
  xmap ñr <Plug>(operator-sandwich-replace)
  nmap ñrr <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)

  " vim-subversive
  nmap s <plug>(SubversiveSubstitute)

endif

if s:use_easymotion
  nmap f <Plug>(show-motion-f)
  nmap F <Plug>(show-motion-F)
  nmap t <Plug>(show-motion-t)
  nmap T <Plug>(show-motion-T)
  nmap ; <Plug>(show-motion-;)
  nmap , <Plug>(show-motion-,)

  map <leader>f <Plug>(easymotion-fl)
  map <leader>F <Plug>(easymotion-Fl)
  map <leader>t <Plug>(easymotion-tl)
  map <leader>T <Plug>(easymotion-Tl)

  nmap ñw :lua require'hop'.hint_words_same_line()<CR>
  nmap ñb :lua require'hop'.hint_backwords_same_line()<CR>
  nmap ñe :lua require'hop'.hint_word_ends_same_line()<CR>
  nmap ñE :lua require'hop'.hint_backword_ends_same_line()<CR>

  vmap <silent> ñw :lua require'hop'.hint_words_same_line( { extend_visual = true } )<CR>
  vmap <silent> ñb :lua require'hop'.hint_backwords_same_line( { extend_visual = true } )<CR>
  vmap <silent> ñe :lua require'hop'.hint_word_ends_same_line( { extend_visual = true } )<CR>
  vmap <silent> ñE :lua require'hop'.hint_backword_ends_same_line( { extend_visual = true } )<CR>

  nmap <silent> K :lua require'hop'.hint_lines_to_top()<CR>
  nmap <silent> J :lua require'hop'.hint_lines_to_bottom()<CR>
  nmap <silent> <leader>j :lua require'hop'.hint_lines_to_bottom_same()<CR>
  nmap <silent> <leader>k :lua require'hop'.hint_lines_to_top_same()<CR>

  vmap <silent> K :lua require'hop'.hint_lines_to_top( { extend_visual = true } )<CR>
  vmap <silent> J :lua require'hop'.hint_lines_to_bottom( { extend_visual = true } )<CR>
  vmap <silent> <leader>j :lua require'hop'.hint_lines_to_bottom_same( { extend_visual = true } )<CR>
  vmap <silent> <leader>k :lua require'hop'.hint_lines_to_top_same( { extend_visual = true } )<CR>
endif

if s:use_insert
  " emmet
  let g:user_emmet_leader_key='<C-Y>'
endif

if s:use_fzf
  nnoremap <silent> ñf :call FZFFiles(0)<CR>
  nnoremap <silent> ñF :call FZFFiles(1)<CR>
  nnoremap <silent> ñj :Buffers<CR>
  nnoremap <silent> ñl :BLines<CR>
  nnoremap <silent> ññ :History:<CR>
  nnoremap <silent> ñh :Helptags<CR>
  " nnoremap <silent> ñr :call RipgrepFzfFuzzy('', 0, 1)<CR>
  " nnoremap <silent> ñR :call RipgrepFzfFuzzy('', 1, 1)<CR>
  nnoremap <silent> ñg :call RipgrepFzf('', 0)<CR>
  nnoremap <silent> ñG :call RipgrepFzf('', 1)<CR>
endif

if s:use_lsp

  " coc
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
        \ ? coc#float#scroll(1) : "J"
  nnoremap <silent><nowait><expr> <A-k> coc#float#has_scroll()
        \ ? coc#float#scroll(0) : "i<CR><Esc>k$"

  inoremap <silent><nowait><expr> <A-j> coc#float#has_scroll()
        \ ? "\<c-r>=coc#float#scroll(1)\<cr>" : ""
  inoremap <silent><nowait><expr> <A-k> coc#float#has_scroll()
        \ ? "\<c-r>=coc#float#scroll(0)\<cr>" : ""

  vnoremap <silent><nowait><expr> <A-j> coc#float#has_scroll()
        \ ? coc#float#scroll(1) : ""
  vnoremap <silent><nowait><expr> <A-k> coc#float#has_scroll()
        \ ? coc#float#scroll(0) : ""
endif

if g:env == 'vim'

  " CHADTree
  nmap <C-n> :CHADopen<CR>

  " vim-fugitive
  nmap <silent> <leader>gh :call ToggleGitDiffMode()<CR>

  " vim-gitgutter
  nmap <silent> <leader>gr <Plug>(GitGutterUndoHunk)
  nmap <silent> <leader>gs :GitGutterStageHunk <bar> GitGutterNextHunk <bar> normal! zz<CR>

  " vim-mundo
  nmap <leader>u :<C-u>MundoToggle<CR>

  " vim-qf
  nmap <leader>{ <Plug>(qf_qf_previous)
  nmap <leader>} <Plug>(qf_qf_next)
  nmap <buffer> <Left>  <Plug>(qf_older)
  nmap <buffer> <Right> <Plug>(qf_newer)
  nmap <leader>q <Plug>(qf_qf_toggle_stay)

  autocmd FileType qf nmap <silent> <buffer> dd :call RemoveQFItem()<cr>
  autocmd FileType qf nmap <silent> <buffer> u :call RestoreQFItem()<cr>

  " vim-test
  " nnoremap <silent> ñt :<C-u>w <bar> TestNearest<CR>
  " nnoremap <silent> ñtf :<C-u>w <bar> TestFile<CR>
  " nnoremap <silent> ñtj :<C-u>TestVisit<CR>

  " winresizer
  let g:winresizer_start_key = '<leader>W'

endif

vnoremap <silent> gp :<c-u> call codepainter#paintText(visualmode())<cr>
nnoremap <silent> gp <nop>
nnoremap <silent> gP :<c-u> PainterEraseLine<cr>

nnoremap <silent> g- :<c-u> call CodePainterAdjustColor(1)<cr>
nnoremap <silent> g+ :<c-u> call CodePainterAdjustColor(-1)<cr>

if g:env == 'vscode'
  " comments
  xmap <leader>ci  <Plug>VSCodeCommentary
  nmap <leader>ci  <Plug>VSCodeCommentary
  omap <leader>ci  <Plug>VSCodeCommentary
endif

" }}}

" Check for special floating mode
if $NVIM_FLOATING
  call PrepareFloatingMode()
endif

" Load color configuration
source $HOME/.config/nvim/other.vim

