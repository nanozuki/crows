local crows = require('crows')

vim.opt.ignorecase = true
crows.map('Clear search', 'n', '<leader>/', ':nohlsearch<CR>')

crows.use_plugin({
  'dyng/ctrlsf.vim',
  config = function()
    vim.g.ctrlsf_ackprg = 'rg'
    require('crows').maps({
      ['<leader>s'] = {
        name = 'Global search',
        f = { ':CtrlSF ', 'Search keyword' },
        p = { ':CtrlSF<CR>', 'Search in cursor' },
      },
    })
  end,
})

crows.use_plugin({
  'nvim-telescope/telescope.nvim',
  requires = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope-z.nvim' },
    { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
    { 'rmagatti/session-lens' }, -- auto-session
  },
  config = function()
    require('telescope').load_extension('z')
    require('telescope').load_extension('fzf')
    require('telescope').load_extension('session-lens')
    require('telescope').setup({
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
        },
      },
    })
    require('crows').maps({
      ['<leader>'] = {
        name = 'telescope search',
        f = {
          f = { "<cmd>lua require('telescope.builtin').find_files()<cr>", 'Find files' },
          g = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", 'Grep in files' },
          b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", 'Find buffer' },
          h = { "<cmd>lua require('telescope.builtin').help_tags()<cr>", 'Find help' },
          m = { "<cmd>lua require('telescope.builtin').marks()<cr>", 'Find mark' },
          l = { "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>", 'Find lsp symbol' },
          t = { "<cmd>lua require('telescope.builtin').treesitter()<cr>", 'List item by treesitter' },
          s = { '<cmd>SearchSession<cr>' },
        },
        z = { "<cmd>lua require'telescope'.extensions.z.list{}<CR>", 'Find path by z' },
      },
    })
  end,
})
