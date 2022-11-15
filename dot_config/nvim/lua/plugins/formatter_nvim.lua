require('formatter').setup({
  filetype = require('config.languages').formatters,
})
local group = vim.api.nvim_create_augroup('format_on_save', {})
vim.api.nvim_create_autocmd('BufWritePost', {
  group = group,
  pattern = '*',
  command = 'silent! FormatWrite',
})
