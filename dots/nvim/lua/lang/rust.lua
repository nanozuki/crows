local feature = require("fur.feature")

local rust = feature:new("lang.rust")
rust.source = "lua/lang/rust.lua"
rust.setup = function()
	require("lib.lsp").set_config("rust_analyzer", {
		settings = {
			["rust-analyzer"] = {
				diagnostics = { disabled = { "unresolved-proc-macro" } },
				checkOnSave = { command = "clippy" },
			},
		},
	})
end

return rust
