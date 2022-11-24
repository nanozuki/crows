local signs = require('config.lsp').signs
require('trouble').setup({
  signs = {
    error = signs.Error,
    warning = signs.Warn,
    information = signs.Info,
    hint = signs.Hint,
    other = '﫠',
  },
})
vim.keymap.set('n', '<leader>xx', '<cmd>TroubleToggle<cr>', { desc = 'Toggle Trouble' })
vim.keymap.set('n', '<leader>xw', '<cmd>Trouble lsp_workspace_diagnostics<cr>', { desc = 'Workspace diagnostics' })
vim.keymap.set('n', '<leader>xd', '<cmd>Trouble lsp_document_diagnostics<cr>', { desc = 'Document diagnostics' })
vim.keymap.set('n', '<leader>xl', '<cmd>Trouble loclist<cr>', { desc = "Items from the window's location list" })
vim.keymap.set('n', '<leader>xq', '<cmd>Trouble quickfix<cr>', { desc = 'Quickfix items' })
