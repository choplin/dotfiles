-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

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

vim.filetype.add({
  extension = {
    ["h"] = "c",
  },
  filename = {
    ["Tiltfile"] = "tiltfile",
  },
})

vim.lsp.set_log_level("off")
