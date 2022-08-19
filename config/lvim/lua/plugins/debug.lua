return {
  -- neotest provides funcy test interfaces
  {
    "nvim-neotest/neotest",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-plenary",
      "nvim-neotest/neotest-vim-test",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-go",
    },
    config = function() require("neotest").setup({
        adapters = {
          require("neotest-go"),
          require("neotest-python")({
            dap = { justMyCode = false },
          }),
          require("neotest-plenary"),
          require("neotest-vim-test")({
            ignore_file_types = { "python", "vim", "lua", "go" },
          }),
        }
      })
    end,
  },
  -- Provide UI for nvim-dap
  {
    "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" }, config = function()
      require("dapui").setup()
      lvim.builtin.which_key.mappings["dU"] = {
        function() require("dapui").toggle() end,
        "Toggle UI"
      }
    end
  },
  -- Provide settings for Go delve
  {
    "leoluz/nvim-dap-go", requires = { "mfussenegger/nvim-dap" }, config = function()
      require("dap-go").setup()
    end
  },
  -- { "theHamsta/nvim-dap-virtual-text" },
  { "vim-test/vim-test" },
}
