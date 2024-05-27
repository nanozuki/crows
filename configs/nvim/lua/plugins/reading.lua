return {
  -- display sign for marks
  { 'kshenoy/vim-signature', event = { 'BufReadPre', 'BufNewFile' } },
  -- indent hint
  -- {
  --   'lukas-reineke/indent-blankline.nvim',
  --   dependencies = { 'nvim-treesitter/nvim-treesitter' },
  --   event = { 'BufReadPre', 'BufNewFile' },
  --   main = 'ibl',
  --   opts = {
  --     indent = { char = '¦' },
  --     exclude = {
  --       buftypes = { 'help', 'nofile', 'nowrite', 'quickfix', 'terminal', 'prompt' },
  --     },
  --     -- scope = { enabled = false },
  --   },
  -- },
  {
    'shellRaining/hlchunk.nvim',
    branch = 'dev',
    opts = {
      chunk = {
        enable = true,
      },
      indent = {
        enable = true,
        chars = { '¦' },
      },
    },
  },
  -- highlight color value
  { 'norcalli/nvim-colorizer.lua', cmd = 'ColorizerToggle' },
  -- jump
  {
    'https://github.com/ggandor/leap.nvim',
    config = function()
      require('leap').add_default_mappings()
    end,
  },
}
