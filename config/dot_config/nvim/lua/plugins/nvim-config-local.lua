-- [Misc] Per-project Neovim configuration loader (.nvim.lua).
return {
  "nvim-config-local",
  src = "https://github.com/klen/nvim-config-local",
  lazy = false,
  after = function()
    require("config-local").setup()
  end,
}
