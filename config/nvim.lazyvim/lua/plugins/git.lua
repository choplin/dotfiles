return {
  -- Provide Github utility commands :Octo
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "Octo" },
    opts = {},
  },
  -- Provide better conflict UI and commands for resolving it
  {
    "akinsho/git-conflict.nvim",
    opts = {},
  },
  -- Provide fancy UI of git commit
  { "rhysd/committia.vim" },
  -- Automatically show diff in interactive git rebase window
  { "hotwatermorning/auto-git-diff" },
  -- Provide :Neogit, which
  {
    "TimUntersberger/neogit",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    keys = {
      {
        "<leader>G",
        function()
          require("neogit").open()
        end,
        desc = "Neogit",
      },
    },
    opts = {
      kind = "vsplit",
      integrations = { diffview = true },
    },
  },
  -- :DiffviewOpen, :DiffviewFileHistory provides neat diff UI
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      {
        "<leader>gD",
        function()
          local lazy = require("diffview.lazy")
          lazy.require("diffview").open()
        end,
        desc = "DiffviewOpen",
      },
      {
        "<leader>gH",
        function()
          local lazy = require("diffview.lazy")
          lazy.require("diffview").file_history()
        end,
        desc = "DiffviewFileHistory",
      },
    },
  },
}
