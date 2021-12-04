-- Nanozuki Vim Config

local crows = require('crows')

crows.execute('features/init.lua')
crows.execute('lang/init.lua')

crows.run()

vim.cmd([[command! CrowsReload lua require('crows').reload()]])
vim.cmd([[command! CrowsResync lua require('crows').resync()]])
vim.cmd([[command! CrowsUpdate lua require('crows').external_resync()]])
