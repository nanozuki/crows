local feature = require("fur.feature")

local basic = feature:new("basic")
basic.source = "lua/features/basic.lua"
basic.plugins = {
	{ "wbthomason/packer.nvim", opt = true },
	"nvim-lua/plenary.nvim", -- basic lua library extension
	{
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({})
		end,
	}, -- key mapping manage and hint
}
basic.setup = function()
	vim.g.mapleader = " "
	vim.opt.linebreak = true
	vim.opt.showbreak = "->"
	vim.opt.mouse = "ar"
	vim.opt.number = true
	vim.opt.relativenumber = true
	vim.opt.colorcolumn = "120"
	vim.opt.modelines = 1
end
basic.mappings = {
	{ "t", "<Esc>", [[<C-\><C-N>]] }, -- use <ESC> to normal mode in terminal window
}

return basic
