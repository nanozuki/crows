local lsp = require('config.globals').lsp

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
      lsp.servers.jsonls.config = {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      }
      lsp.servers.yamlls.config = {
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
      }
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
    dependencies = { 'neovim/nvim-lspconfig' },
    ft = { 'rust' },
    init = function()
      lsp.servers.rust_analyzer.lazyload = true
    end,
    config = function()
      lsp.servers.rust_analyzer.on_attach = function(_, bufnr)
        vim.keymap.set('n', '<leader>ca', function()
          vim.cmd.RustLsp('codeAction')
        end, { buffer = bufnr, desc = 'Code actions' })
        vim.keymap.set('n', '<leader>ha', function()
          vim.cmd.RustLsp({ 'hover', 'actions' })
        end, { buffer = bufnr, desc = 'Code action groups' })
      end
      vim.g.rustaceanvim = { server = lsp.make_config('rust_analyzer') }
    end,
  },
  -- typescript
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'svelte' },
    init = function()
      lsp.servers.tsserver.lazyload = true
    end,
    config = function()
      require('typescript-tools').setup(lsp.make_config('tsserver'))
      vim.keymap.set('n', '<leader>oi', '<cmd>TSToolsOrganizeImports', { desc = 'Organize imports' })
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
