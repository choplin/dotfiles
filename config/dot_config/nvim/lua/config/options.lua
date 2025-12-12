-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

if vim.g.vscode then
  require("config/vscode/options")
  return
end

local opt = vim.opt
opt.listchars:remove("tab")
opt.listchars:append("tab:￫ ")
opt.listchars:append("extends:»")
opt.listchars:append("precedes:«")
opt.listchars:append("space:⋅")
opt.listchars:append("eol:↴")
opt.timeoutlen = 250
opt.guifont = "HackGen35 Console NFJ:h18"
opt.spell = false
opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.conceallevel = 0

if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = false
end

vim.filetype.add({
  extension = {
    ["h"] = "c",
    ["mdx"] = "markdown",
  },
  filename = {
    ["Tiltfile"] = "tiltfile",
  },
})

vim.lsp.set_log_level("off")

-- Disable UI animation by Snacks
vim.g.snacks_animate = false
-- Do not handle Copilot suggestion by blink.cmp
vim.g.ai_cmp = false
