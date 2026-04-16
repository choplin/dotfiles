return {
  "mini.pairs",
  src = "https://github.com/echasnovski/mini.pairs",
  event = "DeferredUIEnter",
  after = function()
    require("mini.pairs").setup({
      modes = { insert = true, command = true, terminal = false },
    })
  end,
}
