-- Leader keys (must be set before any keymap)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Load options first (before plugins)
require("config.options")

-- Bootstrap lz.n
local lzn_path = vim.fn.stdpath("data") .. "/site/pack/core/opt/lz.n"
if not vim.uv.fs_stat(lzn_path) then
  vim.fn.mkdir(vim.fn.fnamemodify(lzn_path, ":h"), "p")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/nvim-neorocks/lz.n.git",
    lzn_path,
  })
end
vim.cmd.packadd("lz.n")

-- Load all plugins (remote via vim.pack + lz.n, local via lib.plugin_loader)
require("lib.plugin_loader").setup()

-- LazyFile custom event (replaces lazy.nvim's LazyFile)
-- Groups BufReadPost, BufNewFile, BufWritePre into a single event
local lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }
local Event = {} ---@type table<string, true>

local function lazy_file()
  local events = {} ---@type {event: string, buf: number, data?: any}[]

  local done = false
  local function load()
    if done then
      return
    end
    done = true
    vim.api.nvim_del_augroup_by_name("lazy_file")

    ---@type table<string, string[]>
    local skips = {}
    for _, event in ipairs(events) do
      skips[event.event] = skips[event.event] or {}
      table.insert(skips[event.event], event.buf)
    end

    vim.api.nvim_exec_autocmds("User", { pattern = "LazyFile", modeline = false })
    for _, event in ipairs(events) do
      if vim.api.nvim_buf_is_valid(event.buf) then
        Event[event.event] = true
        vim.api.nvim_exec_autocmds(event.event, { buffer = event.buf, data = event.data })
      end
    end
    vim.api.nvim_exec_autocmds("CursorMoved", { modeline = false })
  end

  local group = vim.api.nvim_create_augroup("lazy_file", { clear = true })
  for _, event in ipairs(lazy_file_events) do
    vim.api.nvim_create_autocmd(event, {
      group = group,
      callback = function(ev)
        table.insert(events, ev)
        load()
      end,
    })
  end
end

lazy_file()

-- Colorscheme (lz.n loads tokyonight via colorscheme trigger)
vim.cmd.colorscheme("tokyonight")

-- Deferred loading: autocmds and keymaps
-- Load autocmds immediately if a file was opened, otherwise defer
local lazy_autocmds = vim.fn.argc(-1) == 0
if not lazy_autocmds then
  require("config.autocmds")
end

vim.api.nvim_create_autocmd("User", {
  pattern = "DeferredUIEnter",
  once = true,
  callback = function()
    if lazy_autocmds then
      require("config.autocmds")
    end
    require("config.keymaps")
  end,
})
