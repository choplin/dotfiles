-- Git conflict: git-conflict.nvim
-- Provide better conflict UI and commands for resolving it

return {
  -- git-conflict.nvim
  {
    "akinsho/git-conflict.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      default_mappings = false,
    },
  },

  -- committia.vim: Provide fancy UI of git commit
  { "rhysd/committia.vim", event = { "BufReadPre" } },

  -- auto-git-diff: Automatically show diff in interactive git rebase window
  { "hotwatermorning/auto-git-diff", event = { "BufReadPost", "BufNewFile" } },
}
