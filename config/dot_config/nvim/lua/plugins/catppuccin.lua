-- [UI] Catppuccin color scheme (lazy via colorscheme trigger).
return {
  "catppuccin",
  src = "https://github.com/catppuccin/nvim",
  name = "catppuccin",
  colorscheme = {
    "catppuccin",
    "catppuccin-latte",
    "catppuccin-frappe",
    "catppuccin-macchiato",
    "catppuccin-mocha",
  },
  after = function()
    require("catppuccin").setup({
      flavour = "mocha",
      transparent_background = true,
      dim_inactive = { enabled = true },
      integrations = {
        blink_cmp = true,
        gitsigns = true,
        markdown = true,
        mini = { enabled = true },
        native_lsp = { enabled = true },
        noice = true,
        notify = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    })
    require("lib.palette").watch_colorscheme()
  end,
}
