return {
  -- keymapping hint
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('which-key').setup({})
    end,
  },
  {
    'rmagatti/auto-session',
    config = function()
      vim.opt.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize'
      ---@diagnostic disable-next-line: missing-fields
      require('auto-session').setup({
        auto_session_suppress_dirs = { '~' },
        session_lens = {
          load_on_setup = false,
        },
      })
      vim.keymap.set('n', '<leader>sr', '<cmd>SessionRestore<cr>', { desc = 'Restore session' })
      vim.keymap.set('n', '<leader>ss', '<cmd>SessionSave<cr>', { desc = 'Save session' })
    end,
  },
  { 'dstein64/vim-startuptime', cmd = 'StartupTime' },
}
