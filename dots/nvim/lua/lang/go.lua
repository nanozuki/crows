local crows = require('crows')

crows.use_plugin({
  'ray-x/go.nvim',
  ft = { 'go', 'gomod' },
  config = function()
    require('go').setup()
  end,
})
crows.setup(function()
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
end)
