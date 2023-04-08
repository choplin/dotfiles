-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "*", function()
  vim.cmd("normal! *")
  local res = vim.fn.searchcount()
  if res.total > 1 then
    vim.cmd("normal! N")
  end
end, { silent = true })

vim.keymap.set("n", "#", function()
  vim.cmd("normal! #")
  local res = vim.fn.searchcount()
  if res.total > 1 then
    vim.cmd("normal! N")
  end
end, { silent = true })
