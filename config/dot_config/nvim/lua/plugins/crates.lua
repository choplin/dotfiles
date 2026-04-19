return {
  "crates.nvim",
  src = "https://github.com/Saecki/crates.nvim",
  event = "BufRead Cargo.toml",
  after = function()
    require("crates").setup({
      completion = { crates = { enabled = true } },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    })
  end,
}
