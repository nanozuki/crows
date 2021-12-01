local feature = require('fur.feature')

local lang = feature:new('lang')
lang.source = 'lua/lang/init.lua'
lang.plugins = {
  {
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
  },
}

lang.children = {
  require('lang/lua'),
  require('lang/go'),
  require('lang/rust'),
  require('lang/typescript'),
  require('lang/fish'),
  require('lang/others'),
}
return lang
