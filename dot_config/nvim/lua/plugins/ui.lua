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
                builtin = { relative = 'cursor', max_width = 40 },
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
    cmd = { 'NvimTreeToggle', 'NvimTreeClose' },
    keys = { { '<Leader>fl', ':NvimTreeToggle<CR>', 'n', { desc = 'Toggle filetree' } } },
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('nvim-tree').setup({
        disable_netrw = false,
        update_cwd = true,
        diagnostics = { enable = true },
        view = { signcolumn = 'auto' },
        git = {
          ignore = false,
        },
      })
    end,
  },
}
