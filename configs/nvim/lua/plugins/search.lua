return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-z.nvim' },
    },
    config = function()
      require('telescope').load_extension('z')
      require('telescope').setup({
        defaults = {
          preview = {
            filesize_limit = 0.5,
            timeout = 100,
          },
          file_ignore_patterns = { '.*%.pb.*%.go', '.*api.yaml', 'swagger.yaml' },
        },
      })
      vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = 'Grep in files' })
      vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = 'Find buffer' })
      vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = 'Find help' })
      vim.keymap.set('n', '<leader>fm', require('telescope.builtin').marks, { desc = 'Find mark' })
      vim.keymap.set(
        'n',
        '<leader>fc',
        require('telescope.builtin').command_history,
        { desc = 'Find command in history' }
      )
      vim.keymap.set(
        'n',
        '<leader>fy',
        require('telescope.builtin').lsp_workspace_symbols,
        { desc = 'Find lsp symbol' }
      )
      vim.keymap.set('n', '<leader>ft', require('telescope.builtin').treesitter, { desc = 'List item by treesitter' })
      vim.keymap.set('n', '<leader>z', require('telescope').extensions.z.list, { desc = 'Find path by z' })
    end,
  },
}
