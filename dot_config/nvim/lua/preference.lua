local theme = require('config.theme')
local lang = require('config.languages')

return {
  palette = theme.use('rose_pine_dawn'),
  formatters = lang.use(lang.go, lang.rust, lang.typescript, lang.terraform, lang.zig),
}
