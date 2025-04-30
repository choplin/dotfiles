-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

if vim.g.vscode then
  require("config/vscode/keymaps")
  return
end

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

-- emacs-like bindings for command line
vim.keymap.set("c", "<C-a>", "<C-b>", {})
vim.keymap.set("c", "<C-b>", "<Left>", {})
vim.keymap.set("c", "<C-f>", "<Right>", {})
vim.keymap.set("c", "<C-d>", "<Del>", {})

-- Moving between tabs
vim.keymap.set("n", "<leader><tab>j", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>k", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Broot
local open_broot = function()
  Snacks.terminal.open({ "broot" }, { env = { EDITOR = "nvr -l" } })
end
vim.api.nvim_create_user_command("Broot", open_broot, {})
vim.keymap.set("n", "<leader>F", open_broot, { desc = "Broot" })

-- GitFileHistory
vim.api.nvim_create_user_command("GitFileHistory", function()
  local name = vim.api.nvim_buf_get_name(0)
  Snacks.terminal.open({ "tig", name }, {})
end, {})
