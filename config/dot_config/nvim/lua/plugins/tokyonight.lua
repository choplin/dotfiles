return {
  "tokyonight.nvim",
  src = "https://github.com/folke/tokyonight.nvim",
  colorscheme = "tokyonight",
  after = function()
    require("tokyonight").setup({
      style = "moon",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      dim_inactive = true,
    })
    require("lib.palette").setup_tokyonight()
  end,
}
