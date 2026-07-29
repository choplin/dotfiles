-- [Misc] Enhanced quickfix list with preview and filtering.
return {
  "nvim-bqf",
  src = "https://github.com/kevinhwang91/nvim-bqf",
  deps = {
    { src = "https://github.com/junegunn/fzf", name = "fzf" },
  },
  ft = "qf",
  before = function()
    vim.cmd.packadd("fzf")
  end,
  after = function()
    require("bqf").setup({
      preview = {
        win_height = 32,
      },
    })
  end,
}
