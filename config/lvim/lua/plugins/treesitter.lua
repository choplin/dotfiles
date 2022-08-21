return {
  -- Show current context at statusbar
  {
    "SmiteshP/nvim-gps",
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      local gps = require "nvim-gps"
      gps.setup()

      local components = require "lvim.core.lualine.components"
      lvim.builtin.lualine.sections.lualine_c = { components.diff, { gps.get_location, cond = gps.is_available } }
    end,
  },
  -- Show current context at the top of the windows as virtual text
  {
    "lewis6991/nvim-treesitter-context",
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("treesitter-context").setup()
    end,
  },
  -- Show current context at the closed brackets
  { "haringsrob/nvim_context_vt" },
  -- Automatically close html tag
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
    ft = {
      "html",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
      "tsx",
      "jsx",
      "rescript",
      "xml",
    },
  },
  -- Highlight, navigate, operate on the matching text
  {
    "andymass/vim-matchup",
    config = function()
      require("nvim-treesitter.configs").setup { matchup = { enable = true } }
    end,
  },
  -- Improve indentation
  {
    "yioneko/nvim-yati",
    evnet = "InsertEnter",
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup { yati = { enable = true } }
    end,
  },
  -- Provide treesitter based text object with text hint
  {
    "mfussenegger/nvim-ts-hint-textobject",
    config = function()
      vim.keymap.set("o", "m", require("tsht").nodes, { silent = true })
      vim.keymap.set("v", "m", ":lua require('tsht').nodes()<CR>", { silent = true })
    end,
  },
  -- Provide treesitter based text object that can be expanded incrementally
  {
    "RRethy/nvim-treesitter-textsubjects",
    config = function()
      lvim.builtin.treesitter.textsubjects = {}
      require("nvim-treesitter.configs").setup {
        textsubjects = {
          enable = true,
          prev_selection = ",",
          keymaps = {
            ["."] = "textsubjects-smart",
            [";"] = "textsubjects-container-outer",
            ["i;"] = "textsubjects-container-inner",
          },
        },
      }
    end,
  },
}
