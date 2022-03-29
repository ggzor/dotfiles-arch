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

  " Use tabs with Go and Make
  autocmd FileType go,make setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=-1
augroup END

" Indent preserving indentation level
set autoindent
set smartindent

" Read file changes outside of vim automatically
set autoread
au FocusGained,BufEnter * if !len(getcmdwintype()) | :checktime | endif

" Show parenthesis match
set showmatch

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
  \ 'php',
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
Plug 'stefandtw/quickfix-reflector.vim'
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
Plug 'svermeulen/vim-subversive'
Plug 'tmsvg/pear-tree'
Plug 'tpope/vim-abolish'

if has('nvim')
  Plug 'numToStr/Comment.nvim'
  Plug 'JoosepAlviste/nvim-ts-context-commentstring'
else
  Plug 'tpope/vim-commentary'
endif

" Extra old syntax
Plug 'dylon/vim-antlr'
Plug 'sheerun/vim-polyglot'
Plug 'luochen1990/rainbow'

" Easymotion like behavior
if has('nvim')
  Plug 'phaazon/hop.nvim'
else
  Plug 'easymotion/vim-easymotion'
endif

" fzf
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" LSP
if has('nvim')
  Plug 'neoclide/coc.nvim', {
        \ 'branch': 'master',
        \ 'do': 'yarn install && yarn build' }
  Plug 'antoinemadec/coc-fzf', { 'branch': 'master' }
endif

" treesitter
if has('nvim')
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/playground'
  Plug 'nvim-treesitter/nvim-treesitter-refactor'
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
  Plug 'p00f/nvim-ts-rainbow'
  Plug 'windwp/nvim-ts-autotag'
endif

" NERDTree Like
if has('nvim')
  Plug 'ms-jpq/chadtree', {
        \ 'branch': 'chad',
        \ 'do': 'python3 -m chadtree deps --nvim',
        \ 'on': 'CHADopen' }
else
  Plug 'preservim/nerdtree'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
endif

" Custom language plugins
Plug 'wlangstroth/vim-racket'
Plug 'tpope/vim-dispatch'
Plug 'clojure-vim/vim-jack-in'
if has('nvim')
  Plug 'radenling/vim-dispatch-neovim'
  Plug 'Olical/conjure'
endif
Plug 'dense-analysis/ale'
Plug 'derekelkins/agda-vim'
Plug 'edwinb/idris2-vim'
Plug 'eraserhd/parinfer-rust', {'do': 'cargo build --release'}
Plug 'ggzor/vim-snippets'
Plug 'lervag/vimtex'
Plug 'rhysd/reply.vim'

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
    autotag = {
      enable = true,
    },
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
    refactor = {
      highlight_definitions = { enable = true },
      smart_rename = {
        enable = true,
        keymaps = {
          smart_rename = "<leader><leader>r"
        }
      }
    },
    playground = {
      enable = true,
      updatetime = 25,
      persist_queries = false,
    },
    textobjects = {
      swap = {
        enable = true,
        swap_next = {
          ["<leader>."] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>,"] = "@parameter.inner",
        },
      },
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

" conjure
let g:conjure#mapping#doc_word = v:false

" highlightedyank
let g:highlightedyank_highlight_duration = -1

" nvim-comment
lua <<EOF
  require'nvim-treesitter.configs'.setup {
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    }
  }

  require'Comment'.setup({
    pre_hook = function(ctx)
        if vim.bo.filetype == 'typescriptreact' then
            local U = require('Comment.utils')

            local type = ctx.ctype == U.ctype.line and '__default' or '__multiline'

            local location = nil
            if ctx.ctype == U.ctype.block then
                location = require('ts_context_commentstring.utils').get_cursor_location()
            elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
                location = require('ts_context_commentstring.utils').get_visual_start_location()
            end

            return require('ts_context_commentstring.internal').calculate_commentstring({
                key = type,
                location = location,
            })
        end
    end,
  })
EOF

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

" reply.vim
let g:reply_repl_node_command_options = ['--experimental-repl-await']

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
let g:EasyMotion_keys = 'aeiousdfjl'

" hop.nvim
if has('nvim')
lua << EOF
  require'hop'.setup {
      keys = 'aeiousdfjl',
      teasing = false
    }
