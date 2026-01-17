-- nvim-ufo - modern folding with high performance
return {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async",
  },
  opts = {},
  keys = {
    {
      "zR",
      function()
        require("ufo").openAllFolds()
      end,
      mode = { "n" },
      desc = "Open all folds",
    },
    {
      "zM",
      function()
        require("ufo").closeAllFolds()
      end,
      mode = { "n" },
      desc = "Close all folds",
    },
  },
}
