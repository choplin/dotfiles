return {
  -- Enable per-tab buffers
  {
    "tiagovla/scope.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  -- Better Quickfix UI
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    dependencies = {
      "junegunn/fzf",
      "gabrielpoca/replacer.nvim",
    },
    opts = {
      preview = {
        win_height = 32,
      },
    },
  },
  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true,
      },
    },
  },
}