EOF
endif

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
        \'@yaegassy/coc-intelephense',
        \'coc-cfn-lint',
        \'coc-clangd',
        \'coc-clojure',
        \'coc-conjure',
        \'coc-css',
        \'coc-emmet',
        \'coc-emoji',
        \'coc-eslint',
        \'coc-go',
        \'coc-html',
        \'coc-java',
        \'coc-json',
        \'coc-lua',
        \'coc-prettier',
        \'coc-pyright',
        \'coc-rust-analyzer',
        \'coc-sh',
        \'coc-snippets',
        \'coc-styled-components',
        \'coc-tsserver',
        \'coc-vimlsp',
        \'coc-vimtex',
        \'coc-yaml',
        \]

  " coc-fzf
  let g:coc_fzf_opts = ['--no-exit-0']
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
    \     'collapse': ['zm'],
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
      \     'right': [ [ 'lineinfo' ], [ 'mouse', 'filetype' ] ]
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
      \     'mouse': 'LightlineGetMouseOn',
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
      return WebDevIconsGetFileTypeSymbol(@%) . ' ' . @% . (&modified ? ' ●' : '')
    else
      return '[No Name]'
    endif
  else
    return ''
  endif
endfunction

function! GetFileTypeIcon()
  return winwidth(0) > 70
    \ ? (strlen(&filetype) ? &filetype.' '.WebDevIconsGetFileTypeSymbol(@%) : 'no ft')
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

function! LightlineGetMouseOn() abort
  return &mouse == "" ? "" : ""
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

" quickfix-reflector.vim
let g:qf_modifiable = 1
let g:qf_write_changes = 0

" fzf
let $FZF_DEFAULT_COMMAND = "fd --type f --hidden --exclude .git --follow"
let g:fzf_preview_window_min_width=100
let g:fzf_history_dir = '~/.fzf-vim-history'

" Get preview options depending on current window size
"   target_prev_width = The size of the preview window
"   switch_layout_width = The neovim windows size at which full screen mode is
"                         forced
function! FZFPreviewOptions(options, target_prev_width, switch_layout_width
                           \, float_max_width = 160
                           \)
  let ww = &columns
  let wh = &lines
  let go_full = ww <= a:switch_layout_width

  let max_width = float2nr(3.0 * ww / 5.0)
  let preview_width = min([a:target_prev_width, max_width])
  let right_preview_string = 'right:'.preview_width.':noborder:nowrap'

  let preview_params = go_full ? 'up:71%:border:nowrap' : right_preview_string

  let options = fzf#vim#with_preview(a:options, preview_params)

  if !go_full
    let target_width = min([a:float_max_width, float2nr(0.9 * ww)])
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
function! RipgrepFzf(query, fuzzy)
  let command_fmt =
    \ 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')

  let options = [
    \ '--query', a:query,
    \ ]

  if !a:fuzzy
    call extend(options, [
      \ '--disabled',
      \ '--bind', 'change:reload:'.reload_command,
      \ ])
  endif

  let [options, go_full] = FZFPreviewOptions({ 'options': options }, 100, 180)
  call fzf#vim#grep(initial_command, 1, options, go_full)
endfunction

function! ExecuteWithCocFzf(command) abort
  try
    execute a:command
  catch
    echohl WarningMsg
    echon 'Warning: '
    echohl None
    echon 'coc.nvim is not ready'
  endtry
endfunction

function! CocFZFListDefaultWindow(command) abort
  let [options, go_full] = FZFPreviewOptions({}, 100, 180)

  " Ugly global configuration
  let g:coc_fzf_preview_fullscreen = go_full

  if go_full
    let g:fzf_layout = {}
  else
    let g:fzf_layout = { 'window': options['window'] }
  endif

  let g:coc_fzf_preview = 'up:71%:border:nowrap'

  call ExecuteWithCocFzf(a:command)
endfunction

function! FZFDiagnostics(current_file) abort
  call CocFZFListDefaultWindow(
        \ 'CocFzfList diagnostics '.(a:current_file ? '--current-buf' : ''))
endfunction

function! FZFReferences() abort
  call CocFZFListDefaultWindow(
        \ 'call CocAction("jumpReferences")')
endfunction

function! FZFSymbols() abort
  call CocFZFListDefaultWindow('CocFzfList symbols')
endfunction

function! FZFOutline() abort
  let [options, go_full] = FZFPreviewOptions({}, 90, 150)

  " Ugly global configuration
  let g:coc_fzf_preview_fullscreen = go_full

  if go_full
    let g:fzf_layout = {}
  else
    let g:fzf_layout = { 'window': options['window'] }
  endif

  let g:coc_fzf_preview = options['options'][
        \ index(options['options'], '--preview-window') + 1]

  call ExecuteWithCocFzf('CocFzfList outline')
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

function! FZFWithHandledExit(fun, postFuncName, extraArgs = []) abort
  let g:__fzf_handled_exit = a:postFuncName
  let Target = function(a:fun, a:extraArgs)
  call Target()
