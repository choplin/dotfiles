local wezterm = require 'wezterm';

return {
  font = wezterm.font("Hackgen35Nerd Console"),
  font_size = 16.0,
  color_scheme = "OneHalfDark",
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
}
