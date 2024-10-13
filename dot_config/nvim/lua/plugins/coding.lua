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
  -- copilot
  {
    "zbirenbaum/copilot.lua",
    opts = {
      panel = {
        enabled = true,
        auto_refresh = true,
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<Tab>",
        },
      },
    },
    config = function(_, opts)
      require("copilot").setup(opts)
      local ok, cmp = pcall(require, "cmp")
      if ok then
        cmp.event:on("menu_opened", function()
          vim.b.copilot_suggestion_hidden = true
        end)

        cmp.event:on("menu_closed", function()
          vim.b.copilot_suggestion_hidden = false
        end)
      end
    end,
  },
}
