local map = require("util/shim").map
local prequire = require("util/shim").prequire

-- sign
-- local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " } -- used by "nvim.trouble"
local signs = { Error = "✗", Warning = "‼", Information = "!", Hint = "!" }
for sign, text in pairs(signs) do
	local hl = "LspDiagnosticsSign" .. sign
	vim.fn.sign_define(hl, { text = text, texthl = hl, linehl = "", numhl = "" })
end

-- [plugin] lsputils {{{
vim.lsp.handlers["textDocument/codeAction"] = require("lsputil.codeAction").code_action_handler
vim.lsp.handlers["textDocument/references"] = require("lsputil.locations").references_handler
vim.lsp.handlers["textDocument/definition"] = require("lsputil.locations").definition_handler
vim.lsp.handlers["textDocument/declaration"] = require("lsputil.locations").declaration_handler
vim.lsp.handlers["textDocument/typeDefinition"] = require("lsputil.locations").typeDefinition_handler
vim.lsp.handlers["textDocument/implementation"] = require("lsputil.locations").implementation_handler
vim.lsp.handlers["textDocument/documentSymbol"] = require("lsputil.symbols").document_handler
vim.lsp.handlers["workspace/symbol"] = require("lsputil.symbols").workspace_handler
--- }}}

--- [plugin] nvim.trouble {{{
prequire("trouble", function(trouble)
	trouble.setup({})
end)
map("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { silent = true })
-- map("n", "<leader>xw", "<cmd>Trouble lsp_workspace_diagnostics<cr>", { silent = true })
-- map("n", "<leader>xd", "<cmd>Trouble lsp_document_diagnostics<cr>", { silent = true })
map("n", "<leader>xl", "<cmd>Trouble loclist<cr>", { silent = true })
map("n", "<leader>xq", "<cmd>Trouble quickfix<cr>", { silent = true })
--- }}}
