require('trouble').setup({
  signs = {
    error = vim.g.diag_signs.Error,
    warning = vim.g.diag_signs.Warn,
    information = vim.g.diag_signs.Info,
    hint = vim.g.diag_signs.Hint,
    other = '﫠',
  },
})
vim.keymap.set('n', '<leader>xx', '<cmd>TroubleToggle<cr>', { desc = 'Toggle Trouble' })
vim.keymap.set('n', '<leader>xw', '<cmd>Trouble wkspace_diagnostics<cr>', { desc = 'Workspace diagnostics' })
vim.keymap.set('n', '<leader>xd', '<cmd>Trouble document_diagnostics<cr>', { desc = 'Document diagnostics' })
vim.keymap.set('n', '<leader>xl', '<cmd>Trouble loclist<cr>', { desc = "Items from the window's location list" })
vim.keymap.set('n', '<leader>xq', '<cmd>Trouble quickfix<cr>', { desc = 'Quickfix items' })
