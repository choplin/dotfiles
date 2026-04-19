return {
  "nvim-ts-autotag",
  src = "https://github.com/windwp/nvim-ts-autotag",
  event = "User LazyFile",
  after = function()
    require("nvim-ts-autotag").setup({})
  end,
}
