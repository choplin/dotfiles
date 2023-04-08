return {
  -- Provide yank ring
  {
    "gbprod/yanky.nvim",
    keys = {
      { "p", "<Plug>(YankyPutAfter)", { "n", "x" } },
      { "P", "<Plug>(YankyPutBefore)", { "n", "x" } },
      { "gp", "<Plug>(YankyGPutAfter)", { "n", "x" } },
      { "gP", "<Plug>(YankyGPutBefore)", { "n", "x" } },
      { "<c-n>", "<Plug>(YankyCycleForward)", "n" },
      { "<c-p>", "<Plug>(YankyCycleBackward)", "n" },
      { "y", "<Plug>(YankyYank)", { "n", "x" } },
    },
    config = function()
      require("yanky").setup()
    end,
  },
}
