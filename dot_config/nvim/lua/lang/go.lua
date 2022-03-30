local crows = require('crows')
local lsp = require('crows.lsp')
local lspconfig = require('lspconfig')

lsp.set_config('gopls', {})
lsp.add_default('golangcilsp', {
  cmd = { 'golangci-lint-langserver' },
  root_dir = lspconfig.util.root_pattern('.git', 'go.mod'),
  filetypes = { 'go' },
  init_options = {
    command = { 'golangci-lint', 'run', '--fast', '--out-format', 'json' },
  },
})
lsp.set_config('golangcilsp', {})

crows.plugin.use({
  'ray-x/go.nvim',
  ft = { 'go', 'gomod' },
  config = function()
    require('go').setup()
  end,
})
