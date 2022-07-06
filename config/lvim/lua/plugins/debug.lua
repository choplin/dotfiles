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
  { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } },
  -- { "theHamsta/nvim-dap-virtual-text" },
}
