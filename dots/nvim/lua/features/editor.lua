local feature = require("fur.feature")
local augroup = require("lib.util").augroup
local autocmd = require("lib.util").autocmd

local editor = feature:new("editor")
editor.source = "lua/features/editor.lua"
editor.plugins = {
	"kshenoy/vim-signature", -- display sign for marks
	"mg979/vim-visual-multi",
	"tpope/vim-surround", -- cs"': "a"->'a', ysiw]: word->[word], cs]{: [word]->{ word }
}
editor.setup = function()
	vim.cmd("syntax enable")
	vim.opt.foldmethod = "indent"
	vim.opt.foldlevelstart = 99
	vim.cmd("set wildignore+=*/node_modules/*,*.swp,*.pyc,*/venv/*,*/target/*,.DS_Store") -- ignore file for all
	augroup("filetypes", {
		autocmd("BufNewFile,BufRead", "*html", "setfiletype html"),
		autocmd("BufNewFile,BufRead", "tsconfig.json", "setfiletype jsonc"),
		autocmd("BufNewFile,BufRead", "*.zig", "setfiletype zig"),
	})
end
editor.mappings = {
	{ "v", "<Leader>y", '"+y' }, -- copy selection to system clipboard
	{ "n", "<Leader>p", '"+p' }, -- paste from system clipboard
	{ "c", "w!!", "w !sudo tee %" }, -- save as sudo
}

local format = feature:new("format")
format.plugins = {
	"dense-analysis/ale",
}
format.setup = function()
	vim.g.ale_disable_lsp = 1
	vim.g.ale_fix_on_save = 1
	vim.g.ale_sign_error = "✗"
	vim.g.ale_sign_warning = "‼"
	local ale_config = {
		javascript = { "eslint" },
		javascriptreact = { "eslint" },
		typescript = { "eslint" },
		typescriptreact = { "eslint" },
		go = { "goimports" },
		lua = { "stylua" },
	}
	vim.g.ale_linters = ale_config
	vim.g.ale_fixers = ale_config
end

local indent = feature:new("indent")
indent.plugins = {
	{
		"yggdroot/indentline",
		config = function()
			vim.cmd("set list lcs=tab:\\¦\\ ")
			vim.cmd("autocmd Filetype json let g:indentLine_enabled = 0")
		end,
	}, -- display hint for indent
	"tpope/vim-sleuth", -- smart detect indent of file
}
indent.setup = function()
	vim.cmd("filetype indent on")
	vim.opt.expandtab = true
	vim.opt.tabstop = 4
	vim.opt.shiftwidth = 4
	vim.opt.softtabstop = 4
	augroup("fileindent", {
		autocmd(
			"FileType",
			"javascript,typescript,javascriptreact,typescriptreact,html,css,scss,xml,yaml,json",
			"setlocal expandtab ts=2 sw=2 sts=2"
		),
	})
end

editor.children = { format, indent }
return editor
