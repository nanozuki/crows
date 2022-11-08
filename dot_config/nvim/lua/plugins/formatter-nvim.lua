local fmt = require('features.format')
require('formatter').setup({
  filetype = fmt.by_formatter,
})
local group = vim.api.nvim_create_augroup('format_on_save', {})
vim.api.nvim_create_autocmd('BufWritePost', {
  group = group,
  pattern = '*',
  command = 'silent! FormatWrite',
})
vim.api.nvim_create_autocmd('BufWritePost', {
  group = group,
  pattern = table.concat(fmt.by_lsp, ','),
  callback = vim.lsp.buf.formatting_seq_sync,
})
