return {
  "lazydev.nvim",
  src = "https://github.com/folke/lazydev.nvim",
  ft = "lua",
  after = function()
    require("lazydev").setup({
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lz.n", words = { "lz%.n" } },
      },
    })
  end,
}
