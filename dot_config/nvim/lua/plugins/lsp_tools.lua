local store = require('config.store')

return {
  -- # load before nvim-lspconfig
  {
    'ray-x/lsp_signature.nvim',
    lazy = true,
    config = function()
      local base = require('config.lsp_base')
      base.on_attaches[#base.on_attaches + 1] = function(_, _)
        require('lsp_signature').on_attach({ bind = true, handler_opts = { border = 'none' } })
      end
    end,
  },
  {
    'hrsh7th/cmp-nvim-lsp',
    lazy = true,
    config = function()
      local base = require('config.lsp_base')
      base.capabilities[#base.capabilities + 1] = require('cmp_nvim_lsp').default_capabilities
    end,
  },
  {
    'b0o/schemastore.nvim',
    lazy = true,
    ft = { 'json', 'yaml' },
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    lazy = true,
    config = function()
      local null_ls = require('null-ls')
      local custom = require('config.custom')
      local base = require('config.lsp_base')

      -- builtins languages
      local sources = {
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.stylua,
      }
      local format_types = {}
      vim.list_extend(format_types, null_ls.builtins.formatting.prettier.filetypes)
      vim.list_extend(format_types, null_ls.builtins.formatting.stylua.filetypes)

      -- optional languages
      if custom.opt_languages.go then
        vim.list_extend(sources, {
          null_ls.builtins.formatting.goimports,
          null_ls.builtins.code_actions.gomodifytags,
          null_ls.builtins.code_actions.impl,
          -- TODO: waiting gotests: https://github.com/jose-elias-alvarez/null-ls.nvim/pull/1362
        })
        vim.list_extend(format_types, { 'go' })
      end
      null_ls.setup({ sources = sources })
      vim.list_extend(format_types, { 'go' })
      base.formatters['null-ls'] = format_types
    end,
  },
  -- # load after nvim-lspconfig
  {
    'folke/trouble.nvim',
    cmd = 'TroubleToggle',
    keys = { { '<leader>xx', ':TroubleToggle<CR>', 'n', { desc = 'Toggle trouble quickfix' } } },
    dependencies = { 'nvim-tree/nvim-web-devicons', 'neovim/nvim-lspconfig' },
    config = function()
      require('trouble').setup({
        signs = {
          error = store.diagnostic_signs.Error,
          warning = store.diagnostic_signs.Warn,
          information = store.diagnostic_signs.Info,
          hint = store.diagnostic_signs.Hint,
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
}
