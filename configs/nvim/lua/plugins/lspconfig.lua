return {
  {
    'chrisgrieser/nvim-lsp-endhints',
    event = 'LspAttach',
    init = function()
      vim.lsp.inlay_hint.enable()
    end,
    opts = {},
  },
  { 'neovim/nvim-lspconfig' },
  {
    'folke/trouble.nvim',
    cmd = 'TroubleToggle',
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', 'n', desc = 'Toggle trouble quickfix' },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },
  {
    'kosayoda/nvim-lightbulb',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      sign = { enabled = false },
      virtual_text = { enabled = true, text = '' },
      autocmd = { enabled = true },
      float = {},
    },
  },
}
