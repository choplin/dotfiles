return {
  "neoconf.nvim",
  src = "https://github.com/folke/neoconf.nvim",
  cmd = "Neoconf",
  after = function()
    require("neoconf").setup({})
  end,
}
