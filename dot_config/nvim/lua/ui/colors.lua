local crows = require('crows')

local palettes = {
  gruvbox_light = {
    accent = '#d65d0e', -- orange
    accent_sec = '#7c6f64', -- fg4
    bg = '#ebdbb2', -- bg1
    bg_sec = '#d5c4a1', -- bg2
    fg = '#504945', -- fg2
    fg_sec = '#665c54', -- fg3
  },
  gruvbox_dark = {
    accent = '#d65d0e', -- orange
    accent_sec = '#a89984', -- fg4
    bg = '#3c3836', -- bg1
    bg_sec = '#504945', -- bg2
    fg = '#d5c4a1', -- fg2
    fg_sec = '#bdae93', -- fg3
  },
  edge_light = {
    accent = '#bf75d6', -- bg_purple
    accent_sec = '#8790a0', -- grey
    bg = '#eef1f4', -- bg1
    bg_sec = '#dde2e7', -- bg4
    fg = '#33353f', -- default:bg1
    fg_sec = '#4b505b', -- fg
  },
  nord = {
    accent = '#88c0d0', -- nord8
    accent_sec = '#81a1c1', -- nord9
    bg = '#3b4252', -- nord1
    bg_sec = '#4c566a', -- nord3
    fg = '#e5e9f0', -- nord4
    fg_sec = '#d8dee9', -- nord4
  },
  rose_pine_dawn = {
    accent = '#b4637a', -- bg_purple
    accent_sec = '#d7827e', -- grey
    bg = '#f2e9de', -- bg1
    bg_sec = '#e4dfde', -- bg4
    fg = '#575279', -- default:bg1
    fg_sec = '#6e6a86', -- fg
  },
}

local colorschemes = {
  gruvbox_light = function()
    if crows.packadd('gruvbox-material') then
      vim.opt.background = 'light'
      vim.g['gruvbox_material_enable_italic'] = 1
      vim.cmd('colorscheme gruvbox-material')
    end
  end,
  gruvbox_dark = function()
    if crows.packadd('gruvbox-material') then
      vim.opt.background = 'dark'
      vim.g['gruvbox_material_enable_italic'] = 1
      vim.cmd('colorscheme gruvbox-material')
    end
  end,
  nord = function()
    if crows.packadd('nord.nvim') then
      vim.g.nord_borders = true
      require('nord').set()
      vim.cmd('colorscheme nord')
    end
  end,
  edge_light = function()
    if crows.packadd('edge') then
      vim.opt.background = 'light'
      vim.g.edge_enable_italic = 1
      vim.cmd('colorscheme edge')
    end
  end,
  rose_pine_dawn = function()
    if crows.packadd('rose-pine') then
      vim.g.rose_pine_variant = 'dawn'
      vim.cmd('colorscheme rose-pine')
    end
  end,
}

crows.use_plugin({ 'sainnhe/gruvbox-material', opt = true })
crows.use_plugin({ 'shaunsingh/nord.nvim', opt = true })
crows.use_plugin({ 'sainnhe/edge', opt = true })
crows.use_plugin({ 'rose-pine/neovim', opt = true, as = 'rose-pine' })

local theme = 'rose_pine_dawn'
crows.setv('palette', palettes[theme])
vim.opt.termguicolors = true -- true color
colorschemes[theme]()

-- live display colors
crows.use_plugin({ 'norcalli/nvim-colorizer.lua', opt = true })
crows.setv('toggle_colors', function()
  crows.packadd('nvim-colorizer.lua')
  vim.cmd([[ColorizerToggle]])
end)
vim.cmd([[command! ToggleColors lua require('crows').getv('toggle_colors')()]])
