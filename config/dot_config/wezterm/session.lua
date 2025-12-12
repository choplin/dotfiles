local wezterm = require("wezterm")
local platform = require("platform")

local M = {}

local SESSION_DIR = platform.join(platform.state_dir(), "wezterm")
local SESSION_FILE = platform.join(SESSION_DIR, "session.json")

--- Collect pane information recursively from a tab
---@param tab any MuxTab object
---@return table panes_data Array of pane data
local function collect_panes(tab)
  local panes_data = {}
  for _, pane_info in ipairs(tab:panes_with_info()) do
    local pane = pane_info.pane
    local cwd = pane:get_current_working_dir()
    local cwd_path = nil
    if cwd then
      -- cwd is a URL object, extract the file path
      cwd_path = cwd.file_path
    end
    table.insert(panes_data, {
      cwd = cwd_path,
      is_active = pane_info.is_active,
      is_zoomed = pane_info.is_zoomed,
      left = pane_info.left,
      top = pane_info.top,
      width = pane_info.width,
      height = pane_info.height,
    })
  end
  return panes_data
end

--- Save current session to file
---@param window any Window object
function M.save(window)
  platform.mkdir(SESSION_DIR)
  local mux_window = window:mux_window()
  local tabs_data = {}

  for _, tab_info in ipairs(mux_window:tabs_with_info()) do
    local tab = tab_info.tab
    table.insert(tabs_data, {
      is_active = tab_info.is_active,
      panes = collect_panes(tab),
    })
  end

  local session_data = {
    tabs = tabs_data,
  }

  local json = wezterm.json_encode(session_data)
  local file = io.open(SESSION_FILE, "w")
  if file then
    file:write(json)
    file:close()
    window:toast_notification("WezTerm", "Session saved", nil, 2000)
    wezterm.log_info("Session saved to " .. SESSION_FILE)
  else
    window:toast_notification("WezTerm", "Failed to save session", nil, 2000)
    wezterm.log_error("Failed to save session to " .. SESSION_FILE)
  end
end

--- Perform the actual session restore
---@param window any Window object
---@param pane any Pane object
local function do_restore(window, pane)
  local file = io.open(SESSION_FILE, "r")
  if not file then
    window:toast_notification("WezTerm", "No session file found", nil, 2000)
    wezterm.log_warn("Session file not found: " .. SESSION_FILE)
    return
  end

  local content = file:read("*all")
  file:close()

  local success, session_data = pcall(wezterm.json_parse, content)
  if not success or not session_data or not session_data.tabs then
    window:toast_notification("WezTerm", "Failed to parse session file", nil, 2000)
    wezterm.log_error("Failed to parse session file")
    return
  end

  local mux_window = window:mux_window()

  -- Collect panes to close (all panes except in the current active tab)
  local panes_to_close = {}
  for _, tab_info in ipairs(mux_window:tabs_with_info()) do
    if not tab_info.is_active then
      for _, p in ipairs(tab_info.tab:panes()) do
        table.insert(panes_to_close, p:pane_id())
      end
    end
  end

  -- Close old panes
  for _, pane_id in ipairs(panes_to_close) do
    local p = wezterm.mux.get_pane(pane_id)
    if p then
      p:activate()
      window:perform_action(
        wezterm.action.CloseCurrentPane({ confirm = false }),
        p
      )
    end
  end

  local active_tab_index = 0

  for tab_index, tab_data in ipairs(session_data.tabs) do
    if tab_data.is_active then
      active_tab_index = tab_index - 1
    end

    -- Sort panes by position (top-left first) to reconstruct layout
    local panes = tab_data.panes
    table.sort(panes, function(a, b)
      if a.top == b.top then
        return a.left < b.left
      end
      return a.top < b.top
    end)

    if #panes > 0 then
      local first_pane_data = panes[1]
      local cwd = first_pane_data.cwd or wezterm.home_dir

      local current_pane

      if tab_index == 1 then
        -- Use current pane for the first tab, change directory
        current_pane = pane
        current_pane:send_text("cd " .. wezterm.shell_quote_arg(cwd) .. " && clear\n")
      else
        -- Spawn new tab using mux API
        _, current_pane = mux_window:spawn_tab({ cwd = cwd })
      end

      -- Create additional panes with splits using mux API
      for i = 2, #panes do
        local pane_data = panes[i]
        local pane_cwd = pane_data.cwd or wezterm.home_dir

        -- Determine split direction based on position
        local direction = "Right"
        if pane_data.top > panes[i - 1].top then
          direction = "Bottom"
        end

        -- Split the current pane and get reference to new pane
        current_pane = current_pane:split({ direction = direction, cwd = pane_cwd })
      end
    end
  end

  -- Activate the originally active tab
  if active_tab_index > 0 then
    local tabs = mux_window:tabs()
    if tabs[active_tab_index + 1] then
      tabs[active_tab_index + 1]:activate()
    end
  end

  window:toast_notification("WezTerm", "Session restored", nil, 2000)
  wezterm.log_info("Session restored from " .. SESSION_FILE)
end

--- Restore session from file with confirmation dialog
---@param window any Window object
---@param pane any Pane object
function M.restore(window, pane)
  -- Check if session file exists first
  local file = io.open(SESSION_FILE, "r")
  if not file then
    window:toast_notification("WezTerm", "No session file found", nil, 2000)
    return
  end
  file:close()

  window:perform_action(
    wezterm.action.InputSelector({
      title = "Restore Session?",
      description = "This will modify the current tab and create new tabs.",
      choices = {
        { label = "Yes, restore session" },
        { label = "Cancel" },
      },
      action = wezterm.action_callback(function(win, p, id, label)
        if label and label:find("Yes") then
          do_restore(win, p)
        end
      end),
    }),
    pane
  )
end

return M
