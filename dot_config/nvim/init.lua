-- Nanozuki Vim Config

local crows = require('crows')
crows.plugin.bootstrap()

require('features')
require('ui')
require('lang')

crows.setup({
  reload_modules = {
    'features',
    'lang',
    'ui',
  },
})
