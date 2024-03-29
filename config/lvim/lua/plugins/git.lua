return {
  -- Provide Github utility commands
  -- :Octo
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("octo").setup()
    end,
  },
  -- Provide better conflict UI and commands for resolving it
  {
    "akinsho/git-conflict.nvim",
    config = function()
      require("git-conflict").setup()
    end,
  },
  -- Provide fancy UI of git commit
  { "rhysd/committia.vim" },
  -- Automatically show diff in interactive git rebase window
  { "hotwatermorning/auto-git-diff" },
  -- Provide :Neogit, which
  {
    "TimUntersberger/neogit",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    config = function()
      require("neogit").setup {
        kind = "vsplit",
        integrations = { diffview = true },
      }
      lvim.builtin.which_key.mappings["G"] = {
        function()
          require("neogit").open()
        end,
        "Neogit",
      }
    end,
  },
  -- :DiffviewOpen, :DiffviewFileHistory provides neat diff UI
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      local lazy = require "diffview.lazy"
      local diffview = lazy.require "diffview"

      lvim.builtin.which_key.mappings["gD"] = {
        function()
          diffview.open()
        end,
        "DiffviewOpen",
      }
      lvim.builtin.which_key.mappings["gH"] = {
        function()
          diffview.file_history()
        end,
        "DiffviewFileHistory",
      }
    end,
  },
  -- gitlinker generates a file permalink
  {
    "ruifm/gitlinker.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("gitlinker").setup()
    end,
  },
  {
    'dinhhuy258/git.nvim',
    config = function()
      require('git').setup()
    end
  }
}
