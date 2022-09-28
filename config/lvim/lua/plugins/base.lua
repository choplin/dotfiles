return {
  -- Highlight Todo: comments
  {
    "folke/todo-comments.nvim",
    config = function()
      require("todo-comments").setup()
    end,
  },
  -- Load a local .vimrc.lua file
  {
    "klen/nvim-config-local",
    config = function()
      require("config-local").setup {
        lookup_parents = true,
        config_files = { ".vimrc.lua" },
      }
    end,
  },
  -- Show scrollbar
  {
    "petertriho/nvim-scrollbar",
    after = { "nvim-hlslens" },
    config = function()
      require("scrollbar").setup()
      require("scrollbar.handlers.search").setup()
      vim.keymap.set("n", "<Esc>", function()
        require("scrollbar_ext").hide_search_results()
        vim.cmd "nohlsearch"
      end, {})
    end,
  },
  -- Apply .editorconfig
  { "gpanders/editorconfig.nvim" },
  -- Expand .(repeat)/u(undo) funcionality to several plugins
  { "tpope/vim-repeat" },
  -- Provide UI that shows status of LSP at the bottom right
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end,
  },
  -- Provide Telescope ghq
  { "nvim-telescope/telescope-ghq.nvim" },
  -- Provide Telescope frecency
  {
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      lvim.builtin.which_key.mappings["sf"] = {
        function()
          require("telescope").extensions.frecency.frecency { workspace = "CWD" }
        end,
        "Frecency Current Directory",
      }
      lvim.builtin.which_key.mappings["sF"] = {
        function()
          require("telescope").extensions.frecency.frecency()
        end,
        "Frecency Global",
      }
    end,
    requires = { "kkharji/sqlite.lua" },
  },
  -- Provide Telescope symbols
  { "nvim-telescope/telescope-symbols.nvim" },
  -- Tracking coding activities
  { "wakatime/vim-wakatime" },
}
