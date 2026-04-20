-- [Nav] Visual indicators for vim marks in the sign column.
return {
  "marks.nvim",
  src = "https://github.com/chentoast/marks.nvim",
  event = "User LazyFile",
  after = function()
    require("marks").setup({})
  end,
}
