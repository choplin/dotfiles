-- [Treesitter] Show enclosing scope context as virtual text.
return {
  "nvim_context_vt",
  src = "https://github.com/haringsrob/nvim_context_vt",
  event = "User LazyFile",
  after = function()
    require("nvim_context_vt").setup({})
  end,
}
