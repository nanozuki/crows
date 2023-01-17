local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local custom = require('config.custom')

-- using seprated config file
local function cfg(plug)
  local pkg = string.format('plugins.%s', plug)
  return function()
    require(pkg)
  end
end

local plugins = {
  -- ## basic plugins
  -- boost startup time
  'lewis6991/impatient.nvim',
  -- keymapping hint
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('which-key').setup({})
    end,
  },
  { 'rmagatti/auto-session', config = cfg('auto_session') },
  { 'dstein64/vim-startuptime', cmd = 'StartupTime' },

  -- ## theme
  { 'sainnhe/gruvbox-material', enabled = (custom.theme == 'gruvbox_dark' or custom.theme == 'gruvbox_light') },
  { 'shaunsingh/nord.nvim', enabled = custom.theme == 'nord' },
  { 'sainnhe/edge', enabled = custom.theme == 'edge_light' },
  { 'rose-pine/neovim', name = 'rose-pine', enabled = custom.theme == 'rose_pine_dawn' },

  -- ## ui
  -- improve vim select/input UI
  { 'stevearc/dressing.nvim', event = 'VeryLazy', config = cfg('dressing_nvim') },
  -- improve vim quickfix UI
  { 'kevinhwang91/nvim-bqf', ft = 'qf' },
  {
    'nvim-tree/nvim-tree.lua',
    cmd = { 'NvimTreeToggle', 'NvimTreeClose' },
    keys = { { '<Leader>fl', ':NvimTreeToggle<CR>', 'n', { desc = 'Toggle filetree' } } },
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = cfg('nvim_tree'),
  },
  {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = cfg('alpha_nvim'),
  },
  {
    'feline-nvim/feline.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'nvim-lua/plenary.nvim',
      {
        'lewis6991/gitsigns.nvim',
        config = function()
          require('gitsigns').setup({ signcolumn = false, trouble = false })
        end,
      },
    },
    config = cfg('feline_nvim'),
  },
  {
    'nanozuki/tabby.nvim',
    event = 'VimEnter',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = cfg('tabby_nvim'),
  },
  { 'akinsho/toggleterm.nvim', event = 'VeryLazy', config = cfg('toggleterm_nvim') },

  -- ## general editing
  -- display sign for marks
  { 'kshenoy/vim-signature', event = 'BufReadPre' },
  -- multi select and edit
  { 'mg979/vim-visual-multi', event = 'BufReadPre' },
  -- autopairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = cfg('nvim_autopairs'),
  },
  -- surround edit
  { 'machakann/vim-sandwich', event = 'BufReadPre' },
  -- indent hint
  { 'lukas-reineke/indent-blankline.nvim', event = 'BufReadPre', config = cfg('indent_blankline_nvim') },
  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'BufReadPost',
    cmd = { 'TSUpdate', 'TSUpdateSync' },
    run = ':TSUpdate',
    config = cfg('nvim_treesitter'),
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

  -- ## completion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      { 'L3MON4D3/LuaSnip', config = cfg('luasnip') }, -- snippets
      'saadparwaiz1/cmp_luasnip',
    },
    config = cfg('nvim_cmp'),
  },
  { 'gelguy/wilder.nvim', event = 'CmdlineEnter', build = ':UpdateRemotePlugins', config = cfg('wilder_nvim') }, -- cmdline completion
  { 'mhartington/formatter.nvim', event = 'BufReadPost', config = cfg('formatter_nvim') }, -- formatter

  -- ## lsp config
  {
    'neovim/nvim-lspconfig',
    config = cfg('nvim_lspconfig'),
    event = 'BufReadPre',
    dependencies = {
      -- function signature helper
      { 'ray-x/lsp_signature.nvim' },
      -- lsp completion source
      'hrsh7th/cmp-nvim-lsp',
      -- jsonls schema helper
      { 'b0o/schemastore.nvim', ft = { 'json', 'yaml' } },
      -- lua lsp enhancement
      {
        'folke/neodev.nvim',
        config = function()
          require('neodev').setup({})
        end,
      },
    },
  },
  {
    'folke/trouble.nvim',
    cmd = 'TroubleToggle',
    keys = { { '<leader>xx', ':TroubleToggle<CR>', 'n', { desc = 'Toggle trouble quickfix' } } },
    dependencies = { 'nvim-tree/nvim-web-devicons', 'neovim/nvim-lspconfig' },
    config = cfg('trouble_nvim'),
  },
  {
    'j-hui/fidget.nvim',
    event = 'BufReadPost',
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      require('fidget').setup({})
    end,
  },

  -- ## search
  { 'dyng/ctrlsf.vim', event = 'VeryLazy', config = cfg('ctrlsf_vim') },
  {
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-z.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'rmagatti/session-lens' }, -- auto-session
    },
    config = cfg('telescope_nvim'),
  },

  -- ## languages
  -- fish
  { 'dag/vim-fish', ft = { 'fish' } }, -- fish
  -- *ml tag editing
  {
    'mattn/emmet-vim',
    ft = { 'html', 'javascript.jsx', 'typescript.tsx', 'javascriptreact', 'typescriptreact', 'xml' },
  },
  {
    'ray-x/go.nvim',
    ft = { 'go', 'gomod', 'gowork' },
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      require('go').setup()
    end,
    enabled = custom.opt_languages.go,
  },
  {
    'simrat39/rust-tools.nvim',
    dependencies = { 'neovim/nvim-lspconfig' },
    ft = { 'rust' },
    config = cfg('rust_tools_nvim'),
    enabled = custom.opt_languages.rust,
  },
  {
    'williamboman/mason.nvim',
    dependencies = { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
    config = cfg('mason_nvim'),
  },
}

local opts = {
  concurrency = 12,
}

require('lazy').setup(plugins, opts)
