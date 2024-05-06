local lsp = require('config.lsp')
local langs = require('config.langs')

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
      langs.servers.jsonls.config = {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      }
      langs.servers.yamlls.config = {
        settings = {
          yaml = {
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
      langs.servers.lua_ls.autoload = false
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
      local lspconfig = require('lspconfig')
      lspconfig.lua_ls.setup(lsp.make_config(langs.servers.lua_ls))
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
      vim.keymap.set('n', '<leader>ie', '<cmd>GoIfErr<cr>', { desc = 'Insert if err != nil' })
      vim.keymap.set('i', '<C-i>', '<cmd>GoIfErr<cr>', { desc = 'Insert if err != nil' })
    end,
  },
  {
    'mrcjkb/rustaceanvim',
    dependencies = { 'neovim/nvim-lspconfig' },
    ft = { 'rust' },
    init = function()
      langs.servers.rust_analyzer.autoload = false
    end,
    config = function()
      local on_attach = function(_, bufnr)
        vim.keymap.set('n', '<leader>ca', function()
          vim.cmd.RustLsp('codeAction')
        end, { buffer = bufnr, desc = 'Code actions' })
        vim.keymap.set('n', '<leader>ha', function()
          vim.cmd.RustLsp({ 'hover', 'actions' })
        end, { buffer = bufnr, desc = 'Code action groups' })
      end
      local server = lsp.make_config(langs.servers.rust_analyzer, on_attach)
      vim.g.rustaceanvim = { server = server }
    end,
  },
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'svelte' },
    init = function()
      langs.servers.tsserver.autoload = false
    end,
    config = function()
      local cfg = lsp.make_config(langs.servers.tsserver)
      require('typescript-tools').setup(cfg)
    end,
  },
}
