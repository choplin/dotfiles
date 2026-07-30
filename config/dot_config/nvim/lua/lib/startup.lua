-- Framework-free startup timing for the dashboard (no lazy.nvim / lazy.stats).

local M = {}

local start_ns ---@type number?
local cached_ms ---@type number?

--- Mark the start of configuration startup. Call once at the top of init.lua.
function M.mark()
  start_ns = vim.uv.hrtime()
end

--- Milliseconds since mark(), rounded to 0.01 ms. Cached after first call.
---@return number
function M.ms()
  if cached_ms then
    return cached_ms
  end
  if not start_ns then
    return 0
  end
  cached_ms = math.floor((vim.uv.hrtime() - start_ns) / 1e4 + 0.5) / 100
  return cached_ms
end

--- Snacks dashboard section item showing this run's startup time.
---@return snacks.dashboard.Item
function M.dashboard_section()
  local ms = M.ms()
  return {
    align = "center",
    text = {
      { "⚡ Neovim loaded in ", hl = "SnacksDashboardFooter" },
      { string.format("%.2f", ms) .. "ms", hl = "SnacksDashboardSpecial" },
    },
  }
end

return M
