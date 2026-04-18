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

-- Scan plugin specs and separate remote (src) vs local (dir) plugins
local function load_plugin_specs()
  local specs_dir = vim.fn.stdpath("config") .. "/lua/plugins"
  local sources = {}
  local local_plugins = {}

  for _, file in ipairs(vim.fn.glob(specs_dir .. "/*.lua", false, true)) do
    local ok, mod = pcall(dofile, file)
    if not ok then
      vim.notify("Failed to load plugin spec: " .. file .. "\n" .. tostring(mod), vim.log.levels.ERROR)
    elseif type(mod) == "table" then
      if mod.dir then
        -- Local plugin: load directly, skip vim.pack and lz.n
        table.insert(local_plugins, mod)
      elseif mod.src then
        local entry = { src = mod.src }
        if mod.version then entry.version = mod.version end
        table.insert(sources, entry)
      end
      if mod.deps then
        for _, dep in ipairs(mod.deps) do
          if type(dep) == "table" and dep.src then
            table.insert(sources, dep)
          end
        end
      end
    end
  end

  -- Install remote plugins via vim.pack
  if #sources > 0 then
    vim.pack.add(sources)
  end

  return local_plugins
end

local local_plugins = load_plugin_specs()

-- Load remote plugins via lz.n (skips specs with dir field)
require("lz.n").load("plugins")

-- Load local plugins (dir-based, not in packpath)
for _, spec in ipairs(local_plugins) do
  if vim.uv.fs_stat(spec.dir) then
    vim.opt.rtp:prepend(spec.dir)
    if spec.after then
      spec.after()
    end
  end
end

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
