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
  -- gitlinker generates a file permalink
  {
    "ruifm/gitlinker.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      {
        "<leader>gy",
        function()
          require("gitlinker").get_buf_range_url("n")
        end,
        desc = "Yank git",
      },
      {
        "<leader>gy",
        function()
          require("gitlinker").get_buf_range_url("v")
        end,
        mode = "v",
        desc = "Yank git",
      },
      {
        "<leader>gb",
        function()
          require("gitlinker").get_buf_range_url(
            "n",
            { action_callback = require("gitlinker.actions").open_in_browser }
          )
        end,
        desc = "Open in browser",
      },
      {
        "<leader>gb",
        function()
          require("gitlinker").get_buf_range_url(
            "v",
            { action_callback = require("gitlinker.actions").open_in_browser }
          )
        end,
        mode = "v",
        desc = "Open in browser",
      },
    },
    opts = {
      mappings = nil,
    },
  },
  -- Provide :Git command
  {
    "dinhhuy258/git.nvim",
    cmd = { "Git", "GitBlame", "GitDiff", "GitCreatePullRequest", "GitRevert", "GitRevertFile" },
    opts = {
      default_mappings = false,
    },
  },
}
