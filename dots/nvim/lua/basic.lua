local termcode = require("util/shim").termcode
local prequire = require("util/shim").prequire

vim.g.mapleader = " "
vim.opt.linebreak = true
vim.opt.showbreak = "->"
vim.opt.mouse = "ar"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = "120"
vim.opt.modelines = 1
-- use <ESC> to normal mode in terminal window
prequire("which-key", function(wk)
	wk.register({ ["<Esc>"] = { termcode([[<C-\><C-N>]]), "To normal mode" } }, { mode = "t" })
end)
