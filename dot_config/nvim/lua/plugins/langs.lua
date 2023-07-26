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
    enabled = langs.json.enable or langs.yaml.enable,
    config = function()
      langs.json.servers.jsonls = vim.tbl_deep_extend('force', langs.json.servers.jsonls, {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      })
      langs.yaml.servers.yamlls = vim.tbl_deep_extend('force', langs.yaml.servers.yamlls, {
        settings = {
          yaml = {
            schemas = require('schemastore').yaml.schemas(),
          },
        },
      })
    end,
  },
  -- lua
  {
    'folke/neodev.nvim',
    ft = { 'lua' },
    dependencies = { 'neovim/nvim-lspconfig' },
    init = function()
      langs.lua.servers.lua_ls.meta = { delayed_start = true }
    end,
    config = function()
      local neodev = require('neodev')
      neodev.setup({ setup_jsonls = false })

      local lspconfig = require('lspconfig')
      local lua_config = langs.lua.servers.lua_ls
      lua_config.on_attach = lsp.on_attach
      lua_config.capabilities = lsp.make_capabilities()
      lspconfig.lua_ls.setup(lua_config)
    end,
  },
  {
    'ray-x/go.nvim',
    ft = { 'go', 'gomod' },
    enabled = (not values.use_null_ls) and langs.go.enable,
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('go').setup()
    end,
  },
  {
    'simrat39/rust-tools.nvim',
    dependencies = { 'neovim/nvim-lspconfig' },
    enabled = langs.rust.enable,
    ft = { 'rust' },
    init = function()
      langs.rust.servers.rust_analyzer.meta = { delayed_start = true }
    end,
    config = function()
      local rt = require('rust-tools')
      local config = langs.rust.servers.rust_analyzer
      config.on_attach = function(client, bufnr)
        lsp.on_attach(client, bufnr)
        vim.keymap.set('n', '<leader>ha', rt.hover_actions.hover_actions, { buffer = bufnr, desc = 'Hover actions' })
        vim.keymap.set(
          'n',
          '<leader>ag',
          rt.code_action_group.code_action_group,
          { buffer = bufnr, desc = 'Code action groups' }
        )
      end
      config.capabilities = lsp.make_capabilities()
      rt.setup({ server = config })
    end,
  },
}
