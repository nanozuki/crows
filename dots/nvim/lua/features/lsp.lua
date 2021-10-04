local feature = require("fur.feature")

local lsp = feature:new("lsp")
lsp.source = "lua/features/lsp.lua"
lsp.plugins = {
	"neovim/nvim-lspconfig",
	{
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("trouble").setup({})
		end,
	}, -- lsp signature
}
lsp.setup = function()
	-- local signs = { Error = "", Warning = "", Hint = "", Information = "" }
	local signs = { Error = "✗", Warning = "‼", Information = "!", Hint = "!" } -- also used by "nvim.trouble"
	for sign, text in pairs(signs) do
		local hl = "LspDiagnosticsSign" .. sign
		vim.fn.sign_define(hl, { text = text, texthl = hl, linehl = "", numhl = "" })
	end
end
lsp.mappings = {
	{ "n", "<leader>xx", "<cmd>TroubleToggle<cr>", { silent = true } },
	-- { "n", "<leader>xw", "<cmd>Trouble lsp_workspace_diagnostics<cr>", { silent = true } },
	-- { "n", "<leader>xd", "<cmd>Trouble lsp_document_diagnostics<cr>", { silent = true } },
	{ "n", "<leader>xl", "<cmd>Trouble loclist<cr>", { silent = true } },
	{ "n", "<leader>xq", "<cmd>Trouble quickfix<cr>", { silent = true } },
}

local lspui_ext = feature:new("lspui_ext")
lspui_ext.plugins = {
	{
		"ray-x/lsp_signature.nvim",
		config = function()
			require("lib.lsp").add_on_attach(function(_, _)
				require("lsp_signature").on_attach({ bind = true, handler_opts = { border = "none" } })
			end)
		end,
	},
	{
		"RishabhRD/nvim-lsputils",
		requires = { { "RishabhRD/popfix" } },
		config = function()
			vim.lsp.handlers["textDocument/codeAction"] = require("lsputil.codeAction").code_action_handler
			vim.lsp.handlers["textDocument/references"] = require("lsputil.locations").references_handler
			vim.lsp.handlers["textDocument/definition"] = require("lsputil.locations").definition_handler
			vim.lsp.handlers["textDocument/declaration"] = require("lsputil.locations").declaration_handler
			vim.lsp.handlers["textDocument/typeDefinition"] = require("lsputil.locations").typeDefinition_handler
			vim.lsp.handlers["textDocument/implementation"] = require("lsputil.locations").implementation_handler
			vim.lsp.handlers["textDocument/documentSymbol"] = require("lsputil.symbols").document_handler
			vim.lsp.handlers["workspace/symbol"] = require("lsputil.symbols").workspace_handler
		end,
	},
}

lsp.children = { lspui_ext }
return lsp
