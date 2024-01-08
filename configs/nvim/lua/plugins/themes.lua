local values = require('config.values')

return {
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    enabled = values.theme.name == 'rose-pine',
    config = function()
      require('rose-pine').setup({ variant = values.theme.variant })
      vim.cmd.colorscheme('rose-pine')
    end,
  },
  {
    'shaunsingh/nord.nvim',
    enabled = values.theme.name == 'nord',
    -- TODO: config
  },
  {
    'sainnhe/edge',
    enabled = values.theme.name == 'edge',
    -- TODO: config
  },
}
