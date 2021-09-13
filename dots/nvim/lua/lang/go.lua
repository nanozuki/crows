local lspconfig = require("lspconfig")
local configs = require("lspconfig/configs")
local lsp = require("lib.lsp")

if not lspconfig.golangcilsp then
	configs.golangcilsp = {
		default_config = {
			cmd = { "golangci-lint-langserver" },
			root_dir = lspconfig.util.root_pattern(".git", "go.mod"),
			filetypes = { "go" },
			init_options = {
				command = { "golangci-lint", "run", "--fast", "--out-format", "json" },
			},
		},
	}
end

lsp.set_config("gopls", {})
lsp.set_config("golangcilsp", {})
