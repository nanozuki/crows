require("util/lsp").set_config("rust_analyzer", {
	settings = {
		["rust-analyzer"] = {
			diagnostics = { disabled = { "unresolved-proc-macro" } },
			checkOnSave = { command = "clippy" },
		},
	},
})
