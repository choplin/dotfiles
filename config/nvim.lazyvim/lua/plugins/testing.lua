return {
  -- neotest provides fancy test interfaces
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-plenary",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-go",
      "rouge8/neotest-rust",
      -- A Vim wrapper for running tests on different granularities. (used via neotest)
      "nvim-neotest/neotest-vim-test",
      "vim-test/vim-test",
    },
    keys = {
      {
        "<leader>tt",
        function()
          require("neotest").run.run()
        end,
        desc = "Run the nearest test",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run the current file",
      },
      {
        "<leader>td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Debug the nearest test",
      },
      {
        "<leader>tS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop the nearest test",
      },
      {
        "<leader>ta",
        function()
          require("neotest").run.attach()
        end,
        desc = "Attach the nearest test",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle the summary window",
      },
      {
        "]T",
        function()
          require("neotest").jump.prev({ status = "failed" })
        end,
        desc = "Next failed test",
      },
      {
        "[T",
        function()
          require("neotest").jump.next({ status = "failed" })
        end,
        desc = "Previous failed test",
      },
    },
    init = function()
      local ok, wk = pcall(require, "which-key")
      if ok then
        wk.register({
          mode = { "n", "v" },
          ["<leader>t"] = { name = "+test" },
        })
      end
    end,
    opts = function()
      return {
        adapters = {
          require("neotest-go"),
          require("neotest-python")({
            dap = { justMyCode = false },
          }),
          require("neotest-plenary"),
          require("neotest-vim-test")({
            ignore_file_types = { "python", "vim", "lua", "go" },
          }),
          require("neotest-rust"),
        },
      }
    end,
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
