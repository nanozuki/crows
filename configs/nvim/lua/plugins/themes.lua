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
    'AlexvZyl/nordic.nvim',
    enabled = values.theme.name == 'nord',
    config = function()
      vim.cmd.colorscheme('nordic')
    end,
  },
}
