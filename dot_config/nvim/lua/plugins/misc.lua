return {
  -- Override LazyVim
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
      icons = {
        custom = {
          Tree = "",
          Copilot = "",
        },
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      dim_inactive = true,
    },
    init = function()
      require("palette").setup_tokyonight()
    end,
  },
  -- Tracking coding activities
  { "wakatime/vim-wakatime", event = "VeryLazy" },
}
