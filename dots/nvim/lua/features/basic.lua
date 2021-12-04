local crows = require('crows')

crows.use_plugin({
  'rmagatti/auto-session',
  config = function()
    vim.opt.sessionoptions = 'curdir,folds,help,tabpages,terminal,winsize'
    require('auto-session').setup({
      pre_save_cmds = { 'NvimTreeClose' },
      auto_session_suppress_dirs = { '~' },
    })
  end,
})

crows.setup(function()
  vim.opt.linebreak = true
  vim.opt.showbreak = '->'
  vim.opt.mouse = 'ar'
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.colorcolumn = '120'
  vim.opt.modelines = 1
end)

crows.map('Open terminal', 'n', '<leader>tt', ':terminal<CR>')
crows.map('To normal mode in terminal', 't', '<Esc>', [[<C-\><C-N>]])
