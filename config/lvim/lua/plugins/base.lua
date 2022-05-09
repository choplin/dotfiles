return {
  -- tokyonight colorscheme
  { "folke/tokyonight.nvim" },
  -- { "EdenEast/nightfox.nvim", tag = "v1.0.0" },
  -- Highlight Todo: comments
  { "folke/todo-comments.nvim", config = function() require("todo-comments").setup() end },
  -- Load a local .vimrc.lua file
  {
    "klen/nvim-config-local", config = function()
      require('config-local').setup {
        lookup_parents = true,
        config_files = { ".vimrc.lua" }
      }
    end
  },
  -- Show scrollbar
  {
    "petertriho/nvim-scrollbar", after = { "nvim-hlslens" }, config = function()
      require("scrollbar").setup()
      require("scrollbar.handlers.search").setup()
      lvim.builtin.which_key.mappings["h"] = { [[<Cmd>nohlsearch<CR><Cmd>lua require('scrollbar_ext').hide_search_results()<CR>]], "No Highlight" }
    end
  },
  -- Apply .editorconfig
  { "gpanders/editorconfig.nvim" },
  -- Expand .(repeat)/u(undo) funcionality to several plugins
  { "tpope/vim-repeat" },
  -- Provide customizable sidebar
  {
    "sidebar-nvim/sidebar.nvim",
    event = "BufEnter",
    config = function()
      require "sidebar-nvim".setup {
        open = true,
        side = "right",
        sections = { "git", "diagnostics", "todos", "containers", "buffers", "files", "symbols" }
      }
    end,
    disable = true,
  },
  -- Provide UI that shows status of LSP at the bottom right
  { 'j-hui/fidget.nvim', config = function() require('fidget').setup() end },
  -- Colorize indentation depth
  {
    "lukas-reineke/indent-blankline.nvim", config = function()
      vim.opt.termguicolors = true
      vim.cmd [[highlight IndentBlanklineIndent1 guibg=#24283b gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent2 guibg=#1f2335 gui=nocombine]]
      require("indent_blankline").setup {
        char = "",
        char_highlight_list = {
          "IndentBlanklineIndent1",
          "IndentBlanklineIndent2",
        },
        space_char_highlight_list = {
          "IndentBlanklineIndent1",
          "IndentBlanklineIndent2",
        },
        show_trailing_blankline_indent = false,
      }
    end
  },
  -- Provide Telescope ghq
  { "nvim-telescope/telescope-ghq.nvim", config = function() require 'telescope'.load_extension 'ghq' end },
}
