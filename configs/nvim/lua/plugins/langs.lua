local lsp = require('config.lsp')
local langs = require('config.langs')
local values = require('config.values')

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
    enabled = values.languages.json or values.languages.yaml,
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
    'ray-x/go.nvim',
    ft = { 'go', 'gomod' },
    enabled = values.languages.go,
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('go').setup()

      local org_imports_group = vim.api.nvim_create_augroup('GoOrgImports', {})
      vim.api.nvim_create_autocmd('BufWritePost', {
        buffer = 0,
        callback = function()
          require('go.format').org_imports()
        end,
        group = org_imports_group,
      })
    end,
  },
  {
    'simrat39/rust-tools.nvim',
    dependencies = { 'neovim/nvim-lspconfig' },
    enabled = values.languages.rust,
    ft = { 'rust' },
    init = function()
      langs.servers.rust_analyzer.autoload = false
    end,
    config = function()
      local rt = require('rust-tools')
      local on_attach = function(_, bufnr)
        vim.keymap.set('n', '<leader>ha', rt.hover_actions.hover_actions, { buffer = bufnr, desc = 'Hover actions' })
        vim.keymap.set(
          'n',
          '<leader>ag',
          rt.code_action_group.code_action_group,
          { buffer = bufnr, desc = 'Code action groups' }
        )
      end
      local config = lsp.make_config(langs.servers.rust_analyzer, on_attach)
      rt.setup({ server = config })
    end,
  },
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    enabled = values.languages.typescript_node,
    init = function()
      langs.servers.tsserver.autoload = false
    end,
    config = function()
      local cfg = lsp.make_config(langs.servers.tsserver.config)
      require('typescript-tools').setup(cfg)
    end,
  },
}
