return {
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      dim_inactive = true,
    },
    init = function()
      require("palette").setup_tokyonight()
    end,
  },
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      dim = {
        animate = {
          enabled = false,
        },
      },
      ---@type table<string, snacks.win.Config>
      styles = {
        lazygit = {
          width = 0.99,
          height = 0.99,
        },
      },
    },
  },
}
