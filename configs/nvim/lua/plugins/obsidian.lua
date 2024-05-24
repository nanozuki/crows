return {
  'oflisback/obsidian-bridge.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('obsidian-bridge').setup()
  end,
  event = {
    'BufReadPre *.md',
    'BufNewFile *.md',
  },
  lazy = true,
}
