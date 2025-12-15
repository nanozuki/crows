return {
  -- display sign for marks
  { 'kshenoy/vim-signature', event = { 'BufReadPre', 'BufNewFile' } },
  -- indent hint
  {
    'lukas-reineke/indent-blankline.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = { 'BufReadPre', 'BufNewFile' },
    main = 'ibl',
    opts = {
      indent = { char = '¦' },
      exclude = {
        buftypes = { 'help', 'nofile', 'nowrite', 'quickfix', 'terminal', 'prompt' },
      },
      scope = { enabled = false },
    },
  },
  -- highlight color value
  { 'norcalli/nvim-colorizer.lua', cmd = 'ColorizerToggle' },
  -- jump
  {
    url = 'https://codeberg.org/andyg/leap.nvim.git',
    config = function()
      vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
      vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')
    end,
  },
}
