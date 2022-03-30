local crows = require('crows')

local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')
local lsp = require('lib.lsp')

if not configs.golangcilsp then
  configs.golangcilsp = {
    default_config = {
      cmd = { 'golangci-lint-langserver' },
      root_dir = lspconfig.util.root_pattern('.git', 'go.mod'),
      filetypes = { 'go' },
      init_options = {
        command = { 'golangci-lint', 'run', '--fast', '--out-format', 'json' },
      },
    },
  }
end

lsp.set_config('gopls', {})
lsp.set_config('golangcilsp', {})

crows.plugin.use({
  'ray-x/go.nvim',
  ft = { 'go', 'gomod' },
  config = function()
    require('go').setup()
  end,
})
