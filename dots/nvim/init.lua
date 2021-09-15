-- Nanozuki Vim Config

-- local log = require("lib.log")
-- log.level = log.levels.debug

require("core").features = {
	require("features.basic"),
	require("features.ui"),
	require("features.editor"),
	require("features.search"),
	require("features.lsp"),
	require("features.complete"),
	require("lang"),
}
require("core").setup()
