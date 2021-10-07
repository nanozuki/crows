local feature = require('fur.feature')
local packadd = require('fur').packadd

local ui = feature:new('ui')
ui.source = 'lua/features/ui.lua'

local treesitter = feature:new('treesitter')
treesitter.plugins = {
  {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = 'maintained',
        highlight = { enable = true },
      })
    end,
  },
}

local filetree = feature:new('filetree')
filetree.plugins = {
  {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('nvim-tree.view').View.winopts.signcolumn = 'auto'
      require('nvim-tree').setup({
        lsp_diagnostics = true,
      })
    end,
  },
}
filetree.mappings = {
  { 'n', '<Leader>fl', ':NvimTreeToggle<CR>' },
}

local colorscheme = feature:new('colorscheme')
colorscheme.plugins = {
  { 'sainnhe/gruvbox-material', opt = true },
  { 'shaunsingh/nord.nvim', opt = true },
  { 'sainnhe/edge', opt = true },
}
local colorschemes = {
  gruvbox_light = function()
    if packadd('gruvbox-material') then
      vim.opt.background = 'light'
      vim.g['gruvbox_material_enable_italic'] = 1
      vim.cmd('colorscheme gruvbox-material')
    end
  end,
  gruvbox_dark = function()
    if packadd('gruvbox-material') then
      vim.opt.background = 'dark'
      vim.g['gruvbox_material_enable_italic'] = 1
      vim.cmd('colorscheme gruvbox-material')
    end
  end,
  nord = function()
    if packadd('nord.nvim') then
      vim.g.nord_borders = true
      require('nord').set()
      vim.cmd('colorscheme nord')
    end
  end,
  edge_light = function()
    if packadd('edge') then
      vim.opt.background = 'light'
      vim.g.edge_enable_italic = 1
      vim.cmd('colorscheme edge')
    end
  end,
}
colorscheme.setup = function()
  vim.opt.termguicolors = true -- true color
  local function set_colorscheme(name)
    colorschemes[name]()
  end
  set_colorscheme('gruvbox_light')
end

ui.children = {
  colorscheme,
  treesitter,
  require('features.ui.statusline'),
  require('features.ui.tabline'),
  filetree,
}

return ui
