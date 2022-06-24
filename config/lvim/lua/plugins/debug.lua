return {
  -- neotest provides funcy test interfaces
  {
    "nvim-neotest/neotest",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim"
    }
  }
  -- Provide UI for nvim-dap
  { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } },
  -- { "theHamsta/nvim-dap-virtual-text" },
}
