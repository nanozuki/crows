local rt = require('rust-tools')
local lsp = require('config.lsp')
rt.setup({
  server = {
    on_attach = function(client, bufnr)
      lsp.on_attach(client, bufnr)
      -- Hover actions
      vim.keymap.set('n', '<leader>ha', rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set('n', '<leader>ag', rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
    capabilities = lsp.capabilities(),
    settings = {
      ['rust-analyzer'] = {
        diagnostics = { disabled = { 'unresolved-proc-macro' } },
        checkOnSave = { command = 'clippy' },
      },
    },
  },
})
