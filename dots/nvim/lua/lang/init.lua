local crows = require('crows')

crows.execute('lang/lua.lua')
crows.execute('lang/go.lua')
crows.execute('lang/rust.lua')
crows.execute('lang/typescript.lua')
crows.execute('lang/fish.lua')

crows.use_plugin({
  'lukas-reineke/format.nvim',
  config = function()
    local eslint = { cmd = { 'npx eslint --fix' } }
    require('format').setup({
      ['*'] = { { cmd = { "sed -i 's/[ \t]*$//'" } } }, -- remove trailing whitespace
      go = { { cmd = { 'goimports -w' } } },
      lua = { { cmd = { 'stylua' } } },
      typescript = { eslint },
      javascript = { eslint },
      typescriptreact = { eslint },
      javascriptreact = { eslint },
    })
    local augroup = require('lib.util').augroup
    local autocmd = require('lib.util').autocmd
    augroup('format_on_save', {
      autocmd('BufWritePost', '*', 'FormatWrite'),
    })
  end,
})

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
