-- Nanozuki Vim Config

local crows = require('crows')

crows.must_install('packer.nvim', 'https://github.com/wbthomason/packer.nvim.git', 'opt')
crows.must_install('which-key.nvim', 'https://github.com/folke/which-key.nvim', 'start')
crows.must_install('nvim-lspconfig', 'https://github.com/neovim/nvim-lspconfig', 'start')

crows.execute('features/init.lua')
crows.execute('ui/init.lua')
crows.execute('lang/init.lua')

crows.run()

vim.cmd([[command! CrowsReload lua require('crows').reload()]])
vim.cmd([[command! CrowsResync lua require('crows').resync()]])
vim.cmd([[command! CrowsUpdate lua require('crows').external_resync()]])
