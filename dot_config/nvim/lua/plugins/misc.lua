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
    opts = {
      dim = {
        animate = {
          enabled = false,
        },
      },
    },
  },
  -- Tracking coding activities
  { "wakatime/vim-wakatime", event = "VeryLazy" },
}
