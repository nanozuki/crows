local crows = require('crows')

local themes = {}

crows.plugin.use({ 'sainnhe/gruvbox-material', opt = true })
crows.plugin.use({ 'shaunsingh/nord.nvim', opt = true })
crows.plugin.use({ 'sainnhe/edge', opt = true })
crows.plugin.use({ 'rose-pine/neovim', opt = true, as = 'rose-pine' })
vim.opt.termguicolors = true -- true color

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

function themes.gruvbox_light()
  if crows.ensure_pack('gruvbox-material') then
    vim.opt.background = 'light'
    vim.g['gruvbox_material_enable_italic'] = 1
    vim.cmd('colorscheme gruvbox-material')
    themes.palette = palettes.gruvbox_light
  end
end
function themes.gruvbox_dark()
  if crows.ensure_pack('gruvbox-material') then
    vim.opt.background = 'dark'
    vim.g['gruvbox_material_enable_italic'] = 1
    vim.cmd('colorscheme gruvbox-material')
    themes.palette = palettes.gruvbox_dark
  end
end
function themes.nord()
  if crows.ensure_pack('nord.nvim') then
    vim.opt.background = 'dark'
    vim.g.nord_borders = true
    require('nord').set()
    vim.cmd('colorscheme nord')
    themes.palette = palettes.nord
  end
end
function themes.edge_light()
  if crows.ensure_pack('edge') then
    vim.opt.background = 'light'
    vim.g.edge_enable_italic = 1
    vim.cmd('colorscheme edge')
    themes.palette = palettes.edge_light
  end
end
function themes.rose_pine_dawn()
  if crows.ensure_pack('rose-pine') then
    vim.o.background = 'light'
    vim.cmd('colorscheme rose-pine')
    themes.palette = palettes.rose_pine_dawn
  end
end

themes.rose_pine_dawn()

-- live display colors
crows.plugin.use({ 'norcalli/nvim-colorizer.lua', opt = true })
function themes.toggle_colors()
  crows.ensure_pack('nvim-colorizer.lua')
  vim.cmd([[ColorizerToggle]])
end
vim.cmd([[command! ToggleColors lua require('ui.themes').toggle_colors()]])

return themes
