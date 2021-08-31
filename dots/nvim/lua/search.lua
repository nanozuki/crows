local map = require("util/shim").map

map("n", "<leader>/", ":nohlsearch<CR>")
vim.opt.ignorecase = true

--- [plugin] ctrlsf {{{
vim.g["ctrlsf_ackprg"] = "rg"
map("", "<leader>sf", ":CtrlSF ") -- search current name
map("", "<leader>sp", ":CtrlSF<CR>") -- search in project
--- }}}

--- [plugin] telescope {{{
map("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>")
map("n", "<C-P>", "<cmd>lua require('telescope.builtin').find_files()<cr>")
map("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>")
map("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>")
map("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>")
