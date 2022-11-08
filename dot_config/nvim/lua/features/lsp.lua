local signs = { Error = '', Warn = '', Info = '', Hint = '' }
for sign, text in pairs(signs) do
  local hl = 'DiagnosticSign' .. sign
  vim.fn.sign_define(hl, { text = text, texthl = hl, linehl = '', numhl = '' })
end

require('crows.lsp').add_on_attach(function(_, _)
  require('lsp_signature').on_attach({ bind = true, handler_opts = { border = 'none' } })
end)
