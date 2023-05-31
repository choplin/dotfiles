return {
  -- neotest provides funcy test interfaces
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
  -- Add virtual text support to nvim-dap.
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = true,
    opts = {},
  },
  -- Fancy UI for nvim-dap
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    config = function()
      local dapui = require("dapui")
      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.33 },
              { id = "breakpoints", size = 0.17 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 0.33,
            position = "right",
          },
          {
            elements = {
              { id = "repl", size = 0.45 },
              { id = "console", size = 0.55 },
            },
            size = 0.27,
            position = "bottom",
          },
        },
      })
      -- Open dapui automatially when dubug starts
      require("dap").listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
    end,
  },
  -- Provide dap settings for Go with delve
  {
    "leoluz/nvim-dap-go",
    lazy = true,
    main = "dap-go",
    opts = {},
  },
  -- Provide dap settings for python with debugpy
  {
    "mfussenegger/nvim-dap-python",
    lazy = true,
    config = function()
      require("dap-python").setup("~/.venv/debugpy/bin/python")
    end,
  },
  -- Debug Adapter Protocol client
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
      "leoluz/nvim-dap-go",
      "mfussenegger/nvim-dap-python",
    },
    init = function()
      local ok, wk = pcall(require, "which-key")
      if ok then
        wk.register({
          mode = { "n", "v" },
          ["<leader>d"] = { name = "+debug" },
        })
      end

      local Util = require("lazyvim.util")
      Util.on_very_lazy(function()
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
    keys = {
      { "<leader>dt", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = "Toggle Breakpoint" },
      { "<leader>db", "<cmd>lua require'dap'.step_back()<cr>", desc = "Step Back" },
      { "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", desc = "Continue" },
      { "<leader>dC", "<cmd>lua require'dap'.run_to_cursor()<cr>", desc = "Run To Cursor" },
      { "<leader>dd", "<cmd>lua require'dap'.disconnect()<cr>", desc = "Disconnect" },
      { "<leader>dg", "<cmd>lua require'dap'.session()<cr>", desc = "Get Session" },
      { "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", desc = "Step Into" },
      { "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", desc = "Step Over" },
      { "<leader>du", "<cmd>lua require'dap'.step_out()<cr>", desc = "Step Out" },
      { "<leader>dp", "<cmd>lua require'dap'.pause()<cr>", desc = "Pause" },
      { "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", desc = "Toggle Repl" },
      { "<leader>ds", "<cmd>lua require'dap'.continue()<cr>", desc = "Start" },
      { "<leader>dq", "<cmd>lua require'dap'.close()<cr>", desc = "Quit" },
      { "<leader>dU", "<cmd>lua require'dapui'.toggle({reset = true})<cr>", desc = "Toggle UI" },
    },
  },
}
