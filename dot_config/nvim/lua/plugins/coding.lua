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
    opts = {},
  },
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
  -- Expand <C-a> funcionality
  {
    "monaqa/dial.nvim",
    keys = { { "<c-a>" }, { "<c-x>" }, { "g<c-a>" }, { "g<c-a>" } },
    config = function()
      vim.keymap.set({ "n", "v" }, "<c-a>", require("dial.map").inc_normal())
      vim.keymap.set({ "n", "v" }, "<c-x>", require("dial.map").dec_normal())
      vim.keymap.set("v", "g<c-a>", require("dial.map").inc_gvisual())
      vim.keymap.set("v", "g<c-x>", require("dial.map").dec_gvisual())
    end,
  },
  -- copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = { "InsertEnter", "CmdlineEnter" },
    build = ":Copilot auth",
    opts = {
      panel = {
        enabled = true,
        auto_refresh = true,
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<c-f>",
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
