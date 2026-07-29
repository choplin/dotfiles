-- Snacks picker keymaps and LSP integration
-- Called from snacks.lua after setup

local map = vim.keymap.set
local root = function()
  return require("lib.root").get()
end
local cwd = function()
  return require("lib.root").cwd()
end

-- Top-level
map("n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers" })
map("n", "<leader>/", function() Snacks.picker.grep({ cwd = root() }) end, { desc = "Grep (Root Dir)" })
map("n", "<leader>:", function() Snacks.picker.command_history() end, { desc = "Command History" })
map("n", "<leader><space>", function() Snacks.picker.files({ cwd = root() }) end, { desc = "Find Files (Root Dir)" })

-- find
map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
map("n", "<leader>fB", function() Snacks.picker.buffers({ hidden = true, nofile = true }) end, { desc = "Buffers (all)" })
map("n", "<leader>ff", function() Snacks.picker.files({ cwd = root() }) end, { desc = "Find Files (Root Dir)" })
map("n", "<leader>fF", function() Snacks.picker.files({ cwd = cwd() }) end, { desc = "Find Files (cwd)" })
map("n", "<leader>fg", function() Snacks.picker.git_files() end, { desc = "Find Files (git-files)" })
map("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent" })
map("n", "<leader>fR", function() Snacks.picker.recent({ filter = { cwd = true } }) end, { desc = "Recent (cwd)" })
map("n", "<leader>fp", function() Snacks.picker.projects() end, { desc = "Projects" })

-- git
map("n", "<leader>gd", function() Snacks.picker.git_diff() end, { desc = "Git Diff (hunks)" })
map("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Git Status" })
map("n", "<leader>gS", function() Snacks.picker.git_stash() end, { desc = "Git Stash" })

-- grep
map("n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer Lines" })
map("n", "<leader>sB", function() Snacks.picker.grep_buffers() end, { desc = "Grep Open Buffers" })
map("n", "<leader>sg", function() Snacks.picker.grep({ cwd = root() }) end, { desc = "Grep (Root Dir)" })
map("n", "<leader>sG", function() Snacks.picker.grep({ cwd = cwd() }) end, { desc = "Grep (cwd)" })
map({ "n", "x" }, "<leader>sw", function() Snacks.picker.grep_word({ cwd = root() }) end, { desc = "Visual selection or word" })

-- search
map("n", '<leader>s"', function() Snacks.picker.registers() end, { desc = "Registers" })
map("n", "<leader>s/", function() Snacks.picker.search_history() end, { desc = "Search History" })
map("n", "<leader>sa", function() Snacks.picker.autocmds() end, { desc = "Autocmds" })
map("n", "<leader>sc", function() Snacks.picker.command_history() end, { desc = "Command History" })
map("n", "<leader>sC", function() Snacks.picker.commands() end, { desc = "Commands" })
map("n", "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
map("n", "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer Diagnostics" })
map("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Help Pages" })
map("n", "<leader>sH", function() Snacks.picker.highlights() end, { desc = "Highlights" })
map("n", "<leader>si", function() Snacks.picker.icons() end, { desc = "Icons" })
map("n", "<leader>sj", function() Snacks.picker.jumps() end, { desc = "Jumps" })
map("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
map("n", "<leader>sl", function() Snacks.picker.loclist() end, { desc = "Location List" })
map("n", "<leader>sM", function() Snacks.picker.man() end, { desc = "Man Pages" })
map("n", "<leader>sm", function() Snacks.picker.marks() end, { desc = "Marks" })
map("n", "<leader>sR", function() Snacks.picker.resume() end, { desc = "Resume" })
map("n", "<leader>sq", function() Snacks.picker.qflist() end, { desc = "Quickfix List" })
map("n", "<leader>su", function() Snacks.picker.undo() end, { desc = "Undotree" })

-- lsp
map("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
map("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" })

-- todo
map("n", "<leader>st", function() Snacks.picker.todo_comments() end, { desc = "Todo" })
map("n", "<leader>sT", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, { desc = "Todo/Fix/Fixme" })

-- ui
map("n", "<leader>uC", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })

-- Override LSP navigation keymaps to use Snacks picker
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("snacks_picker_lsp", { clear = true }),
  callback = function(args)
    local buf = args.buf
    local bmap = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
    end
    bmap("gd", function() Snacks.picker.lsp_definitions() end, "Goto Definition")
    bmap("gr", function() Snacks.picker.lsp_references() end, "References")
    bmap("gI", function() Snacks.picker.lsp_implementations() end, "Goto Implementation")
    bmap("gy", function() Snacks.picker.lsp_type_definitions() end, "Goto Type Definition")
  end,
})
