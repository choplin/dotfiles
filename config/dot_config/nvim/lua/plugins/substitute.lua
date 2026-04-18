return {
  "substitute.nvim",
  src = "https://github.com/gbprod/substitute.nvim",
  keys = {
    {
      "p",
      function() require("substitute").visual() end,
      mode = "x",
    },
  },
  after = function()
    require("substitute").setup({
      on_substitute = function(event)
        require("yanky").init_ring("p", event.register, event.count, event.vmode:match("[vV\22]"))
      end,
    })
  end,
}
