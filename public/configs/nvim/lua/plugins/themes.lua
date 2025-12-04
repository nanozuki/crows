local settings = require('config.settings')

return {
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    enabled = settings.theme.name == 'rose-pine',
    config = function()
      vim.cmd.colorscheme('rose-pine')
    end,
  },
  {
    'mcchrish/zenbones.nvim',
    enabled = settings.theme.name == 'zenbones',
    dependencies = { 'rktjmp/lush.nvim' },
    config = function()
      vim.cmd.colorscheme('zenbones')
      vim.cmd.highlight({ args = { 'link', 'ColorColumn', 'CursorLine' }, bang = true })
    end,
  },
}
