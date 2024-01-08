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
    config = function()
      vim.cmd.colorscheme('nord')
    end,
  },
  {
    'sainnhe/edge',
    enabled = values.theme.name == 'edge',
    config = function()
      if values.theme.variant == 'aura' or values.theme.variant == 'neon' then
        vim.g.edge_style = values.theme.variant
      elseif values.theme.variant == 'light' then
        vim.opt.background = 'light'
      else
        vim.g.edge_style = 'default'
      end
      vim.g.edge_enable_italic = 1
      -- vim.g.edge_better_performance = 1
      vim.cmd.colorscheme('edge')
    end,
  },
}
