-- vim: ts=2 sw=2 sts=2
local wezterm = require('wezterm')
local vars = require('vars')
local config = {}

---set config
---@param options table
local function set(options)
  for key, value in pairs(options) do
    config[key] = value
  end
end

local function make_font_config(family)
  if family == 'monospace' then
    return wezterm.font('monospace')
  end
  return wezterm.font_with_fallback({
    family,
    'Symbols Nerd Font',
    'Apple Color Emoji',
    'PingFang SC',
  })
end

-- font
set({
  font = make_font_config(vars.font_family),
  font_size = vars.font_size,
})

-- appearance

---@class WeztermColorInput
---@field ansi string[8]
---@field background string
---@field brights string[8]
---@field cursor_bg string
---@field cursor_border string
---@field cursor_fg string
---@field foreground string
---@field selection_bg string
---@field selection_fg string
---@class WeztermColor: WeztermColorInput
---@field tab_bar table

---@type WeztermColorInput|WeztermColor
local colors = wezterm.color.get_builtin_schemes()[vars.theme]
local active_tab = {
  bg_color = colors.ansi[1],
  fg_color = colors.foreground,
  intensity = 'Bold',
}
local inactive_tab = {
  bg_color = colors.background,
  fg_color = colors.foreground,
}
local window_frame = {
  active_titlebar_bg = colors.background,
  inactive_titlebar_bg = colors.background,
  active_titlebar_fg = colors.foreground,
  inactive_titlebar_fg = colors.foreground,
  inactive_titlebar_border_bottom = colors.ansi[6],
  active_titlebar_border_bottom = colors.ansi[6],
  button_fg = colors.background,
  button_bg = colors.ansi[6],
  button_hover_fg = colors.background,
  button_hover_bg = colors.ansi[6],
}
colors.tab_bar = {
  background = colors.background,
  active_tab = active_tab,
  inactive_tab = inactive_tab,
  inactive_tab_hover = active_tab,
  new_tab = inactive_tab,
  new_tab_hover = active_tab,
  inactive_tab_edge = colors.ansi[1], -- (Fancy tab bar only)
}
set({
  color_scheme = vars.theme,
  colors = colors,
  window_frame = window_frame,
  window_padding = { left = '0px', right = '0px', top = '0px', bottom = '0px' },
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = false,
  tab_max_width = 99,
})

-- key mapping
local keys = {
  -- split vertical
  {
    key = '|',
    mods = 'LEADER|SHIFT',
    action = wezterm.action({ SplitHorizontal = { domain = 'CurrentPaneDomain' } }),
  },
  -- split horizontal
  { key = '%', mods = 'LEADER|SHIFT', action = wezterm.action({ SplitVertical = { domain = 'CurrentPaneDomain' } }) },
  -- nav between panels
  { key = 'h', mods = 'LEADER', action = wezterm.action({ ActivatePaneDirection = 'Left' }) },
  { key = 'j', mods = 'LEADER', action = wezterm.action({ ActivatePaneDirection = 'Down' }) },
  { key = 'k', mods = 'LEADER', action = wezterm.action({ ActivatePaneDirection = 'Up' }) },
  { key = 'l', mods = 'LEADER', action = wezterm.action({ ActivatePaneDirection = 'Right' }) },
  -- new tab
  { key = 'c', mods = 'LEADER', action = wezterm.action({ SpawnTab = 'DefaultDomain' }) },
  { key = 'C', mods = 'LEADER|SHIFT', action = wezterm.action({ SpawnTab = 'DefaultDomain' }) },
  -- close current tab
  { key = 'x', mods = 'LEADER', action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
  -- copy mode
  { key = 'Escape', mods = 'LEADER', action = wezterm.action.ActivateCopyMode },
}
for i = 1, 9, 1 do
  table.insert(keys, {
    key = string.format('%d', i),
    mods = 'LEADER',
    action = wezterm.action({ ActivateTab = i - 1 }),
  })
end
set({
  leader = { key = 't', mods = 'CTRL', timeout_milliseconds = 1000 },
  keys = keys,
})

-- misc
set({
  use_ime = true,
  enable_wayland = true,
  term = 'wezterm',
})

return config
