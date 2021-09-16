-- Nanozuki Vim Config

local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/fur.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.system({ "git", "clone", "https://github.com/nanozuki/fur.nvim", install_path })
	vim.cmd("packadd fur.nvim")
end

vim.cmd([[command! FurReload      lua require('fur').reload()]])
vim.cmd([[command! FurPlugCompile lua require('fur').plug_compile()]])
vim.cmd([[command! FurPlugSync    lua require('fur').plug_sync()]])

local fur = require("fur")
fur.features = {
	require("features.basic"),
	require("features.ui"),
	require("features.editor"),
	require("features.search"),
	require("features.lsp"),
	require("features.complete"),
	require("lang"),
}
fur.start()
