return {
  -- Provide substitute operator
  {
    "gbprod/substitute.nvim",
    dependencies = {
      "gbprod/yanky.nvim",
    },
    keys = {
      {
        "p",
        function()
          require("substitute").visual()
        end,
        mode = "x",
      },
    },
    opts = function()
      return {
        on_substitute = function(event)
          require("yanky").init_ring("p", event.register, event.count, event.vmode:match("[vV�]"))
        end,
      }
    end,
  },
}
