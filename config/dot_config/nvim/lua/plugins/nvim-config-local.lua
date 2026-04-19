return {
  "nvim-config-local",
  src = "https://github.com/klen/nvim-config-local",
  lazy = false,
  after = function()
    require("config-local").setup()
  end,
}
