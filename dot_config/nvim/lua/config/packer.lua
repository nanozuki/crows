-- ensure packer installed
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
end

local function cfg(plug)
  return ("require('plugins.%s')"):format(plug)
end

require('packer').startup({
  function(use)
    -- ## basic plugins
    use({ 'wbthomason/packer.nvim' }) -- plugins manager itself
    use('folke/which-key.nvim') -- keymapping hint
    use('neovim/nvim-lspconfig') -- lspconfig
    use('lewis6991/impatient.nvim') -- boost startup time
    use({ 'rmagatti/auto-session', config = cfg('auto-session') })
    -- ## ui improving
    use({ -- improve vim select/input UI
      'stevearc/dressing.nvim',
      config = function()
        require('dressing').setup({ input = { winblend = 0 } })
      end,
    })
    use({ 'kevinhwang91/nvim-bqf', ft = 'qf' }) -- improve vim quickfix UI
    -- ## ui component
    use({ 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons', config = cfg('nvim-tree') })
    use({ 'goolord/alpha-nvim', requires = { 'kyazdani42/nvim-web-devicons' }, config = cfg('alpha-nvim') })
    use({
      'feline-nvim/feline.nvim',
      requires = {
        'kyazdani42/nvim-web-devicons',
        'nvim-lua/plenary.nvim',
        'lewis6991/gitsigns.nvim',
      },
      config = cfg('feline-nvim'),
    })
    use({ 'nanozuki/tabby.nvim', requires = 'kyazdani42/nvim-web-devicons', config = cfg('tabby-nvim') })
    use({
      'akinsho/toggleterm.nvim',
      tag = '*',
      config = cfg('toggleterm-nvim'),
    })
    -- ## normal editor
    use('kshenoy/vim-signature') -- display sign for marks
    use('mg979/vim-visual-multi') -- multi select and edit
    use({ 'windwp/nvim-autopairs', requires = { 'hrsh7th/nvim-cmp' } }) -- autopairs
    use('machakann/vim-sandwich') -- surround edit
    use({ 'lukas-reineke/indent-blankline.nvim', config = cfg('indent-blankline-nvim') }) -- indent hint
    use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdateSync', config = cfg('nvim-treesitter') }) -- treesitter
    use({ 'L3MON4D3/LuaSnip', config = cfg('luasnip') })
    -- ### git enhancement
    use('tpope/vim-fugitive')
    use({
      'TimUntersberger/neogit',
      requires = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim' },
      config = function()
        require('neogit').setup({ integrations = { diffview = true } })
      end,
    })
    -- ## config helper
    use({ 'norcalli/nvim-colorizer.lua', opt = true, cmd = 'ColorizerToggle' })
    -- ## normal language edition
    use({
      'hrsh7th/nvim-cmp', -- completion
      requires = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'L3MON4D3/LuaSnip', -- snippets
        'saadparwaiz1/cmp_luasnip',
      },
      config = cfg('nvim-cmp'),
    })
    use({ 'gelguy/wilder.nvim', config = cfg('wilder-nvim') }) -- cmdline completion
    use({ 'mhartington/formatter.nvim', config = cfg('formatter-nvim') }) -- formatter
    -- ## lsp enhancement
    use({ 'folke/trouble.nvim', requires = 'kyazdani42/nvim-web-devicons' })
    use('ray-x/lsp_signature.nvim')
    use({
      'j-hui/fidget.nvim',
      config = function()
        require('fidget').setup({})
      end,
    })
    -- ## search
    use({ 'dyng/ctrlsf.vim', config = cfg('ctrlsf-vim') })
    use({
      'nvim-telescope/telescope.nvim',
      requires = {
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-telescope/telescope-z.nvim' },
        { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
        { 'rmagatti/session-lens' }, -- auto-session
      },
      config = cfg('telescope-nvim'),
    })
    -- ## theme
    use({ 'sainnhe/gruvbox-material', opt = true })
    use({ 'shaunsingh/nord.nvim', opt = true })
    use({ 'sainnhe/edge', opt = true })
    use({ 'rose-pine/neovim', opt = true, as = 'rose-pine' })
    -- ## languages
    use({ 'dag/vim-fish', ft = { 'fish' } })
    use({
      'ray-x/go.nvim',
      ft = { 'go', 'gomod' },
      config = function()
        require('go').setup()
      end,
    })
    use({
      'mattn/emmet-vim',
      ft = { 'html', 'javascript.jsx', 'typescript.tsx', 'javascriptreact', 'typescriptreact', 'xml' },
    })
  end,
  config = {
    display = {
      open_fn = require('packer.util').float,
    },
  },
})
