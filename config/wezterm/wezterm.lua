local wezterm = require 'wezterm';

return {
  font = wezterm.font("Hackgen35Nerd Console"),
  font_size = 16.0,
  color_scheme = "OneHalfDark",
  use_ime = true,
  hide_tab_bar_if_only_one_tab = true,
  adjust_window_size_when_changing_font_size = false,

  tab_bar_at_bottom = false,
  use_fancy_tab_bar = true,
  window_frame = {
    font = wezterm.font({ family = "Roboto", weight = "Bold" }),
    font_size = 12.0,
    active_titlebar_bg = "#333333",
    inactive_titlebar_bg = "#111111",
  },

  window_padding = {
    left = 5,
    right = 5,
    top = 0,
    bottom = 0,
  },
}
