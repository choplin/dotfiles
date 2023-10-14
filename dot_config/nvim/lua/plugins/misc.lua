return {
  -- Override LazyVim
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        require("catppuccin").setup({
          dim_inactive = {
            enabled = true,
          },
        })
        require("palette").setup_catpuccin()
        vim.cmd.colorscheme("catppuccin")
      end,
      icons = {
        custom = {
          Tree = "",
          Copilot = "",
        },
      },
    },
  },
  -- Tracking coding activities
  { "wakatime/vim-wakatime", event = "VeryLazy" },
}
