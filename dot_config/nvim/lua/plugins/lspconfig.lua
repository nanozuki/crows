local values = require('config.values')
local lsp = require('config.lsp')
local langs = require('config.langs')

return {
  -- # load before nvim-lspconfig
  {
    'ray-x/lsp_signature.nvim',
    lazy = true,
    config = function()
      lsp.on_attach_callbacks[#lsp.on_attach_callbacks + 1] = function(_, _)
        require('lsp_signature').on_attach({ bind = true, handler_opts = { border = 'none' } })
      end
    end,
  },
  {
    'hrsh7th/cmp-nvim-lsp',
    lazy = true,
    config = function()
      lsp.capabilities[#lsp.capabilities + 1] = require('cmp_nvim_lsp').default_capabilities
    end,
  },
  -- # nvim-lspconfig
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lspconfig = require('lspconfig')
      local setup = function(name, config)
        local load = (config.meta or {}).delayed_start ~= true
        if load then
          config.on_attach = lsp.on_attach
          config.capabilities = lsp.make_capabilities()
          if config.meta and config.meta.root_patterns then
            config.root_dir = require('lspconfig.util').root_pattern(unpack(config.meta.root_patterns))
          end
          lspconfig[name].setup(config)
        end
      end
      for _, lang in pairs(langs) do
        if lang.enable then
          for name, config in pairs(lang.servers or {}) do
            setup(name, config)
          end
        end
      end
    end,
    dependencies = {
      'ray-x/lsp_signature.nvim',
      'hrsh7th/cmp-nvim-lsp',
      'b0o/schemastore.nvim',
    },
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
          error = values.diagnostic_signs.Error,
          warning = values.diagnostic_signs.Warn,
          information = values.diagnostic_signs.Info,
          hint = values.diagnostic_signs.Hint,
          other = '󰗡',
        },
      })
    end,
  },
  {
    'j-hui/fidget.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      require('fidget').setup({})
    end,
  },
}
