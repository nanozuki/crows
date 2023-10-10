return {
  -- improve vim select/input UI
  {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    config = function()
      require('dressing').setup({
        input = { win_options = { winblend = 0 } },
        select = {
          get_config = function(opts)
            if opts.kind == 'codeaction' then
              return {
                backend = 'builtin',
                builtin = { relative = 'cursor', max_width = 80 },
              }
            end
          end,
        },
      })
    end,
  },
  -- improve vim quickfix UI
  { 'kevinhwang91/nvim-bqf', ft = 'qf' },
  {
    'nvim-tree/nvim-tree.lua',
    -- cmd = { 'NvimTreeToggle', 'NvimTreeClose' },
    -- keys = { { '<Leader>fl', ':NvimTreeToggle<CR>', 'n', { desc = 'Toggle filetree' } } },
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('nvim-tree').setup()
      vim.keymap.set('n', '<leader>fl', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
    end,
  },
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
}
