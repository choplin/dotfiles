-- [LSP] Per-project LSP configuration via .neoconf.json.
--
--   :Neoconf            open project LSP config
return {
  "neoconf.nvim",
  src = "https://github.com/folke/neoconf.nvim",
  cmd = "Neoconf",
  after = function()
    require("neoconf").setup({})
  end,
}
