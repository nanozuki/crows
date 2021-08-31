local termcode = require("util/shim").termcode
local wk = require("which-key")

vim.g.mapleader = " "
vim.opt.linebreak = true
vim.opt.showbreak = "->"
vim.opt.mouse = "ar"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = "120"
vim.opt.modelines = 1
-- use <ESC> to normal mode in terminal window
wk.register({ ["<Esc>"] = { termcode([[<C-\><C-N>]]), "To normal mode" } }, { mode = "t" })
