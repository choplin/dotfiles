return {
  "todo-comments.nvim",
  event = "LazyFile",
  cmd = { "TodoTrouble" },
  after = function()
    require("todo-comments").setup()

    local map = vim.keymap.set
    map("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next Todo Comment" })
    map("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous Todo Comment" })
    map("n", "<leader>xt", "<cmd>Trouble todo toggle<cr>", { desc = "Todo (Trouble)" })
    map("n", "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", { desc = "Todo/Fix/Fixme (Trouble)" })
  end,
}
