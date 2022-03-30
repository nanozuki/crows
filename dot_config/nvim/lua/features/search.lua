local crows = require('crows')

vim.opt.ignorecase = true
crows.key.map('Clear search', 'n', '<leader>/', ':nohlsearch<CR>')

crows.plugin.use({
  'dyng/ctrlsf.vim',
  config = function()
    vim.g.ctrlsf_ackprg = 'rg'
    -- if use which-key, the prompt will not display immediately
    vim.api.nvim_set_keymap('n', '<leader>sf', ':CtrlSF ', { noremap = true })
    require('crows').key.map('Search in cursor', 'n', '<leader>sp', ':CtrlSF<CR>')
  end,
})

crows.plugin.use({
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
    require('crows').key.maps({
      ['<leader>'] = {
        name = 'telescope search',
        f = {
          f = { "<cmd>lua require('telescope.builtin').find_files()<cr>", 'Find files' },
          g = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", 'Grep in files' },
          b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", 'Find buffer' },
          h = { "<cmd>lua require('telescope.builtin').help_tags()<cr>", 'Find help' },
          m = { "<cmd>lua require('telescope.builtin').marks()<cr>", 'Find mark' },
          y = { "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>", 'Find lsp symbol' },
          t = { "<cmd>lua require('telescope.builtin').treesitter()<cr>", 'List item by treesitter' },
          s = { '<cmd>lua require("session-lens").search_session()<cr>', 'Search Session' },
        },
        z = { "<cmd>lua require'telescope'.extensions.z.list{}<CR>", 'Find path by z' },
      },
    })
  end,
})
