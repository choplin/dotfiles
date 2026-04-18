return {
  "git-conflict.nvim",
  src = "https://github.com/akinsho/git-conflict.nvim",
  event = "User LazyFile",
  after = function()
    require("git-conflict").setup({
      default_mappings = false,
    })
  end,
}
