-- Nanozuki Vim Config

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

vim.cmd([[command! FurReload      lua require('fur').reload()]])
vim.cmd([[command! FurPlugCompile lua require('fur').plug_compile()]])
vim.cmd([[command! FurPlugSync    lua require('fur').plug_sync()]])
