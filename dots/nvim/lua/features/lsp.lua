local crows = require('crows')

crows.use_plugin('neovim/nvim-lspconfig')

-- lsp signature
crows.use_plugin({
  'folke/trouble.nvim',
  requires = 'kyazdani42/nvim-web-devicons',
  config = function()
    require('trouble').setup({
      signs = { error = '', warning = '', hint = '', information = '', other = '﫠' },
    })
    require('crows').maps({
      ['<leader>x'] = {
        name = 'lsp trouble',
        x = { '<cmd>TroubleToggle<cr>', 'Toggle Trouble' },
        w = { '<cmd>Trouble lsp_workspace_diagnostics<cr>', 'Workspace diagnostics' },
        d = { '<cmd>Trouble lsp_document_diagnostics<cr>', 'Document diagnostics' },
        l = { '<cmd>Trouble loclist<cr>', "Items from the window's location list" },
        q = { '<cmd>Trouble quickfix<cr>', 'Quickfix items' },
      },
    })
  end,
})
crows.setup(function()
  local signs = { Error = '', Warn = '', Info = '', Hint = '' } -- also used by "nvim.trouble"
  for sign, text in pairs(signs) do
    local hl = 'DiagnosticSign' .. sign
    vim.fn.sign_define(hl, { text = text, texthl = hl, linehl = '', numhl = '' })
  end
end)

-- function signature hint
crows.use_plugin({
  'ray-x/lsp_signature.nvim',
  config = function()
    require('lib.lsp').add_on_attach(function(_, _)
      require('lsp_signature').on_attach({ bind = true, handler_opts = { border = 'none' } })
    end)
  end,
})

-- lsp ui extension
crows.use_plugin({
  'RishabhRD/lspactions',
  requires = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-lua/popup.nvim' },
    { 'tjdevries/astronauta.nvim' },
  },
  config = function()
    require('astronauta.keymap')
    local lspactions = require('lspactions')
    vim.lsp.handlers['textDocument/codeAction'] = lspactions.codeaction
    vim.lsp.handlers['textDocument/references'] = lspactions.references
    vim.lsp.handlers['textDocument/definition'] = lspactions.definition
    vim.lsp.handlers['textDocument/declaration'] = lspactions.declaration
    vim.lsp.handlers['textDocument/implementation'] = lspactions.implementation
  end,
})
