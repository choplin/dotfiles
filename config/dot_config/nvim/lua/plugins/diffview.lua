-- Diff view: diffview.nvim
-- DiffviewOpen, DiffviewFileHistory provides neat diff UI

return {
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
