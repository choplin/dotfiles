return {
  "overseer.nvim",
  src = "https://github.com/stevearc/overseer.nvim",
  cmd = { "OverseerOpen", "OverseerClose", "OverseerToggle", "OverseerRun", "OverseerTaskAction" },
  keys = {
    { "<leader>ow", "<cmd>OverseerToggle!<cr>", desc = "Task list" },
    { "<leader>oo", "<cmd>OverseerRun<cr>", desc = "Run task" },
    { "<leader>ot", "<cmd>OverseerTaskAction<cr>", desc = "Task action" },
  },
  after = function()
    require("overseer").setup({
      dap = false,
      task_list = {
        keymaps = {
          ["<C-j>"] = false,
          ["<C-k>"] = false,
        },
      },
      form = { win_opts = { winblend = 0 } },
      task_win = { win_opts = { winblend = 0 } },
    })
  end,
}
