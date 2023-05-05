local opt_languages = require('config.custom').opt_languages

return {
  -- fish
  { 'dag/vim-fish', ft = { 'fish' } }, -- fish
  -- *ml tag editing
  {
    'mattn/emmet-vim',
    ft = { 'html', 'javascriptreact', 'typescriptreact', 'xml', 'jsx', 'markdown' },
  },
  {
    'simrat39/rust-tools.nvim',
    dependencies = { 'neovim/nvim-lspconfig' },
    enabled = opt_languages.rust,
    ft = { 'rust' },
    config = function()
      local rt = require('rust-tools')
      local lsp = require('plugins.lsp.base')
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
    end,
  },
}
