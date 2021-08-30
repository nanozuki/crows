local noremap = require("util/shim").noremap

vim.g.mapleader = " "
vim.opt.linebreak = true
vim.opt.showbreak = "->"
vim.opt.mouse = "ar"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = "120"
vim.opt.modelines = 1
-- use <ESC> to normal mode in terminal window
noremap("t", "<Esc>", [[<C-\><C-N>]])
