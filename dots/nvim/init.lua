-- Nanozuki Vim Config
require("core").setup({
	require("features.basic"),
	require("features.ui"),
	require("features.editor"),
	require("features.search"),
	require("features.lsp"),
	require("features.complete"),
	require("lang"),
})
