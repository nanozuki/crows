local map = require("util/shim").map

vim.g.mapleader = " "
vim.opt.linebreak = true
vim.opt.showbreak = "->"
vim.opt.mouse = "ar"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = "120"
vim.opt.modelines = 1
-- use <ESC> to normal mode in terminal window
map("t", "<Esc>", [[<C-\><C-N>]])
