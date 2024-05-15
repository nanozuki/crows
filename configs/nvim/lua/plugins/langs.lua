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
    'folke/neodev.nvim',
    ft = { 'lua' },
    dependencies = { 'neovim/nvim-lspconfig' },
    init = function()
      lsp.servers.lua_ls.lazyload = true
    end,
    config = function()
      require('neodev').setup({
        override = function(root_dir, options)
          if root_dir:find('config.*nvim') then
            -- enable plugins in config managers
            options.plugins = true
          end
        end,
      })
      lsp.setup('lua_ls')
    end,
  },
  {
    'olexsmir/gopher.nvim',
    requires = { -- dependencies
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('gopher').setup({})
    end,
  },
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
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'svelte' },
    init = function()
      lsp.servers.tsserver.lazyload = true
    end,
    config = function()
      require('typescript-tools').setup(lsp.make_config('tsserver'))
      lsp.setup('svelte')
    end,
  },
}
