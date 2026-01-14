return {
  {
    'rmagatti/auto-session',
    config = function()
      vim.opt.sessionoptions = 'buffers,curdir,folds,globals,help,tabpages,terminal,localoptions,winsize,winpos'
      local function clean_buffers()
        local wins = vim.api.nvim_list_wins()
        local active_bufs = {}
        for _, win in ipairs(wins) do
          local buf = vim.api.nvim_win_get_buf(win)
          local type = vim.api.nvim_get_option_value('buftype', { buf = buf })
          if type == '' and type == 'terminal' then -- '' is normal file buffer
            active_bufs[buf] = true
          end
        end
        local bufs = vim.api.nvim_list_bufs()
        for _, buf in ipairs(bufs) do
          if not active_bufs[buf] then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end
      end
      require('auto-session').setup({
        cwd_change_handling = true,
        pre_cwd_changed_cmds = { clean_buffers },
        pre_save_cmds = { clean_buffers },
        purge_after_minutes = 1440 * 30, -- (minutes) remove sessions older than 30 days
        session_lens = {
          load_on_setup = false,
        },
        suppressed_dirs = { '~' },
      })
      vim.keymap.set('n', '<leader>sr', '<cmd>SessionRestore<cr>', { desc = 'Restore session' })
      vim.keymap.set('n', '<leader>ss', '<cmd>SessionSave<cr>', { desc = 'Save session' })
      vim.keymap.set('n', '<leader>fs', '<cmd>SessionSearch<cr>', { desc = 'Find session' })
    end,
  },
  { 'dstein64/vim-startuptime', cmd = 'StartupTime' },
  { 'direnv/direnv.vim' },
}
