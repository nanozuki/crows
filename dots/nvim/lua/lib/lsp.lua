local lspconfig = require("lspconfig")
local augroup = require("lib.util").augroup
local autocmd = require("lib.util").autocmd

local lsp = {}

local function buf_mapping(_, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
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
end

local function format_on_save()
	augroup("lsp_format_on_save", {
		autocmd("BufWritePre", "<buffer>", "lua vim.lsp.buf.formatting_sync()"),
	})
end

lsp.on_attaches = {
	buf_mapping,
	format_on_save,
}

function lsp.add_on_attach(fn)
	lsp.on_attaches[#lsp.on_attaches + 1] = fn
end

function lsp.on_attach(client, bufnr) -- function(client, bufnr)
	for _, fn in ipairs(lsp.on_attaches) do
		fn(client, bufnr)
	end
end

function lsp.capabilities()
	local caps = vim.lsp.protocol.make_client_capabilities()
	caps.textDocument.completion.completionItem.snippetSupport = true
	caps.textDocument.completion.completionItem.resolveSupport = {
		properties = { "documentation", "detail", "additionalTextEdits" },
	}
	local exists, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if exists then
		return cmp_nvim_lsp.update_capabilities(caps)
	else
		return caps
	end
end

function lsp.set_config(name, config)
	config["on_attach"] = lsp.on_attach
	config["capabilities"] = lsp.capabilities()
	lspconfig[name].setup(config)
end

return lsp
