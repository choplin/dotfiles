-- Add config directory to runtimepath (required for --clean mode)
local config_path = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")
vim.opt.rtp:prepend(config_path)

-- Set leader keys before loading lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Bootstrap lazy.nvim and load plugins
require("config.lazy")
