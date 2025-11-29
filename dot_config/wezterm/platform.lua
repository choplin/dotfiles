local wezterm = require("wezterm")

local M = {}

M.is_windows = wezterm.target_triple:find("windows") ~= nil
M.path_sep = M.is_windows and "\\" or "/"

--- Get the state directory for runtime data
---@return string path
function M.state_dir()
  if M.is_windows then
    local localappdata = os.getenv("LOCALAPPDATA")
    if localappdata then
      return localappdata
    end
    return wezterm.home_dir .. "\\AppData\\Local"
  else
    return os.getenv("XDG_STATE_HOME") or (wezterm.home_dir .. "/.local/state")
  end
end

--- Join path components with platform-appropriate separator
---@vararg string
---@return string path
function M.join(...)
  return table.concat({ ... }, M.path_sep)
end

--- Create directory (including parents)
---@param path string
function M.mkdir(path)
  if M.is_windows then
    os.execute('mkdir "' .. path .. '" 2>nul')
  else
    os.execute("mkdir -p " .. wezterm.shell_quote_arg(path))
  end
end

return M
