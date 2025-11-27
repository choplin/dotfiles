local wezterm = require("wezterm")

require("event").setup(wezterm)
local util = require("util")
local action = require("action")

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.term = "wezterm"

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.default_prog = { "wsl.exe", "~", "-d", "Ubuntu" }
elseif util.exists("/opt/homebrew/bin/zsh") then
  config.default_prog = { "/opt/homebrew/bin/zsh", "-l" }
end

config.font = wezterm.font_with_fallback({
  "UDEV Gothic NF",
  "HackGen35 Console NF",
  "Broot Icons Visual Studio Code",
})
config.font_size = 18.0
config.color_scheme = "tokyonight"
config.use_ime = true
config.hide_tab_bar_if_only_one_tab = true
config.adjust_window_size_when_changing_font_size = false
config.audible_bell = "Disabled"
config.notification_handling = "AlwaysShow"

config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = true
config.switch_to_last_active_tab_when_closing_tab = true
config.window_decorations = "RESIZE"
-- config.window_background_opacity = 0.85
config.window_background_opacity = 0.98
-- config.window_background_opacity = 1
config.macos_window_background_blur = 15
config.window_frame = {
  font = wezterm.font({ family = "Roboto", weight = "Bold" }),
  font_size = 14.0,
  active_titlebar_bg = "#333333",
  inactive_titlebar_bg = "#111111",
}

config.window_padding = {
  left = 5,
  right = 5,
  top = 0,
  bottom = 0,
}

config.unix_domains = { { name = "unix" } }
-- Do not start multiplexing on startup because it causes significant performance degradation
-- config.default_gui_startup_args = { "connect", "unix" }

config.send_composed_key_when_right_alt_is_pressed = false

config.command_palette_font_size = 18
config.command_palette_bg_color = wezterm.color.from_hsla(223, 0.15, 0.14, 0.7)

config.leader = { key = "Y", mods = "CTRL", timeout_milliseconds = 1000 }

local direction_keys = {
  { key = "h", direction = "Left" },
  { key = "l", direction = "Right" },
  { key = "k", direction = "Up" },
  { key = "j", direction = "Down" },
}

local act = wezterm.action
config.keys = util.merge(
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
      key = "J",
      mods = "CTRL|ALT",
      action = act.MoveTabRelative(1),
    },
    {
      key = "K",
      mods = "CTRL|ALT",
      action = act.MoveTabRelative(-1),
    },
    {
      key = "v",
      mods = "LEADER",
      action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "d",
      mods = "SUPER",
      action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "s",
      mods = "LEADER",
      action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "y",
      mods = "CMD",
      action = wezterm.action_callback(function(window, pane)
        local new_pane = action.spawn_tab_next_to_current(window, pane)
        new_pane:send_text("yazi\n")
      end),
    },
    {
      key = "Y",
      mods = "CMD",
      action = wezterm.action_callback(function(window, pane)
        window:perform_action(act.SplitHorizontal({ domain = "CurrentPaneDomain" }), pane)
        window:active_pane():send_text("yazi\n")
      end),
    },
    { key = "O", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Next") },
    { key = "w", mods = "CMD", action = act.CloseCurrentPane({ confirm = true }) },
    {
      key = "P",
      mods = "CTRL",
      action = act.QuickSelectArgs({
        label = "open url",
        patterns = {
          [[https?://[^ \s↴\)]+]],
        },
        action = wezterm.action_callback(function(window, pane)
          local url = window:get_selection_text_for_pane(pane)
          wezterm.open_with(url)
        end),
      }),
    },
    {
      key = "P",
      mods = "SUPER",
      action = act.ActivateCommandPalette,
    },
    { key = "UpArrow", mods = "SHIFT", action = act.ScrollToPrompt(-1) },
    { key = "DownArrow", mods = "SHIFT", action = act.ScrollToPrompt(1) },
    { key = "Enter", mods = "ALT", action = act.ToggleFullScreen },
  },
  util.map(direction_keys, function(e)
    return {
      key = e.key,
      mods = "LEADER",
      action = act.Multiple({
        act.ActivatePaneDirection(e.direction),
        act.ActivateKeyTable({ name = "pane", one_shot = false }),
      }),
    }
  end),
  util.map(direction_keys, function(e)
    return {
      key = e.key,
      mods = "LEADER|SHIFT",
      action = act.Multiple({
        act.AdjustPaneSize({ e.direction, 5 }),
        act.ActivateKeyTable({ name = "pane", one_shot = false }),
      }),
    }
  end)
)

config.key_tables = {
  pane = {
    { key = "h", action = act.ActivatePaneDirection("Left") },
    { key = "l", action = act.ActivatePaneDirection("Right") },
    { key = "k", action = act.ActivatePaneDirection("Up") },
    { key = "j", action = act.ActivatePaneDirection("Down") },

    { key = "H", mods = "SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
    { key = "J", mods = "SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
    { key = "K", mods = "SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
    { key = "L", mods = "SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },

    { key = "Escape", action = "PopKeyTable" },
    { key = "Enter", action = "PopKeyTable" },
    { key = "[", mods = "CTRL", action = "PopKeyTable" },
  },
  copy_mode = util.merge(wezterm.gui.default_key_tables().copy_mode, {
    { key = "Backspace", mods = "NONE", action = act.CopyMode("MoveLeft") },
    { key = "z", mods = "NONE", action = act.CopyMode({ MoveForwardZoneOfType = "Output" }) },
    { key = "Z", mods = "NONE", action = act.CopyMode({ MoveBackwardZoneOfType = "Output" }) },
    { key = "z", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "SemanticZone" }) },
  }),
}

config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = wezterm.action_callback(function(window, pane)
      local selection = window:get_selection_text_for_pane(pane)
      if selection ~= "" then
        return
      else
        window:perform_action(wezterm.action.OpenLinkAtMouseCursor, pane)
      end
    end),
  },
  -- Prevent automatic copy on double click (word selection only)
  {
    event = { Up = { streak = 2, button = "Left" } },
    mods = "NONE",
    action = wezterm.action.SelectTextAtMouseCursor("Word"),
  },
  -- Prevent automatic copy on triple click (line selection only)
  {
    event = { Up = { streak = 3, button = "Left" } },
    mods = "NONE",
    action = wezterm.action.SelectTextAtMouseCursor("Line"),
  },
}

return config
