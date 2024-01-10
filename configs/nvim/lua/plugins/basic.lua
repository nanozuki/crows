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
        local winbufs = vim.tbl_map(vim.api.nvim_win_get_buf, vim.api.nvim_list_wins())
        local bufs = vim.api.nvim_list_bufs()
        for _, buf in ipairs(bufs) do
          if vim.api.nvim_buf_get_name(buf) ~= '' then
            local type = vim.api.nvim_buf_get_option(buf, 'buftype')
            if (type ~= '' and type ~= 'terminal') or not vim.tbl_contains(winbufs, buf) then
              vim.api.nvim_buf_delete(buf, {})
            end
          end
        end
      end
      ---@diagnostic disable-next-line: missing-fields
      require('auto-session').setup({
        auto_session_suppress_dirs = { '~' },
        pre_save_cmds = { clean_buffers },
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
