return {
  "scope.nvim",
  src = "https://github.com/tiagovla/scope.nvim",
  event = "User LazyFile",
  after = function()
    require("scope").setup({})
  end,
}
