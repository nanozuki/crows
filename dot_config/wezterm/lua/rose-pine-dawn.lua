-- rose-pine-dawn

local M = {}

local palette = {
  base = '#faf4ed',
  overlay = '#f2e9e1',
  muted = '#9893a5',
  text = '#575279',
  iris = '#907aa9',
}

local active_tab = {
  bg_color = palette.overlay,
  fg_color = palette.text,
}

local inactive_tab = {
  bg_color = palette.base,
  fg_color = palette.muted,
}

function M.colors()
  return {
    tab_bar = {
      background = palette.base,
      active_tab = active_tab,
      inactive_tab = inactive_tab,
      inactive_tab_hover = active_tab,
      new_tab = inactive_tab,
      new_tab_hover = active_tab,
      inactive_tab_edge = palette.muted, -- (Fancy tab bar only)
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
