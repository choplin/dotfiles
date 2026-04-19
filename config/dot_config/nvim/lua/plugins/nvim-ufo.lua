return {
  "nvim-ufo",
  src = "https://github.com/kevinhwang91/nvim-ufo",
  deps = {
    { src = "https://github.com/kevinhwang91/promise-async", name = "promise-async" },
  },
  keys = {
    { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
    { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
  },
  before = function()
    vim.cmd.packadd("promise-async")
  end,
  after = function()
    require("ufo").setup({})
  end,
}
