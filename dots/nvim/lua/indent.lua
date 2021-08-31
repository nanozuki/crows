local augroup = require("util/shim").augroup
local autocmd = require("util/shim").autocmd

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

--- [plugin] indentline {{{
vim.cmd("set list lcs=tab:\\¦\\ ")
vim.cmd("autocmd Filetype json let g:indentLine_enabled = 0")
--- }}}
