local sign_define = require("util/shim").sign_define

-- sign
sign_define("LspDiagnosticsSignError", { text = "✗", texthl = "LspDiagnosticsError", linehl = "", numhl = "" })
sign_define("LspDiagnosticsSignWarning", { text = "‼", texthl = "LspDiagnosticsWarning", linehl = "", numhl = "" })
sign_define(
	"LspDiagnosticsSignInformation",
	{ text = "!", texthl = "LspDiagnosticsInformation", linehl = "", numhl = "" }
)
sign_define("LspDiagnosticsSignHint", { text = "!", texthl = "LspDiagnosticsHint", linehl = "", numhl = "" })

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
