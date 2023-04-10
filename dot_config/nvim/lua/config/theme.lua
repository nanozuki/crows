---@class ColorPalette
---@field accent     string accent color
---@field accent_sec string secondary accent color
---@field bg         string background color
---@field bg_sec     string secondary background color
---@field fg         string foreground color
---@field fg_sec     string secondary foreground color

---@type table<string, fun():ColorPalette>
local themes = {
  gruvbox_light = function()
    vim.opt.background = 'light'
    vim.g.gruvbox_material_enable_italic = 1
    vim.g.gruvbox_material_background = 'hard'
    vim.cmd('colorscheme gruvbox-material')
    return {
      accent = '#d65d0e', -- orange
      accent_sec = '#7c6f64', -- fg4
      bg = '#ebdbb2', -- bg1
      bg_sec = '#d5c4a1', -- bg2
      fg = '#504945', -- fg2
      fg_sec = '#665c54', -- fg3
    }
  end,

  gruvbox_dark = function()
    vim.opt.background = 'dark'
    vim.g['gruvbox_material_enable_italic'] = 1
    vim.cmd('colorscheme gruvbox-material')
    return {
      accent = '#d65d0e', -- orange
      accent_sec = '#a89984', -- fg4
      bg = '#3c3836', -- bg1
      bg_sec = '#504945', -- bg2
      fg = '#d5c4a1', -- fg2
      fg_sec = '#bdae93', -- fg3
    }
  end,

  edge_light = function()
    vim.opt.background = 'light'
    vim.g.edge_enable_italic = 1
    vim.cmd('colorscheme edge')
    return {
      accent = '#bf75d6', -- bg_purple
      accent_sec = '#8790a0', -- grey
      bg = '#eef1f4', -- bg1
      bg_sec = '#dde2e7', -- bg4
      fg = '#33353f', -- default:bg1
      fg_sec = '#4b505b', -- fg
    }
  end,

  nord = function()
    vim.opt.background = 'dark'
    vim.g.nord_borders = true
    require('nord').set()
    vim.cmd('colorscheme nord')
    return {
      accent = '#88c0d0', -- nord8
      accent_sec = '#81a1c1', -- nord9
      bg = '#3b4252', -- nord1
      bg_sec = '#4c566a', -- nord3
      fg = '#e5e9f0', -- nord4
      fg_sec = '#d8dee9', -- nord4
    }
  end,

  rose_pine_dawn = function()
    vim.o.background = 'light'
    vim.cmd('colorscheme rose-pine')
    local palette = require('rose-pine.palette')
    return {
      accent = palette.iris,
      accent_sec = palette.rose,
      bg = palette.surface,
      bg_sec = palette.overlay,
      fg = palette.text,
      fg_sec = palette.subtle, -- fg
    }
  end,
}

local theme = {
  ---@type ColorPalette
  palette = themes[require('config.custom').theme](),
}

return theme
