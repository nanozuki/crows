local custom = require('config.custom')
local store = require('config.store')

return {
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    enabled = custom.theme.name == 'rose_pine',
    config = function()
      require('rose-pine').setup({ variant = custom.theme.variant })
      store.color_palette = require('rose-pine.palette')
      vim.cmd.colorscheme('rose-pine')
    end,
  },
  {
    'shaunsingh/nord.nvim',
    enabled = custom.theme.name == 'nord',
    -- TODO: config
  },
  {
    'sainnhe/edge',
    enabled = custom.theme.name == 'edge',
    -- TODO: config
  },
}
