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
      local function clean_buffers()
        local bufs = vim.api.nvim_list_bufs()
        for _, buf in ipairs(bufs) do
          local name = vim.api.nvim_buf_get_name(buf)
          local type = vim.api.nvim_get_option_value('buftype', { buf = buf })
          if name ~= '' and type ~= '' and type ~= 'terminal' then
            vim.api.nvim_buf_delete(buf, {})
          end
        end
      end
      require('auto-session').setup({
        auto_session_suppress_dirs = { '~' },
        pre_save_cmds = { clean_buffers },
        cwd_change_handling = true,
        pre_cwd_changed_cmds = { clean_buffers },
        session_lens = {
          load_on_setup = false,
        },
      })
      vim.keymap.set('n', '<leader>sr', '<cmd>SessionRestore<cr>', { desc = 'Restore session' })
      vim.keymap.set('n', '<leader>ss', '<cmd>SessionSave<cr>', { desc = 'Save session' })
      vim.keymap.set('n', '<leader>fs', '<cmd>SessionSearch<cr>', { desc = 'Find session' })
    end,
  },
  { 'dstein64/vim-startuptime', cmd = 'StartupTime' },
  { 'direnv/direnv.vim' },
}
