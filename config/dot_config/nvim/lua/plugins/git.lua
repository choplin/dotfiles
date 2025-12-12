return {
  -- Provide better conflict UI and commands for resolving it
  {
    "akinsho/git-conflict.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      default_mappings = false,
    },
  },
  -- Provide fancy UI of git commit
  { "rhysd/committia.vim", event = { "BufReadPre" } },
  -- Automatically show diff in interactive git rebase window
  { "hotwatermorning/auto-git-diff", event = { "BufReadPost", "BufNewFile" } },
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
