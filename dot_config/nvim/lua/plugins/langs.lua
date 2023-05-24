local lsp = require('config.lsp')
local values = require('config.values')

return {
  -- fish
  { 'dag/vim-fish', ft = { 'fish' } },
  -- *ml tag editing
  {
    'mattn/emmet-vim',
    ft = { 'html', 'javascriptreact', 'typescriptreact', 'xml', 'jsx', 'markdown' },
  },
  -- json/yaml schema
  {
    'b0o/schemastore.nvim',
    lazy = true,
    config = function()
      lsp.servers.jsonls = vim.tbl_deep_extend('force', lsp.servers.jsonls, {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      })
      lsp.servers.yamlls = vim.tbl_deep_extend('force', lsp.servers.yamlls, {
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
      lsp.servers.lua_ls.meta.auto_setup = false
    end,
    config = function()
      local neodev = require('neodev')
      neodev.setup({ setup_jsonls = false })

      local lspconfig = require('lspconfig')
      local lua_config = lsp.servers.lua_ls
      lua_config.on_attach = lsp.on_attach
      lua_config.capabilities = lsp.make_capabilities()
      lspconfig.lua_ls.setup(lua_config)
    end,
  },
  {
    'simrat39/rust-tools.nvim',
    dependencies = { 'neovim/nvim-lspconfig' },
    enabled = values.languages.optional.rust,
    ft = { 'rust' },
    init = function()
      lsp.servers.rust_analyzer.meta.auto_setup = false
    end,
    config = function()
      local rt = require('rust-tools')
      local config = lsp.servers.rust_analyzer
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
