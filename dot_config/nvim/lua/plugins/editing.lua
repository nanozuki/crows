return {
  -- display sign for marks
  { 'kshenoy/vim-signature', event = 'BufReadPre' },
  -- multi select and edit
  { 'mg979/vim-visual-multi', event = 'BufReadPre' },
  -- autopairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup({ check_ts = true })
    end,
  },
  -- surround edit
  { 'machakann/vim-sandwich', event = 'BufReadPre' },
  -- indent hint
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufReadPre',
    config = function()
      require('indent_blankline').setup({
        char = '¦',
        buftype_exclude = { 'help', 'nofile', 'nowrite', 'quickfix', 'terminal', 'prompt' },
      })
    end,
  },
  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'BufReadPost',
    cmd = { 'TSUpdate', 'TSUpdateSync' },
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = 'all',
        ignore_install = { 'phpdoc' },
        highlight = {
          enable = true,
          highlight = {
            enable = true,
            disable = function(lang, bufnr)
              if lang == 'html' and vim.api.nvim_buf_line_count(bufnr) > 500 then
                return true
              end
              for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, 3, false)) do
                if #line > 500 then
                  return true
                end
              end
              return false
            end,
          },
        },
      })
    end,
  },
  -- git command enhancement
  { 'tpope/vim-fugitive', event = 'VeryLazy' },
  {
    'TimUntersberger/neogit',
    cmd = 'Neogit',
    dependencies = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim' },
    config = function()
      require('neogit').setup({ integrations = { diffview = true } })
    end,
  },
  -- highlight color value
  { 'norcalli/nvim-colorizer.lua', cmd = 'ColorizerToggle' },
}
