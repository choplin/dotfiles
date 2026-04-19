return {
  "yazi.nvim",
  src = "https://github.com/mikavilpas/yazi.nvim",
  deps = {
    { src = "https://github.com/nvim-lua/plenary.nvim", name = "plenary.nvim" },
  },
  keys = {
    { "<leader>E", "<cmd>Yazi<cr>", mode = { "n", "v" }, desc = "Open yazi at the current file" },
    { "<leader>e", "<cmd>Yazi cwd<cr>", desc = "Open the file manager in nvim's working directory" },
    { "<c-up>", "<cmd>Yazi toggle<cr>", desc = "Resume the last yazi session" },
  },
  before = function()
    vim.g.loaded_netrwPlugin = 1
    vim.cmd.packadd("plenary.nvim")
  end,
  after = function()
    require("yazi").setup({
      open_for_directories = false,
      floating_window_scaling_factor = 1,
    })
  end,
}
