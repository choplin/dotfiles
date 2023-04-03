local wezterm = require "wezterm"
local act = wezterm.action

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

local function merge(...)
  local l = {}
  for _, list in ipairs { ... } do
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

local copy_mode = wezterm.gui.default_key_tables().copy_mode
table.insert(copy_mode, { key = "Backspace", mods = "NONE", action = act.CopyMode "MoveLeft" })

local default_prog = nil
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  default_prog = { "wsl.exe", "~", "-d", "Ubuntu" }
end

return {
  term = "wezterm",

  default_prog = default_prog,

  font = wezterm.font_with_fallback {
    "HackGen35 Console NF",
    "Broot Icons Visual Studio Code",
  },
  font_size = 16.0,
  -- color_scheme = "OneHalfDark",
  -- color_scheme = "nord",
  color_scheme = "tokyonight",
  use_ime = true,
  hide_tab_bar_if_only_one_tab = true,
  adjust_window_size_when_changing_font_size = false,
  audible_bell = "Disabled",

  tab_bar_at_bottom = true,
  use_fancy_tab_bar = true,
  window_decorations = "RESIZE",
  window_frame = {
    font = wezterm.font { family = "Roboto", weight = "Bold" },
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

  unix_domains = { { name = "unix" } },
  -- Do not start multiplexing on startup because it causes significant performance degradation
  -- default_gui_startup_args = { "connect", "unix" },

  send_composed_key_when_right_alt_is_pressed = false,

  leader = { key = "Y", mods = "CTRL", timeout_milliseconds = 1000 },
  keys = merge(
    {
      {
        key = "J",
        mods = "CTRL",
        action = act.ActivateTabRelative(1),
      },
      {
        key = "K",
        mods = "CTRL",
        action = act.ActivateTabRelative(-1),
      },
      {
        key = "v",
        mods = "LEADER",
        action = act.SplitHorizontal { domain = "CurrentPaneDomain" },
      },
      {
        key = "d",
        mods = "SUPER",
        action = act.SplitHorizontal { domain = "CurrentPaneDomain" },
      },
      {
        key = "s",
        mods = "LEADER",
        action = act.SplitVertical { domain = "CurrentPaneDomain" },
      },
      { key = "O", mods = "LEADER|CTRL", action = act.ActivatePaneDirection "Next" },
      { key = "w", mods = "CMD", action = act.CloseCurrentPane { confirm = true } },
      {
        key = "P",
        mods = "CTRL",
        action = act.QuickSelectArgs {
          label = "open url",
          patterns = {
            "https?://\\S+",
          },
          action = wezterm.action_callback(function(window, pane)
            local url = window:get_selection_text_for_pane(pane)
            wezterm.open_with(url)
          end),
        },
      },
      { key = "UpArrow", mods = "SHIFT", action = act.ScrollToPrompt(-1) },
      { key = "DownArrow", mods = "SHIFT", action = act.ScrollToPrompt(1) },
      { key = "Enter", mods = "ALT", action = act.Nop },
    },
    map(direction_keys, function(e)
      return {
        key = e.key,
        mods = "LEADER",
        action = act.Multiple {
          act.ActivatePaneDirection(e.direction),
          act.ActivateKeyTable { name = "pane", one_shot = false },
        },
      }
    end),
    map(direction_keys, function(e)
      return {
        key = e.key,
        mods = "LEADER|SHIFT",
        action = act.Multiple {
          act.AdjustPaneSize { e.direction, 5 },
          act.ActivateKeyTable { name = "pane", one_shot = false },
        },
      }
    end)
  ),
  key_tables = {
    pane = {
      { key = "h", action = act.ActivatePaneDirection "Left" },
      { key = "l", action = act.ActivatePaneDirection "Right" },
      { key = "k", action = act.ActivatePaneDirection "Up" },
      { key = "j", action = act.ActivatePaneDirection "Down" },

      { key = "H", mods = "SHIFT", action = act.AdjustPaneSize { "Left", 5 } },
      { key = "J", mods = "SHIFT", action = act.AdjustPaneSize { "Down", 5 } },
      { key = "K", mods = "SHIFT", action = act.AdjustPaneSize { "Up", 5 } },
      { key = "L", mods = "SHIFT", action = act.AdjustPaneSize { "Right", 5 } },

      { key = "Escape", action = "PopKeyTable" },
      { key = "Enter", action = "PopKeyTable" },
      { key = "[", mods = "CTRL", action = "PopKeyTable" },
    },
  },
}
