local wezterm = require 'wezterm';

local function recompute_padding(window)
  local window_dims = window:get_dimensions();
  local overrides = window:get_config_overrides() or {}

  if not window_dims.is_full_screen then
    if not overrides.window_padding then
      -- not changing anything
      return;
    end
    overrides.window_padding = nil;
  else
    -- Add a top padding to avoid overlap with MacBook's notch
    local new_padding = {
      left = 5,
      right = 5,
      top = 30,
      bottom = 0,
    };
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
end);

wezterm.on("window-config-reloaded", function(window)
  recompute_padding(window)
end);


local function merge(...)
  local l = {}
  for _, list in ipairs({ ... }) do
    for _, v in ipairs(list) do
      table.insert(l, v)
    end
  end
  return l
end

local function map(list, f)
  local l = {}
  for _, v in ipairs(list) do
    table.insert(l, f(v))
  end
  return l
end

local direction_keys = {
  { key = "h", direction = "Left" },
  { key = "l", direction = "Right" },
  { key = "k", direction = "Up" },
  { key = "j", direction = "Down" },
}

return {
  font = wezterm.font("Hackgen35Nerd Console"),
  font_size = 16.0,
  -- color_scheme = "OneHalfDark",
  color_scheme = "nord",
  use_ime = true,
  hide_tab_bar_if_only_one_tab = true,
  adjust_window_size_when_changing_font_size = false,
  audible_bell = "Disabled",

  tab_bar_at_bottom = true,
  use_fancy_tab_bar = true,
  window_frame = {
    font = wezterm.font({ family = "Roboto", weight = "Bold" }),
    font_size = 14.0,
    active_titlebar_bg = "#333333",
    inactive_titlebar_bg = "#111111",
  },

  window_padding = {
    left = 5,
    right = 5,
    top = 0,
    bottom = 0,
  },

  send_composed_key_when_right_alt_is_pressed = false,

  leader = { key = "y", mods = "CTRL", timeout_milliseconds = 1000 },
  keys = merge(
    {
      { key = "v", mods = "LEADER|CTRL", action = wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } } },
      { key = "d", mods = "SUPER", action = wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } } },
      { key = "s", mods = "LEADER|CTRL", action = wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } } },
      { key = "o", mods = "LEADER|CTRL", action = wezterm.action { ActivatePaneDirection = "Next" } },
      { key = "w", mods = "CMD", action = wezterm.action { CloseCurrentPane = { confirm = true } } },
    },
    map(direction_keys, function(e)
      return { key = e.key, mods = "LEADER", action = wezterm.action {
        Multiple = {
          wezterm.action { ActivatePaneDirection = e.direction },
          wezterm.action { ActivateKeyTable = { name = "pane", one_shot = false } },
        }
      } }
    end),
    map(direction_keys, function(e)
      return { key = e.key, mods = "LEADER|SHIFT", action = wezterm.action {
        Multiple = {
          wezterm.action { AdjustPaneSize = { e.direction, 5 } },
          wezterm.action { ActivateKeyTable = { name = "pane", one_shot = false } },
        }
      } }
    end)
  ),
  key_tables = {
    pane = {
      { key = "h", action = wezterm.action { ActivatePaneDirection = "Left" } },
      { key = "l", action = wezterm.action { ActivatePaneDirection = "Right" } },
      { key = "k", action = wezterm.action { ActivatePaneDirection = "Up" } },
      { key = "j", action = wezterm.action { ActivatePaneDirection = "Down" } },

      { key = "H", mods = "SHIFT", action = wezterm.action { AdjustPaneSize = { "Left", 5 } } },
      { key = "J", mods = "SHIFT", action = wezterm.action { AdjustPaneSize = { "Down", 5 } } },
      { key = "K", mods = "SHIFT", action = wezterm.action { AdjustPaneSize = { "Up", 5 } } },
      { key = "L", mods = "SHIFT", action = wezterm.action { AdjustPaneSize = { "Right", 5 } } },

      { key = "Escape", action = "PopKeyTable" },
    },
  }
}
