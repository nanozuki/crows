local util = require("lspconfig/util")
require("util/lsp").set_config("tsserver", {
	root_dir = function(fname)
		return util.root_pattern("tsconfig.json")(fname) or util.root_pattern("package.json", "jsconfig.json")(fname)
	end,
})
require("util/lsp").set_config("denols", {
	root_dir = util.root_pattern("deno_root"),
	init_options = {
		enable = true,
		lint = true,
		unstable = true,
	},
})
