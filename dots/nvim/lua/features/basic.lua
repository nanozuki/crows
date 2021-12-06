local crows = require('crows')
local util = require('lib.util')

vim.g.mapleader = ' '
vim.opt.linebreak = true
vim.opt.showbreak = '->'
vim.opt.mouse = 'ar'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = '120'
vim.opt.modelines = 1

crows.map('Open terminal', 'n', '<leader>tt', ':tabnew | terminal<CR>')
crows.map('To normal mode in terminal', 't', '<Esc>', util.termcode([[<C-\><C-N>]]))

crows.use_plugin({
  'rmagatti/auto-session',
  config = function()
    vim.opt.sessionoptions = 'curdir,folds,help,tabpages,terminal,winsize'
    require('auto-session').setup({
      pre_save_cmds = { 'NvimTreeClose' },
      auto_session_suppress_dirs = { '~' },
    })
    local u = require('lib.util')
    u.augroup('renew_auto_session_cwd', {
      u.autocmd('DirChanged', 'global', 'lua require("auto-session-library").conf.last_loaded_session = nil'),
    })
  end,
})
