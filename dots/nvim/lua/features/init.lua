local crows = require('crows')

crows.execute('features/ui/init.lua')
crows.execute('features/basic.lua')
crows.execute('features/complete.lua')
crows.execute('features/editor.lua')
crows.execute('features/lsp.lua')
crows.execute('features/search.lua')
