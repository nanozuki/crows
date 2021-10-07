local feature = require('fur.feature')

local others = feature:new('lang.others')

others.source = 'lua/lang/others.lua'
others.setup = function()
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
end

return others
