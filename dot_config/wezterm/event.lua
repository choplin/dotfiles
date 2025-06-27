local M = {}

local function setup_recomute_padding(wezterm)
  local function recompute_padding(window)
    local window_dims = window:get_dimensions()
    local overrides = window:get_config_overrides() or {}

    if not window_dims.is_full_screen then
      if not overrides.window_padding then
        -- not changing anything
        return
      end
      overrides.window_padding = nil
    else
      -- Add a top padding to avoid overlap with MacBook's notch
      local new_padding = {
        left = 5,
        right = 5,
        top = 30,
        bottom = 0,
      }
      if overrides.window_padding and new_padding.left == overrides.window_padding.left then
        -- padding is same, avoid triggering further changes
        return
      end
      overrides.window_padding = new_padding
    end
    window:set_config_overrides(overrides)
  end
  wezterm.on("window-resized", function(window, _)
    recompute_padding(window)
  end)

  wezterm.on("window-config-reloaded", function(window)
    recompute_padding(window)
  end)
end

local function setup_bell(wezterm)
  local function is_claude(pane)
    local process = pane:get_foreground_process_info()
    if not process or not process.name or not process.argv then
      return false
    end
    for _, arg in ipairs(process.argv) do
      if arg:find("claude") then
        return true
      end
    end
  end

  local function get_tab_id(window, pane)
    local mux_window = window:mux_window()
    for i, tab_info in ipairs(mux_window:tabs_with_info()) do
      for _, p in ipairs(tab_info.tab:panes()) do
        if p:pane_id() == pane:pane_id() then
          return i
        end
      end
    end
  end

  wezterm.on("bell", function(window, pane)
    if is_claude(pane) then
      local tab_id = get_tab_id(window, pane)
      window:toast_notification("Claude", "A bell was received from Claude on tab " .. tab_id, nil, 4000)
      if wezterm.target_triple:find("darwin") then
        -- wezterm.background_child_process({ "say", "Claude is calling your" })
        wezterm.background_child_process({ "afplay", "-v", "5", "/System/Library/Sounds/Submarine.aiff" })
      end
    end
  end)
end

local function setup_user_var(wezterm)
  wezterm.on("user-var-changed", function(window, _, name, value)
    wezterm.log_info("var", name, value)
    if name == "wez_not" then
      window:toast_notification("wezterm", "msg: " .. value, nil, 2000)
    end

    if name == "wez_copy" then
      window:copy_to_clipboard(value, "Clipboard")
    end
  end)
end

function M.setup(wezterm)
  if not _G.event_hanndler_initialized then
    setup_recomute_padding(wezterm)
    setup_bell(wezterm)
    setup_user_var(wezterm)
    _G.event_hanndler_initialized = true
  end
end

return M
