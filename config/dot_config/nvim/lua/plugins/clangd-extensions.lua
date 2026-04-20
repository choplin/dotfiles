-- [Lang] C/C++ LSP extensions for clangd (inlay hints, AST, etc.).
return {
  "clangd_extensions.nvim",
  src = "https://github.com/p00f/clangd_extensions.nvim",
  ft = { "c", "cpp", "objc", "objcpp" },
  after = function()
    require("clangd_extensions").setup({
      inlay_hints = { inline = false },
    })
  end,
}
