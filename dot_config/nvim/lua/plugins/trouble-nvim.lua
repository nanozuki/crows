require('trouble').setup({
  signs = { error = '', warning = '', hint = '', information = '', other = '﫠' },
})
require('crows').key.maps({
  ['<leader>x'] = {
    name = 'lsp trouble',
    x = { '<cmd>TroubleToggle<cr>', 'Toggle Trouble' },
    w = { '<cmd>Trouble lsp_workspace_diagnostics<cr>', 'Workspace diagnostics' },
    d = { '<cmd>Trouble lsp_document_diagnostics<cr>', 'Document diagnostics' },
    l = { '<cmd>Trouble loclist<cr>', "Items from the window's location list" },
    q = { '<cmd>Trouble quickfix<cr>', 'Quickfix items' },
  },
})
