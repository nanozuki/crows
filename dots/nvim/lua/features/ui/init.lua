local feature = require('fur.feature')

local ui = feature:new('ui')
ui.source = 'lua/features/ui.lua'

local filetree = feature:new('filetree')
filetree.plugins = {
  {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('nvim-tree.view').View.winopts.signcolumn = 'auto'
      require('nvim-tree').setup({
        disable_netrw = false,
        update_cwd = true,
        diagnostics = {
          enable = true,
        },
      })
    end,
  },
}
filetree.mappings = {
  { 'n', '<Leader>fl', ':NvimTreeToggle<CR>' },
}

ui.children = {
  require('features.ui.colors'),
  require('features.ui.statusline'),
  require('features.ui.tabline'),
  filetree,
}

return ui
