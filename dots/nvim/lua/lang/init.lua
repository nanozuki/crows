local feature = require('fur.feature')

local lang = feature:new('lang')
lang.source = 'lua/lang/init.lua'
lang.children = {
  require('lang/lua'),
  require('lang/go'),
  require('lang/rust'),
  require('lang/typescript'),
  require('lang/fish'),
  require('lang/others'),
}
return lang