endfunction

function! FZFEndHandledExit() abort
  if exists('g:__fzf_handled_exit')
    try
      let Callback = function(g:__fzf_handled_exit)

      if v:event['status'] == 0
        call Callback()
      endif
    catch /.*/
      throw v:exception
    finally
      unlet g:__fzf_handled_exit
    endtry
  endif
endfunction

augroup fzf_handled_exit
  autocmd!
  autocmd TermClose * call FZFEndHandledExit()
augroup END

" }}}

" Scroll repositioning is really annoying if you are trying to keep your
" buffers at the top
" This hack was taken from: https://vim.fandom.com/wiki/Avoid_scrolling_when_switch_buffers
" The tracking issue for this problem is: https://github.com/vim/vim/issues/7954
function! Hack_AutoSaveWinView()
  if !exists("w:SavedBufView")
    let w:SavedBufView = {}
  endif
  let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

function! Hack_AutoRestoreWinView()
  let buf = bufnr("%")
  if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
    let v = winsaveview()
    let atStartOfFile = v.lnum == 1 && v.col == 0
    if atStartOfFile && !&diff
      call winrestview(w:SavedBufView[buf])
    endif
    unlet w:SavedBufView[buf]
  endif
endfunction

augroup au_hack_restore_win_view
  autocmd!
  autocmd BufLeave * call Hack_AutoSaveWinView()
  autocmd BufEnter * call Hack_AutoRestoreWinView()
augroup END

" FileType options {{{

let g:json_exclude_list = ['coc-settings.json']

augroup au_file_adjustments
  autocmd!

  " Use json with comments for almost all files
  autocmd BufNewFile,BufRead *.json
        \ if index(g:json_exclude_list, expand('%:t')) < 0
        \ | set filetype=jsonc
        \ | endif

  autocmd BufNewFile,BufRead *.nix set filetype=nix

  " Enable manually php autoindent
  autocmd BufEnter *.php set autoindent smartindent

  " Disable buggy indenting
  autocmd BufEnter *.md,*.py set indentexpr=
augroup END

" }}}

" Keymappings and text objects

" General mappings {{{
let g:mapleader = ' '
let g:maplocalleader = '-'

nmap - <nop>

" Make Y similar to C and D
noremap Y y$

" Navigate to alternate file
nnoremap <silent> ña <C-^>

" Hide highlight temporarily
nnoremap <silent> ñn :<C-u>nohlsearch<CR>

" Command line
cnoremap <C-a> <C-b>

" Toggle mouse support to resize panes
nnoremap <silent> <leader>m <cmd>let &mouse = &mouse == "" ? "a" : "" <cr>

" }}}

" Custom mappings {{{

" Visual selection filter
nnoremap <silent> <leader>1 :set opfunc=ProgramFilter<cr>g@
vnoremap <silent> <leader>1 :call ProgramFilter(visualmode(), 1)<cr>

" Go to directory under cursor
nmap <silent> <leader>d :<C-u>call OpenDirUnderCursor()<CR>

" }}}

" Plugin mappings {{{

function! CenterAndOpenFold() abort
  call feedkeys(":normal! zvzz\<CR>")
endfunction

" fzf
nnoremap <silent> ñf :call FZFFiles()<CR>
nnoremap <silent> ñg :call RipgrepFzf('', 0)<CR>
nnoremap <silent> ñG :call RipgrepFzf('', 1)<CR>
nnoremap <silent> ñd :call FZFDiagnostics(1)<CR>
nnoremap <silent> ñD :call FZFDiagnostics(0)<CR>
nnoremap <silent> ñq :call FZFWithHandledExit('FZFOutline', 'CenterAndOpenFold')<CR>
nnoremap <silent> ñs :call FZFSymbols()<CR>
nnoremap <silent> ñr :call FZFWithHandledExit('FZFReferences', 'CenterAndOpenFold')<CR>

