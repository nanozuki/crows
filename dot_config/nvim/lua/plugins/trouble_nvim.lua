require('trouble').setup({
  signs = {
    error = vim.g.diag_signs.Error,
    warning = vim.g.diag_signs.Warn,
    information = vim.g.diag_signs.Info,
    hint = vim.g.diag_signs.Hint,
    other = '﫠',
  },
})
