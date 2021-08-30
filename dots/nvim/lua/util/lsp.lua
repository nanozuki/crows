local lspconfig = require("lspconfig")
local augroup = require("util/shim").augroup
local autocmd = require("util/shim").autocmd
local set_highlight = require("util/shim").set_highlight
local sign_define = require("util/shim").sign_define
local plugin = require("util/plugin")

plugin.use("neovim/nvim-lspconfig")

local on_attach = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	local opts = { noremap = true, silent = true }
	buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	buf_set_keymap("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "[g", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "]g", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
	buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	buf_set_keymap("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	buf_set_keymap("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	buf_set_keymap("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
	buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap("n", "<leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
	buf_set_keymap("n", "<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)

	-- Set some keybinds conditional on server capabilities
	if client.resolved_capabilities.document_formatting then
		buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
	end
	if client.resolved_capabilities.document_range_formatting then
		buf_set_keymap("v", "<leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
	end

	-- Set autocommands conditional on server_capabilities
	if client.resolved_capabilities.document_highlight then
		set_highlight("LspReferenceRead", { cterm = "bold", ctermbg = "red", guibg = "LightYellow" })
		set_highlight("LspReferenceText", { cterm = "bold", ctermbg = "red", guibg = "LightYellow" })
		set_highlight("LspReferenceWrite", { cterm = "bold", ctermbg = "red", guibg = "LightYellow" })
		augroup("lsp_document_highlight", {
			autocmd("CursorHold", "<buffer>", "lua vim.lsp.buf.document_highlight()"),
			autocmd("CursorMoved", "<buffer>", "lua vim.lsp.buf.clear_references()"),
			autocmd("CursorHold", "<buffer>", "lua vim.lsp.diagnostic.show_line_diagnostics()"),
		})
	end

	augroup("lsp_format_on_save", {
		autocmd("BufWritePre", "<buffer>", "lua vim.lsp.buf.formatting_sync(nil, 1000)"),
	})
end

sign_define("LspDiagnosticsSignError", { text = "✗", texthl = "LspDiagnosticsError", linehl = "", numhl = "" })
sign_define("LspDiagnosticsSignWarning", { text = "‼", texthl = "LspDiagnosticsWarning", linehl = "", numhl = "" })
sign_define(
	"LspDiagnosticsSignInformation",
	{ text = "!", texthl = "LspDiagnosticsInformation", linehl = "", numhl = "" }
)
sign_define("LspDiagnosticsSignHint", { text = "!", texthl = "LspDiagnosticsHint", linehl = "", numhl = "" })

local lsp = {}

function lsp.set_config(name, config)
	config["on_attach"] = on_attach
	lspconfig[name].setup(config)
end

return lsp
