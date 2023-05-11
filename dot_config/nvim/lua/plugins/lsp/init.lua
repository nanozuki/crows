return {
  {
    'ray-x/lsp_signature.nvim',
    event = 'BufReadPre',
    config = function()
      local base = require('plugins.lsp.base')
      base.on_attaches[#base.on_attaches + 1] = function(_, _)
        require('lsp_signature').on_attach({ bind = true, handler_opts = { border = 'none' } })
      end
    end,
  },
  {
    'hrsh7th/cmp-nvim-lsp',
    event = 'BufReadPre',
    config = function()
      local base = require('plugins.lsp.base')
      base.capabilities[#base.capabilities + 1] = require('cmp_nvim_lsp').default_capabilities
    end,
  },
  { 'b0o/schemastore.nvim', ft = { 'json', 'yaml' } },
  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    config = function()
      local base = require('plugins.lsp.base')
      base.set_keymapping_and_sign()
      require('plugins.lsp.servers')
      base.set_lsp_format()
    end,
    dependencies = {
      'ray-x/lsp_signature.nvim',
      'hrsh7th/cmp-nvim-lsp',
      'b0o/schemastore.nvim',
      'jose-elias-alvarez/null-ls.nvim',
    },
  },
  {
    'folke/trouble.nvim',
    cmd = 'TroubleToggle',
    keys = { { '<leader>xx', ':TroubleToggle<CR>', 'n', { desc = 'Toggle trouble quickfix' } } },
    dependencies = { 'nvim-tree/nvim-web-devicons', 'neovim/nvim-lspconfig' },
    config = function()
      require('trouble').setup({
        signs = {
          error = vim.g.diag_signs.Error,
          warning = vim.g.diag_signs.Warn,
          information = vim.g.diag_signs.Info,
          hint = vim.g.diag_signs.Hint,
          other = '󰗡',
        },
      })
    end,
  },
  {
    'j-hui/fidget.nvim',
    event = 'BufReadPost',
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      require('fidget').setup({})
    end,
  },
  { import = 'plugins.lsp.null_ls' },
}
