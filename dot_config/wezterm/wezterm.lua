local wezterm = require('wezterm')

local rose_pine_dawn = {
  foreground = '#575279',
  background = '#faf4ed',
  cursor_bg = '#9893a5',
  cursor_fg = '#575279',
  cursor_border = '#9893a5',
  selection_fg = '#575279',
  selection_bg = '#eee9e6',
  scrollbar_thumb = '#f2e9de',
  split = '#f2e9de',
  ansi = { '#f2e9de', '#b4637a', '#286983', '#ea9d34', '#56949f', '#907aa9', '#d7827e', '#575279' },
  brights = { '#6e6a86', '#b4637a', '#286983', '#ea9d34', '#56949f', '#907aa9', '#d7827e', '#575279' },
}

return {
  font = wezterm.font_with_fallback({
    'JetBrainsMono Nerd Font',
    'Menlo',
    'Apple Braille',
    'Geneva',
    'Apple Color Emoji',
    'PingFang SC',
  }),
  use_ime = true,
  colors = rose_pine_dawn,
  enable_tab_bar = false,
  keys = {
    -- fix issue: press <S-Del> will input text '<S-Del>' in vim
    { key = 'Delete', mods = 'SHIFT', action = { SendKey = { key = 'Delete' } } },
  },
}
