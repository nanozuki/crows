local lspconfig = require("lspconfig")
local augroup = require("util/shim").augroup
local autocmd = require("util/shim").autocmd
local sign_define = require("util/shim").sign_define
local plugin = require("util/plugin")

plugin.use("neovim/nvim-lspconfig")
plugin.use("ray-x/lsp_signature.nvim")

local on_attach = function(_, bufnr) -- function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end

	-- Mappings.
	local opts = { noremap = true, silent = true }
	buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	buf_set_keymap("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	buf_set_keymap("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	buf_set_keymap("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
	buf_set_keymap("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	buf_set_keymap("n", "<leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
	buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
	buf_set_keymap("n", "<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
	buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

	require("lsp_signature").on_attach()
	augroup("lsp_format_on_save", {
		autocmd("BufWritePre", "<buffer>", "lua vim.lsp.buf.formatting_sync()"),
	})
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = { "documentation", "detail", "additionalTextEdits" },
}

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
	config["capabilities"] = capabilities
	lspconfig[name].setup(config)
end

return lsp
