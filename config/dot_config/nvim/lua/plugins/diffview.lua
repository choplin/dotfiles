-- [Git] Git diff viewer and file history browser.
--
--   <leader>gD         diffview open
--   <leader>gH         file history
--   :DiffviewOpen      open diffview
--   :DiffviewFileHistory  open file history
return {
  "diffview.nvim",
  src = "https://github.com/sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  keys = {
    { "<leader>gD", function() require("diffview").open() end, desc = "Diffview Open" },
    { "<leader>gH", function() require("diffview").file_history() end, desc = "Diffview File History" },
  },
  after = function()
    require("diffview").setup()
  end,
}
