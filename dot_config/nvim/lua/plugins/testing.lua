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
}
