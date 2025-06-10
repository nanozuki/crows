return {
  {
    'github/copilot.vim',
    init = function()
      vim.g.copilot_no_tab_map = true
    end,
    enabled = function()
      local cwd = vim.fn.getcwd()
      return not string.match(cwd, 'leetcode')
    end,
    config = function()
      vim.keymap.set('i', '<C-e>', [[copilot#Accept("\<CR>")]], { expr = true, replace_keycodes = false })
      vim.keymap.set('i', '<C-.>', '<Plug>(copilot-next)')
      vim.keymap.set('i', '<C-,>', '<Plug>(copilot-previous)')
    end,
  },
  {
    'olimorris/codecompanion.nvim',
    opts = {},
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
  },
}
