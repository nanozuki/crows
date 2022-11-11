local theme = {}

function theme.gruvbox_light()
  theme.palette = {
    accent = '#d65d0e', -- orange
    accent_sec = '#7c6f64', -- fg4
    bg = '#ebdbb2', -- bg1
    bg_sec = '#d5c4a1', -- bg2
    fg = '#504945', -- fg2
    fg_sec = '#665c54', -- fg3
  }
  vim.cmd('packadd gruvbox-material')
  vim.opt.background = 'light'
  vim.g.gruvbox_material_enable_italic = 1
  vim.g.gruvbox_material_background = 'hard'
  vim.cmd('colorscheme gruvbox-material')
end

function theme.gruvbox_dark()
  theme.palette = {
    accent = '#d65d0e', -- orange
    accent_sec = '#a89984', -- fg4
    bg = '#3c3836', -- bg1
    bg_sec = '#504945', -- bg2
    fg = '#d5c4a1', -- fg2
    fg_sec = '#bdae93', -- fg3
  }
  vim.cmd('packadd gruvbox-material')
  vim.opt.background = 'dark'
  vim.g['gruvbox_material_enable_italic'] = 1
  vim.cmd('colorscheme gruvbox-material')
end

function theme.edge_light()
  theme.palette = {
    accent = '#bf75d6', -- bg_purple
    accent_sec = '#8790a0', -- grey
    bg = '#eef1f4', -- bg1
    bg_sec = '#dde2e7', -- bg4
    fg = '#33353f', -- default:bg1
    fg_sec = '#4b505b', -- fg
  }
  vim.cmd('packadd edge')
  vim.opt.background = 'light'
  vim.g.edge_enable_italic = 1
  vim.cmd('colorscheme edge')
end

function theme.nord()
  theme.palette = {
    accent = '#88c0d0', -- nord8
    accent_sec = '#81a1c1', -- nord9
    bg = '#3b4252', -- nord1
    bg_sec = '#4c566a', -- nord3
    fg = '#e5e9f0', -- nord4
    fg_sec = '#d8dee9', -- nord4
  }
  vim.cmd('packadd nord.nvim')
  vim.opt.background = 'dark'
  vim.g.nord_borders = true
  require('nord').set()
  vim.cmd('colorscheme nord')
end

function theme.rose_pine_dawn()
  theme.palette = {
    accent = '#907aa9', -- Iris
    accent_sec = '#d7827e', -- Rose
    bg = '#f2e9de', -- bg1
    bg_sec = '#e4dfde', -- bg4
    fg = '#575279', -- default:bg1
    fg_sec = '#6e6a86', -- fg
  }
  vim.cmd('packadd rose-pine')
  vim.o.background = 'light'
  vim.cmd('colorscheme rose-pine')
end

function theme.use(name)
  theme[name]()
  return theme.palette
end

return theme
