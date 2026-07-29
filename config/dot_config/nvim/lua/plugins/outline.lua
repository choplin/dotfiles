-- [Nav] Code outline / document symbols sidebar.
--
--   <leader>cs         toggle outline
--   :Outline           open outline
return {
  "outline.nvim",
  src = "https://github.com/hedyhli/outline.nvim",
  cmd = "Outline",
  keys = {
    { "<leader>cs", "<cmd>Outline<cr>", desc = "Toggle Outline" },
  },
  after = function()
    require("outline").setup({
      keymaps = {
        up_and_jump = "<up>",
        down_and_jump = "<down>",
      },
    })
  end,
}
