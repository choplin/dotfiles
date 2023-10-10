return {
  -- neotest provides fancy test interfaces
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/neotest-plenary",
      -- A Vim wrapper for running tests on different granularities. (used via neotest)
      "nvim-neotest/neotest-vim-test",
      "vim-test/vim-test",
    },
    opts = {
      adapters = {
        ["neotest-plenary"] = {},
        ["neotest-vim-test"] = {
          ignore_file_types = { "python", "vim", "lua", "go", "rust" },
        },
      },
    },
  },
  -- Debug Adapter Protocol client
  {
    "mfussenegger/nvim-dap",
    init = function()
      require("lazyvim.util").on_very_lazy(function()
        local icons = require("lazyvim.config").icons
        vim.fn.sign_define("DapBreakpoint", {
          text = icons.custom.Bug,
          texthl = "DiagnosticSignError",
        })
        vim.fn.sign_define("DapBreakpointRejected", {
          text = icons.custom.Bug,
          texthl = "DiagnosticSignError",
        })
        vim.fn.sign_define("DapStopped", {
          text = icons.custom.BoldArrowRight,
          texthl = "DiagnosticSignWarn",
          linehl = "Visual",
          numhl = "DiagnosticSignWarn",
        })
      end)
    end,
  },
}
