local values = require('config.values')
local lsp = require('config.lsp')

return {
  -- # load before nvim-lspconfig
  {
    'ray-x/lsp_signature.nvim',
    lazy = true,
    config = function()
      lsp.on_attach_callbacks[#lsp.on_attach_callbacks + 1] = function(_, _)
        require('lsp_signature').on_attach({ bind = true, handler_opts = { border = 'none' } })
      end
    end,
  },
  {
    'hrsh7th/cmp-nvim-lsp',
    lazy = true,
    config = function()
      lsp.capabilities[#lsp.capabilities + 1] = require('cmp_nvim_lsp').default_capabilities
    end,
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    lazy = true,
    init = function()
      -- builtins languages
      vim.list_extend(values.packages, { 'prettier', 'stylua' })
      -- optional languages
      local opt_lang = values.languages.optional
      if opt_lang.go then
        vim.list_extend(values.packages, { 'goimports', 'gomodifytags', 'impl', 'gotests', 'gotestsum' })
      end
      if opt_lang.ocaml then
        table.insert(values.packages, 'ocamlformat')
      end
      if opt_lang.rust then
        table.insert(values.packages, 'rustfmt')
      end
    end,
    config = function()
      local null_ls = require('null-ls')
      local opt_lang = values.languages.optional
      local format_types = {}

      -- builtins languages
      local sources = {
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.stylua,
      }
      vim.list_extend(format_types, null_ls.builtins.formatting.prettier.filetypes)
      vim.list_extend(format_types, null_ls.builtins.formatting.stylua.filetypes)

      -- optional languages
      if opt_lang.go then
        vim.list_extend(sources, {
          null_ls.builtins.formatting.goimports,
          null_ls.builtins.code_actions.gomodifytags,
          null_ls.builtins.code_actions.impl,
          null_ls.builtins.diagnostics.golangci_lint,
          -- TODO: waiting gotests: https://github.com/jose-elias-alvarez/null-ls.nvim/pull/1362
        })
        table.insert(format_types, 'go')
      end
      if opt_lang.ocaml then
        table.insert(sources, null_ls.builtins.formatting.ocamlformat)
        table.insert(format_types, 'ocamlformat')
      end
      if opt_lang.rust then
        table.insert(sources, null_ls.builtins.formatting.rustfmt)
        table.insert(format_types, 'rustfmt')
      end
      null_ls.setup({ sources = sources })
      lsp.formatters['null-ls'] = format_types
    end,
  },
  -- # nvim-lspconfig
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lspconfig = require('lspconfig')
      for client, config in pairs(lsp.servers) do
        if config.meta.auto_setup == nil or config.meta.auto_setup == true then
          config.on_attach = lsp.on_attach
          config.capabilities = lsp.make_capabilities()
          if config.meta.root_patterns then
            config.root_dir = require('lspconfig.util').root_pattern(unpack(config.meta.root_patterns))
          end
          lspconfig[client].setup(config)
        end
      end
      lsp.format_on_save()
    end,
    dependencies = {
      'ray-x/lsp_signature.nvim',
      'hrsh7th/cmp-nvim-lsp',
      'b0o/schemastore.nvim',
      'jose-elias-alvarez/null-ls.nvim',
    },
  },
  -- # load after nvim-lspconfig
  {
    'folke/trouble.nvim',
    cmd = 'TroubleToggle',
    keys = { { '<leader>xx', ':TroubleToggle<CR>', 'n', { desc = 'Toggle trouble quickfix' } } },
    dependencies = { 'nvim-tree/nvim-web-devicons', 'neovim/nvim-lspconfig' },
    config = function()
      require('trouble').setup({
        signs = {
          error = values.diagnostic_signs.Error,
          warning = values.diagnostic_signs.Warn,
          information = values.diagnostic_signs.Info,
          hint = values.diagnostic_signs.Hint,
          other = '󰗡',
        },
      })
    end,
  },
  {
    'j-hui/fidget.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      require('fidget').setup({})
    end,
  },
}
