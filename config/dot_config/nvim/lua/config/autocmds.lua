-- Autocmds are automatically loaded on the VeryLazy event
-- Add any additional autocmds here

if vim.g.vscode then
  require("user.vscode.autocmds")
  return
end

local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- Highlight on yank (override default with custom timeout)
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({ timeout = 300 })
  end,
})

vim.api.nvim_create_autocmd("CmdWinEnter", {
  group = augroup("close_cmd_win_with_q"),
  pattern = "[:/?=]",
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<Cmd>q<CR>", { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("close_dap_repl_with_q"),
  pattern = "\\[dap-repl\\]",
  callback = function()
    vim.keymap.set("n", "q", "<Cmd>bdelete!<CR>", { buffer = true })
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("close_diffview_with_ctrl_q"),
  pattern = "diffview://*",
  callback = function()
    vim.keymap.set("n", "q", "<Cmd>DiffviewClose<CR>", { buffer = true })
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("glow_command"),
  pattern = "*.md",
  callback = function()
    vim.api.nvim_buf_create_user_command(0, "Glow", function()
      local name = vim.api.nvim_buf_get_name(0)
      Snacks.terminal.open({ "glow", "-p", name }, {})
    end, {})
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup("detach_lsp_from_diffview"),
  callback = function(ev)
    local ft = vim.bo[ev.buf].filetype
    if ft == "DiffviewFiles" or ft == "DiffviewFilePanel" or ft == "DiffviewFileHistoryPanel" then
      vim.lsp.buf_detach_client(ev.buf, ev.data.client_id)
    end
  end,
})

-- wrap and disable spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = false
  end,
})
