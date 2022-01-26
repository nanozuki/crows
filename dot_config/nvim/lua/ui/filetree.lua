local crows = require('crows')

-- filetree
crows.use_plugin({
  'kyazdani42/nvim-tree.lua',
  requires = 'kyazdani42/nvim-web-devicons',
  config = function()
    require('nvim-tree').setup({
      disable_netrw = false,
      update_cwd = true,
      diagnostics = { enable = true },
      view = { signcolumn = 'auto' },
      git = {
        ignore = false,
      },
    })
    require('crows').map('Toggle filetree', 'n', '<Leader>fl', ':NvimTreeToggle<CR>')
  end,
})
