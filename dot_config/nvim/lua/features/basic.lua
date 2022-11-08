vim.g.mapleader = ' '
vim.opt.linebreak = true
vim.opt.showbreak = '->'
vim.opt.mouse = 'ar'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.modelines = 1
local aug = vim.api.nvim_create_augroup('colorcolumn', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  group = aug,
  pattern = { '*' },
  callback = function()
    vim.opt.colorcolumn = '120'
  end,
})
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  group = aug,
  pattern = { '*.txt', '*.md' },
  callback = function()
    vim.opt.colorcolumn = '80'
  end,
})
