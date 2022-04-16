" Enable termguicolors if possible
if has('termguicolors')
  set termguicolors
endif

call plug#begin()
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'p00f/nvim-ts-rainbow'
  Plug 'ggzor/night-owl2.vim'
call plug#end()

lua <<EOF
  require'nvim-treesitter.configs'.setup {
    ensure_installed = "all",
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

colorscheme nightowl2
