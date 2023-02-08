-- rose-pine-dawn
local M = {}

local palette = {
  base = '#faf4ed',
  surface = '#fffaf3',
  overlay = '#f2e9e1',
  muted = '#9893a5',
  subtle = '#797593',
  text = '#575279',
  love = '#b4637a',
  gold = '#ea9d34',
  rose = '#d7827e',
  pine = '#286983',
  foam = '#56949f',
  iris = '#907aa9',
  highlight_low = '#f4ede8',
  highlight_med = '#dfdad9',
  highlight_high = '#cecacd',
}

local active_tab = {
  bg_color = palette.overlay,
  fg_color = palette.text,
}

local inactive_tab = {
  bg_color = palette.highlight_med,
  fg_color = palette.text,
}

function M.colors()
  return {
    tab_bar = {
      background = palette.highlight_med,
      active_tab = active_tab,
      inactive_tab = inactive_tab,
      inactive_tab_hover = active_tab,
      new_tab = inactive_tab,
      new_tab_hover = active_tab,
      inactive_tab_edge = palette.highlight_high, -- (Fancy tab bar only)
    },
  }
end

function M.window_frame() -- (Fancy tab bar only)
  return {
    active_titlebar_bg = palette.base,
    inactive_titlebar_bg = palette.base,
    active_titlebar_fg = palette.text,
    inactive_titlebar_fg = palette.text,
    inactive_titlebar_border_bottom = palette.iris,
    active_titlebar_border_bottom = palette.iris,
    button_fg = palette.base,
    button_bg = palette.iris,
    button_hover_fg = palette.base,
    button_hover_bg = palette.iris,
  }
end

return M
