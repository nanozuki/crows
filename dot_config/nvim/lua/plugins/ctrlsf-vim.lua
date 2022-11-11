vim.g.ctrlsf_ackprg = 'rg'
-- if use which-key, the prompt will not display immediately
vim.keymap.set('n', '<leader>sf', ':CtrlSF ', { desc = 'search in files' })
vim.keymap.set('n', '<leader>sp', ':CtrlSF<CR>', { desc = 'Search in cursor' })
