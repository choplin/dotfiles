return {
  "marks.nvim",
  src = "https://github.com/chentoast/marks.nvim",
  event = "User LazyFile",
  after = function()
    require("marks").setup({})
  end,
}
