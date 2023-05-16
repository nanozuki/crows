return {
  -- boost startup time
  'lewis6991/impatient.nvim',
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
      vim.opt.sessionoptions = 'curdir,folds,help,tabpages,terminal,winsize'
      require('auto-session').setup({
        pre_save_cmds = { 'NvimTreeClose' },
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
