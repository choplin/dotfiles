-- Plugin loader: scans lua/plugins/*.lua specs, installs remote plugins
-- via vim.pack, and loads local (dir-based) plugins directly.

local M = {}

--- Scan plugin specs and install/load all plugins.
--- Remote plugins (src) are installed via vim.pack and loaded via lz.n.
--- Local plugins (dir) are loaded directly with optional lazy triggers.
function M.setup()
  local specs_dir = vim.fn.stdpath("config") .. "/lua/plugins"
  local sources = {}
  local local_plugins = {}

  for _, file in ipairs(vim.fn.glob(specs_dir .. "/*.lua", false, true)) do
    local ok, mod = pcall(dofile, file)
    if not ok then
      vim.notify("Failed to load plugin spec: " .. file .. "\n" .. tostring(mod), vim.log.levels.ERROR)
    elseif type(mod) == "table" then
      if mod.dir then
        table.insert(local_plugins, mod)
      elseif mod.src then
        local entry = { src = mod.src }
        if mod.name then
          entry.name = mod.name
        end
        if mod.version then
          entry.version = mod.version
        end
        table.insert(sources, entry)
      end
      if mod.deps then
        for _, dep in ipairs(mod.deps) do
          if type(dep) == "table" and dep.src then
            local dep_entry = { src = dep.src }
            if dep.name then
              dep_entry.name = dep.name
            end
            if dep.version then
              dep_entry.version = dep.version
            end
            table.insert(sources, dep_entry)
          end
        end
      end
    end
  end

  -- Install/register remote plugins via vim.pack without putting them on
  -- runtimepath. Default load=false behaves like :packadd! and lets Neovim's
  -- later startup phase source plugin/* before lz.n triggers run.
  -- See: neovim/#35550 / lz.n vim.pack workaround.
  if #sources > 0 then
    vim.pack.add(sources, {
      load = function() end,
    })
  end

  -- lz.n owns :packadd for each plugin when its trigger (or eager load) fires
  require("lz.n").load("plugins")

  -- Load local plugins (dir-based, not in packpath)
  for _, spec in ipairs(local_plugins) do
    M._load_local(spec)
  end
end

--- Load a single local plugin spec.
---@param spec table Plugin spec with dir field
function M._load_local(spec)
  local dir = vim.fn.expand(spec.dir)
  if not vim.uv.fs_stat(dir) then
    return
  end

  local function load()
    vim.opt.rtp:prepend(dir)
    if spec.after then
      spec.after()
    end
  end

  if spec.ft then
    vim.api.nvim_create_autocmd("FileType", {
      pattern = spec.ft,
      once = true,
      callback = load,
    })
  else
    load()
  end
end

return M
