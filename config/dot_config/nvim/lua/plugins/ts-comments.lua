return {
  "ts-comments.nvim",
  src = "https://github.com/folke/ts-comments.nvim",
  event = "DeferredUIEnter",
  after = function()
    require("ts-comments").setup()
  end,
}
