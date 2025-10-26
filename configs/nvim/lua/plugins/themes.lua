local settings = require('config.settings')

return {
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    enabled = settings.theme.name == 'rose-pine',
    config = function()
      require('rose-pine').setup({ variant = settings.theme.variant })
      vim.cmd.colorscheme('rose-pine')
    end,
  },
  {
    'AlexvZyl/nordic.nvim',
    enabled = settings.theme.name == 'nord',
    config = function()
      vim.cmd.colorscheme('nordic')
    end,
  },
  {
    'mcchrish/zenbones.nvim',
    enabled = settings.theme.name == 'zenbones',
    dependencies = { 'rktjmp/lush.nvim' },
    config = function()
      local v = settings.theme.variant
      if v == 'light' or v == 'rose-light' then
        vim.opt.background = 'light'
      else
        vim.opt.background = 'dark'
      end
      if v == 'rose-light' or v == 'rose-dark' then
        vim.cmd.colorscheme('rosebones')
      else
        vim.cmd.colorscheme('zenbones')
      end
      vim.cmd.highlight({ args = { 'link', 'ColorColumn', 'CursorLine' }, bang = true })
    end,
  },
}
