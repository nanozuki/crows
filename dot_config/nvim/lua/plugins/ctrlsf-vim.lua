vim.g.ctrlsf_ackprg = 'rg'
-- if use which-key, the prompt will not display immediately
vim.api.nvim_set_keymap('n', '<leader>sf', ':CtrlSF ', { noremap = true })
require('crows').key.map('Search in cursor', 'n', '<leader>sp', ':CtrlSF<CR>')
