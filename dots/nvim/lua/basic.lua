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

-- tmuxline {{{
function Tmuxline(mode)
	vim.cmd("packadd tmuxline.vim")
	if mode == "insert" then
		vim.cmd("Tmuxline airline_insert")
	elseif mode == "visual" then
		vim.cmd("Tmuxline airline_visual")
	else
		vim.cmd("Tmuxline airline")
	end
end

function TmuxlineSnapshot(file)
	vim.cmd("packadd tmuxline.vim")
	vim.cmd("TmuxlineSnapshot " .. file)
end
-- }}}
