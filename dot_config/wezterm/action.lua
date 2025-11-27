local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

--- Wrap command with default shell
---@param args string[] Command and arguments
---@return string[] args Shell command with -lic flag
function M.with_shell(args)
  local shell = os.getenv("SHELL") or "/bin/sh"
  return { shell, "-lic", table.concat(args, " ") }
end

--- Get the index of the current active tab
---@param window any
---@return number current_index
local function get_current_tab_index(window)
  local mux_window = window:mux_window()
  for _, tab_info in ipairs(mux_window:tabs_with_info()) do
    if tab_info.is_active then
      return tab_info.index
    end
  end
  return 0
end

--- Spawn a new tab next to the current tab
---@param window any
---@param pane any
---@return any new_pane The pane of the new tab
function M.spawn_tab_next_to_current(window, pane)
  local current_index = get_current_tab_index(window)
  local _, new_pane = window:mux_window():spawn_tab({})
  window:perform_action(act.MoveTab(current_index + 1), pane)
  return new_pane
end

--- Spawn a command in a new tab next to the current tab
---@param window any
---@param pane any
---@param args string[] Command and arguments
function M.spawn_command_in_tab_next_to_current(window, pane, args)
  local current_index = get_current_tab_index(window)
  window:perform_action(act.SpawnCommandInNewTab({ args = args }), pane)
  window:perform_action(act.MoveTab(current_index + 1), pane)
end

return M
