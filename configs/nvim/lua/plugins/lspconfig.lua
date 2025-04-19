local globals = require('config.globals')
local lsp = globals.lsp

return {
  -- # load before nvim-lspconfig
  {
    'chrisgrieser/nvim-lsp-endhints',
    event = 'LspAttach',
    init = function()
      vim.lsp.inlay_hint.enable()
    end,
    opts = {}, -- required, even if empty
  },
  -- # nvim-lspconfig
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
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
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', 'n', desc = 'Toggle trouble quickfix' },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
    },
    dependencies = { 'nvim-tree/nvim-web-devicons', 'neovim/nvim-lspconfig' },
    opts = {},
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
