local feature = require('fur.feature')

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

ui.children = {
  require('features.ui.colors'),
  treesitter,
  require('features.ui.statusline'),
  require('features.ui.tabline'),
  filetree,
}

return ui
