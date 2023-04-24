local custom = require('config.custom')

return {
  { 'sainnhe/gruvbox-material', enabled = (custom.theme == 'gruvbox_dark' or custom.theme == 'gruvbox_light') },
  { 'shaunsingh/nord.nvim', enabled = custom.theme == 'nord' },
  { 'sainnhe/edge', enabled = custom.theme == 'edge_light' },
  { 'rose-pine/neovim', name = 'rose-pine', enabled = custom.theme == 'rose_pine_dawn' },
}
