return {
  -- fish
  { 'dag/vim-fish', ft = { 'fish' } },
  -- html/xml/react/markdown element editing
  {
    'mattn/emmet-vim',
    ft = { 'html', 'javascriptreact', 'typescriptreact', 'xml', 'markdown' },
  },
  -- json/yaml schema
  {
    'b0o/schemastore.nvim',
    lazy = true,
    config = function()
      vim.lsp.config('jsonls', {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      })
      vim.lsp.config('yamlls', {
        settings = {
          yaml = {
            schemaStore = {
              -- You must disable built-in schemaStore support if you want to use
              -- this plugin and its advanced options like `ignore`.
              enable = false,
              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
              url = '',
            },
            schemas = require('schemastore').yaml.schemas(),
          },
        },
      })
    end,
  },
  -- lua
  {
    'folke/lazydev.nvim',
    ft = { 'lua' },
    opts = {
      library = {
        'luvit-meta/library',
      },
      enabled = function(root_dir)
        return not vim.uv.fs_stat(root_dir .. '/.luarc.json')
      end,
    },
  },
  -- optional `vim.uv` typings, auto-loaded by `lazydev.nvim`
  { 'Bilal2453/luvit-meta', lazy = true },
  -- golang
  {
    'olexsmir/gopher.nvim',
    dependencies = { -- dependencies
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    ft = { 'go', 'gomod', 'gotmpl' },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('gopher').setup({})
    end,
  },
  -- rust
  {
    'mrcjkb/rustaceanvim',
    ft = { 'rust' },
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'rust',
        callback = function(args)
          vim.keymap.set('n', '<leader>ca', function()
            vim.cmd.RustLsp('codeAction')
          end, { buffer = args.buf, desc = 'Code actions' })
          vim.keymap.set('n', '<leader>ha', function()
            vim.cmd.RustLsp({ 'hover', 'actions' })
          end, { buffer = args.buf, desc = 'Code action groups' })
        end,
      })
    end,
  },
  -- sql
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  -- markdown
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
}
