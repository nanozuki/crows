return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-z.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'rmagatti/auto-session',
    },
    config = function()
      require('telescope').load_extension('z')
      require('telescope').load_extension('fzf')
      require('telescope').setup({
        defaults = {
          preview = {
            filesize_limit = 0.5,
            timeout = 100,
          },
          file_ignore_patterns = { '.*%.pb.*%.go', '.*api.yaml', 'swagger.yaml' },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
          },
        },
      })
      vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = 'Grep in files' })
      vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = 'Find buffer' })
      vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = 'Find help' })
      vim.keymap.set('n', '<leader>fm', require('telescope.builtin').marks, { desc = 'Find mark' })
      vim.keymap.set(
        'n',
        '<leader>fy',
        require('telescope.builtin').lsp_workspace_symbols,
        { desc = 'Find lsp symbol' }
      )
      vim.keymap.set('n', '<leader>ft', require('telescope.builtin').treesitter, { desc = 'List item by treesitter' })
      vim.keymap.set('n', '<leader>z', require('telescope').extensions.z.list, { desc = 'Find path by z' })
      require('auto-session').setup_session_lens()
      vim.keymap.set(
        'n',
        '<leader>fs',
        require('auto-session.session-lens').search_session,
        { desc = 'Find session', noremap = true }
      )
    end,
  },
}
