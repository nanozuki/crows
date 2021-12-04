local crows = require('crows')

crows.setup(function()
  local lsp = require('lib.lsp')
  local simple_servers = {
    'graphql',
    'vimls',
    'zls',
    'terraformls',
    'yamlls',
  }

  for _, name in ipairs(simple_servers) do
    lsp.set_config(name, {})
  end
end)