nnoremap <silent> ñj :Buffers<CR>
nnoremap <silent> ñl :BLines<CR>
nnoremap <silent> ññ :History:<CR>
nnoremap <silent> ñh :Helptags<CR>

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

  " Navigate through normal diagnostics
  nmap <silent> <leader>h <Plug>(coc-diagnostic-prev)zz
  nmap <silent> <leader>l <Plug>(coc-diagnostic-next)zz

  " Navigate through error diagnostics
  nmap <silent> <leader>H <Plug>(coc-diagnostic-prev-error)zz
  nmap <silent> <leader>L <Plug>(coc-diagnostic-next-error)zz

  function! CocGoToDefinition() abort
    call CocAction('jumpDefinition')
    normal! zvzz
  endfunction

  " GoTo code navigation.
  nmap <silent> gd :call CocGoToDefinition()<CR>


  function! CocDoHover() abort
    try
      echo
      call CocAction('doHover')
    catch
      echohl WarningMsg
      echon 'Warning: '
      echohl None
      echon 'Waiting the LSP to be ready...'
    endtry
  endfunction

  " Show hover information
  nnoremap <silent> ñk :call CocDoHover()<CR>

  " LSP symbol renaming
  nmap <leader>r <Plug>(coc-rename)
  " Remap keys for applying codeAction to the current line.
  nmap <leader>a <Plug>(coc-codeaction)
  " Apply AutoFix to problem on the current line.
  nmap <leader>q  <Plug>(coc-fix-current)

  " Refresh Coc
  inoremap <silent><expr> <C-space> coc#refresh()

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

" vim-subversive
nmap s <plug>(SubversiveSubstitute)

" git commands
nmap <silent> gl <Plug>(GitGutterNextHunk)zz
nmap <silent> gh <Plug>(GitGutterPrevHunk)zz
nmap <silent> <leader>gr <Plug>(GitGutterUndoHunk)
nmap <silent> <leader>gs :GitGutterStageHunk <bar> GitGutterNextHunk <bar> normal! zz<CR>

if has('nvim')
  nmap <silent> <leader>gd :call ToggleGitDiffMode()<CR>
endif

" fugitive
command! Gco Git commit

omap ih <Plug>(GitGutterTextObjectInnerPending)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)

" vim-mundo
nmap <leader>u :<C-u>MundoToggle<CR>

" vim-qf
nmap <Left>  <Plug>(qf_qf_previous)zz
nmap <Right> <Plug>(qf_qf_next)zz
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

" reply.vim
command! Rr execute("Repl") | call feedkeys("\<C-\>\<C-n>G\<C-w>p")
noremap <silent><leader>s :ReplSend<cr>

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
lua << EOF
  local hop = require('hop')

  local function pick_direction(is_forward)
    local direction = is_forward
                        and 'AFTER_CURSOR'
                        or 'BEFORE_CURSOR'
    return require('hop.hint').HintDirection[direction]
  end

  function _G.local_hop_search_pattern(is_forward)
    vim.api.nvim_exec('nohlsearch', false)

    hop.hint_patterns(
      { direction = pick_direction(vim.v.searchforward == is_forward) },
      vim.fn.getreg('/')
    )

    vim.api.nvim_exec('set hlsearch', false)
  end

  local function override_opts(opts)
    return setmetatable(opts or {}, { __index = hop.opts })
  end

  local function scanning_lines(generator)
    return require'hop.jump_target'.jump_targets_by_scanning_lines(generator)
  end

  function _G.local_hop_start_of_line(is_forward)
    local function match_line()
      return {
        oneshot = true,
        match = function(s)
          return vim.regex("\\S"):match_str(s) or 0, 1, false
        end
      }
    end

    hop.hint_with(
      scanning_lines(match_line()),
      override_opts {
        direction = pick_direction(is_forward == 1)
      }
    )
  end


  function _G.local_hop_same_column(is_forward)
    local col = vim.api.nvim_win_get_cursor(0)[2] + 1

    local function match_line()
      return {
        oneshot = true,
        match = function(s)
          if col == 1 then
            return vim.regex("^\\S"):match_str(s)
          else
            return vim.regex('\\%'..tostring(col)..'v'):match_str(s)
          end
        end
      }
    end

    hop.hint_with(
      scanning_lines(match_line()),
      override_opts {
        direction = pick_direction(is_forward == 1)
      }
    )
  end
EOF

  noremap <silent> <leader>n <cmd>call v:lua.local_hop_search_pattern(1)<cr>
  noremap <silent> <leader>N <cmd>call v:lua.local_hop_search_pattern(0)<cr>

  noremap <silent> K <cmd>call v:lua.local_hop_start_of_line(0)<cr>
  noremap <silent> J <cmd>call v:lua.local_hop_start_of_line(1)<cr>

  noremap <silent> <leader>k <cmd>call v:lua.local_hop_same_column(0)<cr>
  noremap <silent> <leader>j <cmd>call v:lua.local_hop_same_column(1)<cr>

  augroup au_chad_hop
    autocmd!
    autocmd FileType CHADTree noremap <buffer> <silent> K :HopLineBC<CR>
    autocmd FileType CHADTree noremap <buffer> <silent> J :HopLineAC<CR>
  augroup END
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
