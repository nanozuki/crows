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
          local type = vim.api.nvim_buf_get_option(buf, 'buftype')
          if name ~= '' and type ~= '' then
            vim.api.nvim_buf_delete(buf, {})
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
