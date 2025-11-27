local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

--- Spawn a new tab next to the current tab
---@param window any
---@param pane any
---@return any new_pane The pane of the new tab
function M.spawn_tab_next_to_current(window, pane)
  local mux_window = window:mux_window()
  local current_index = 0
  for _, tab_info in ipairs(mux_window:tabs_with_info()) do
    if tab_info.is_active then
      current_index = tab_info.index
      break
    end
  end
  local _, new_pane = mux_window:spawn_tab({})
  window:perform_action(act.MoveTab(current_index + 1), pane)
  return new_pane
end

return M
