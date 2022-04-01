local crows = require('crows')
local util = require('crows.util')

vim.g.mapleader = ' '
vim.opt.linebreak = true
vim.opt.showbreak = '->'
vim.opt.mouse = 'ar'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = '120'
vim.opt.modelines = 1

crows.key.map('Open terminal in new tab', 'n', '<leader>tt', ':tabnew | terminal<CR>')
crows.key.map('To normal mode in terminal', 't', '<Esc>', util.termcode([[<C-\><C-N>]]))

crows.plugin.use('lewis6991/impatient.nvim')
crows.plugin.use({
  'rmagatti/auto-session',
  config = function()
    vim.opt.sessionoptions = 'curdir,folds,help,tabpages,terminal,winsize'
    require('auto-session').setup({
      pre_save_cmds = { 'NvimTreeClose' },
      auto_session_suppress_dirs = { '~' },
    })
    local u = require('crows.util')
    u.augroup('renew_auto_session_cwd', {
      u.autocmd('DirChanged', 'global', 'lua require("auto-session-library").conf.last_loaded_session = nil'),
    })
    require('crows').key.maps({
      ['<leader>s'] = {
        r = { '<cmd>RestoreSession<cr>', 'Restore session' },
        s = { '<cmd>SaveSession<cr>', 'Save session' },
      },
    })
  end,
})
