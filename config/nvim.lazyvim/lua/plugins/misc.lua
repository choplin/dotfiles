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
        vim.cmd.colorscheme("catppuccin")
      end,
    },
  },
  -- Tracking coding activities
  { "wakatime/vim-wakatime", event = "VeryLazy" },
}
