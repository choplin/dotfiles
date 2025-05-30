local vscode = require("vscode")

-- Disable keymaps not working properly in VSCode
local keymap_to_del = {
  ["n"] = {
    -- Tab operations
    "<leader><tab><tab>",
    "<leader><tab>[",
    "<leader><tab>]",
    "<leader><tab>d",
    "<leader><tab>f",
    "<leader><tab>o",
    "<leader><tab>l",
    -- Terminal operations
    "<leader>ft",
    -- Buffer operations
    "<leader>bb",
    "<leader>bd",
    "<leader>bo",
    "<leader>bD",
    -- Git operations
    "<leader>gg",
    "<leader>gb",
  },
}

for mode, keymaps in pairs(keymap_to_del) do
  for _, keymap in ipairs(keymaps) do
    vim.keymap.del(mode, keymap)
  end
end

-- Stay where you are when using # or *
local search_key = { "*", "#" }
for _, key in ipairs(search_key) do
  vim.keymap.set("n", key, function()
    vim.cmd("normal! " .. key)
    local res = vim.fn.searchcount()
    if res.total > 1 then
      vim.cmd("normal! N")
    end
  end, { silent = true })
end

-- Add keymaps for VSCode

---@class VSCodeCommandOptions
---@field args? string[]
---@field range? table<integer, integer>|table<integer, string, integer, string>

---@alias VSCodeCommand
---| table<string, VSCodeCommandOptions?, boolean?>

---@alias VSCodeKeymap
---| table<string, string, VSCodeCommand, vim.keymap.set.Opts>

---@type VSCodeKeymap[]
local vscode_keymaps = {
  -- Cursor
  {
    "n",
    "j",
    { "cursorMove", { args = { to = "down", by = "wrappedLine", value = vim.v.count1 } }, true },
    { desc = "Move Cursor Down" },
  },
  {
    "n",
    "k",
    { "cursorMove", { args = { to = "up", by = "wrappedLine", value = vim.v.count1 } }, true },
    { desc = "Move Cursor Up" },
  },
  -- Fold
  { "n", "zc", { "editor.fold" }, { desc = "Fold" } },
  { "n", "zo", { "editor.unfold" }, { desc = "Unfold" } },
  { "n", "zM", { "editor.foldAll" }, { desc = "Fold All" } },
  { "n", "zR", { "editor.unfoldAll" }, { desc = "Unfold All" } },
  -- Terminal
  { "n", "<leader>ft", { "workbench.action.createTerminalEditorSameGroup" }, { desc = "Toggle Terminal" } },
  { "n", "<c-/>", { "workbench.action.terminal.toggleTerminal" }, { desc = "Toggle Terminal" } },
  -- Search
  { "n", "<leader>sg", { "workbench.action.findInFiles" }, { desc = "Search in Files" } },
  -- File explorer
  { "n", "<leader>e", { "workbench.files.action.focusFilesExplorer" }, { desc = "Focus Explorer" } },
  -- Source control
  { "n", "<leader>gg", { "workbench.scm.focus" }, { desc = "Focus Source Control" } },
}

for _, keymap in ipairs(vscode_keymaps) do
  ---@type string, string, VSCodeCommand, vim.keymap.set.Opts
  local mode, lhs, command, keymap_opts = unpack(keymap)
  ---@type string, VSCodeCommandOptions?, boolean?
  local id, opts, synchronous = unpack(command)
  if synchronous then
    vim.keymap.set(mode, lhs, function()
      return vscode.call(id, opts)
    end, keymap_opts)
  else
    vim.keymap.set(mode, lhs, function()
      return vscode.action(id, opts)
    end, keymap_opts)
  end
end
