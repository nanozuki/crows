local noremap = require("util/shim").noremap

noremap("n", "<leader>/", ":nohlsearch<CR>")
vim.opt.ignorecase = true

--- [plugin] ctrlsf {{{
vim.g["ctrlsf_ackprg"] = "rg"
noremap("", "<leader>sf", ":CtrlSF ") -- search current name
noremap("", "<leader>sp", ":CtrlSF<CR>") -- search in project
--- }}}

--- [plugin] telescope {{{
vim.api.nvim_exec(
	[[
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
]],
	true
)
