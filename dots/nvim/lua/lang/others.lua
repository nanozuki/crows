local lsp = require("util/lsp")

local simple_servers = {
	"graphql",
	"pylsp",
	"pyright",
	"vimls",
	"zls",
	"terraformls",
	"yamlls",
}

for _, name in ipairs(simple_servers) do
	lsp.set_config(name, {})
end
