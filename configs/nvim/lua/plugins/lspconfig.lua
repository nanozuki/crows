local globals = require('config.globals')
local settings = globals.settings
local lsp = globals.lsp

return {
  -- # load before nvim-lspconfig
  {
    'ray-x/lsp_signature.nvim',
    lazy = true,
    enabled = not settings.hide_command_line,
    init = function()
      lsp.on_attach_hooks[#lsp.on_attach_hooks + 1] = function(client, bufnr)
        require('lsp_signature').on_attach({ bind = true, handler_opts = { border = 'none' } }, client, bufnr)
      end
    end,
  },
  {
    'hrsh7th/cmp-nvim-lsp',
    lazy = true,
    init = function()
      lsp.cap_makers[#lsp.cap_makers + 1] = function(caps)
        return vim.tbl_deep_extend('force', caps, require('cmp_nvim_lsp').default_capabilities())
      end
    end,
  },
  -- # nvim-lspconfig
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      vim.lsp.inlay_hint.enable()
      local lspconfig = require('lspconfig')
      lsp.make_config = function(server_name)
        local server = lsp.servers[server_name] or {}
        local config = server.config or {}
        if server.root_patterns then
          config.root_dir = require('lspconfig.util').root_pattern(unpack(server.root_patterns))
        end
        config.on_attach = function(client, bufnr)
          for _, hook in ipairs(lsp.on_attach_hooks) do
            hook(client, bufnr)
          end
          if server.on_attach then
            server.on_attach(client, bufnr)
          end
        end
        config.capabilities = {}
        for _, maker in ipairs(lsp.cap_makers) do
          config.capabilities = maker(config.capabilities)
        end
        return config
      end
      lsp.setup = function(server_name)
        lspconfig[server_name].setup(lsp.make_config(server_name))
      end
      for name, server in pairs(lsp.servers) do
        if not server.lazyload then
          lsp.setup(name)
        end
      end
    end,
    dependencies = {
      'b0o/schemastore.nvim',
    },
  },
  -- # load after nvim-lspconfig
  {
    'folke/trouble.nvim',
    cmd = 'TroubleToggle',
    keys = { { '<leader>xx', ':TroubleToggle<CR>', 'n', desc = 'Toggle trouble quickfix' } },
    dependencies = { 'nvim-tree/nvim-web-devicons', 'neovim/nvim-lspconfig' },
    config = function()
      require('trouble').setup({
        signs = {
          error = globals.diagnostic_signs.Error,
          warning = globals.diagnostic_signs.Warn,
          information = globals.diagnostic_signs.Info,
          hint = globals.diagnostic_signs.Hint,
          other = '󰗡',
        },
      })
    end,
  },
  {
    'kosayoda/nvim-lightbulb',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'neovim/nvim-lspconfig' },
    opts = {
      sign = { enabled = false },
      virtual_text = { enabled = true, text = '' },
      autocmd = { enabled = true },
      float = {},
    },
  },
}
