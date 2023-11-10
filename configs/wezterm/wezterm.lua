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

-- theme
set({
  color_scheme = 'rose-pine-dawn',
  colors = require('lua/rose-pine-dawn').colors(),
})

-- appearance
set({
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = false,
  tab_max_width = 99,
  -- appearance/window
  window_frame = require('lua/rose-pine-dawn').window_frame(),
  window_padding = { left = '0px', right = '0px', top = '0px', bottom = '0px' },
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
