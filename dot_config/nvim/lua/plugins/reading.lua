return {
  -- display sign for marks
  { 'kshenoy/vim-signature', event = { 'BufReadPre', 'BufNewFile' } },
  -- indent hint
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('indent_blankline').setup({
        char = '¦',
        buftype_exclude = { 'help', 'nofile', 'nowrite', 'quickfix', 'terminal', 'prompt' },
      })
    end,
  },
  -- highlight color value
  { 'norcalli/nvim-colorizer.lua', cmd = 'ColorizerToggle' },
  -- motion
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {
      modes = {
        char = {
          enabled = false,
        },
      },
    },
    keys = {
      -- stylua: ignore start
      { "s", mode = { "n", "o", "x" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      -- stylua: ignore end
    },
  },
}
