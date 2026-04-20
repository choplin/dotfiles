-- [Misc] TODO/FIXME/HACK comment highlighting and navigation.
--
--   ]t / [t            next/prev todo
--   <leader>xt         todo in Trouble
--   <leader>xT         todo/fix/fixme in Trouble
return {
  "todo-comments.nvim",
  src = "https://github.com/folke/todo-comments.nvim",
  event = "User LazyFile",
  cmd = { "TodoTrouble" },
  keys = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
    { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
    { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
  },
  after = function()
    require("todo-comments").setup()
  end,
}
