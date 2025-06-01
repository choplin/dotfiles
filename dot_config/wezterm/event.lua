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
  wezterm.on("bell", function(window, pane)
    window:toast_notification("Bell", "A bell was received", nil, 2000)
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
