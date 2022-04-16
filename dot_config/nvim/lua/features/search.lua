local crows = require('crows')
---@type Feature
local search = { plugins = {} }

search.pre = function()
  vim.opt.ignorecase = true
end

search.post = function()
  crows.key.map('Clear search', 'n', '<leader>/', ':nohlsearch<CR>')
end

-- global replace
search.plugins[1] = {
  'dyng/ctrlsf.vim',
  config = function()
    vim.g.ctrlsf_ackprg = 'rg'
    -- if use which-key, the prompt will not display immediately
    vim.api.nvim_set_keymap('n', '<leader>sf', ':CtrlSF ', { noremap = true })
    require('crows').key.map('Search in cursor', 'n', '<leader>sp', ':CtrlSF<CR>')
  end,
}

-- telescope
search.plugins[2] = {
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
          f = { require('telescope.builtin').find_files, 'Find files' },
          g = { require('telescope.builtin').live_grep, 'Grep in files' },
          b = { require('telescope.builtin').buffers, 'Find buffer' },
          h = { require('telescope.builtin').help_tags, 'Find help' },
          m = { require('telescope.builtin').marks, 'Find mark' },
          y = { require('telescope.builtin').lsp_workspace_symbols, 'Find lsp symbol' },
          t = { require('telescope.builtin').treesitter, 'List item by treesitter' },
          s = { require('session-lens').search_session, 'Search Session' },
        },
        z = { require('telescope').extensions.z.list, 'Find path by z' },
      },
    })
  end,
}

return search
