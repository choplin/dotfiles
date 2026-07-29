-- Autocmds are loaded on DeferredUIEnter or immediately if a file was opened

-- VSCode support
if vim.g.vscode then
  require("config.vscode.autocmds")
  return
end

local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Highlight on yank (with custom timeout)
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({ timeout = 300 })
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].nvim_last_loc then
      return
    end
    vim.b[buf].nvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dap-float",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("man_unlisted"),
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
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

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

--------------------------------------------------------------------------------
-- User autocmds
--------------------------------------------------------------------------------

-- Close command window with q
vim.api.nvim_create_autocmd("CmdWinEnter", {
  group = augroup("close_cmd_win_with_q"),
  pattern = "[:/?=]",
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<Cmd>q<CR>", { buffer = event.buf, silent = true })
  end,
})

-- Close dap-repl with q
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("close_dap_repl_with_q"),
  pattern = "\\[dap-repl\\]",
  callback = function()
    vim.keymap.set("n", "q", "<Cmd>bdelete!<CR>", { buffer = true })
  end,
})

-- Close diffview with q
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("close_diffview_with_ctrl_q"),
  pattern = "diffview://*",
  callback = function()
    vim.keymap.set("n", "q", "<Cmd>DiffviewClose<CR>", { buffer = true })
  end,
})

-- Add Glow command for markdown files (Snacks-dependent)
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("glow_command"),
  pattern = "*.md",
  callback = function()
    vim.api.nvim_buf_create_user_command(0, "Glow", function()
      if package.loaded.snacks then
        local name = vim.api.nvim_buf_get_name(0)
        Snacks.terminal.open({ "glow", "-p", name }, {})
      else
        vim.notify("Snacks not loaded", vim.log.levels.WARN)
      end
    end, {})
  end,
})

-- Detach LSP from diffview panels
vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup("detach_lsp_from_diffview"),
  callback = function(ev)
    local ft = vim.bo[ev.buf].filetype
    if ft == "DiffviewFiles" or ft == "DiffviewFilePanel" or ft == "DiffviewFileHistoryPanel" then
      vim.lsp.buf_detach_client(ev.buf, ev.data.client_id)
    end
  end,
})
