local values = require('config.values')
local lsp = require('config.lsp')
local langs = require('config.langs')

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
    config = function()
      local linters = {}
      for _, spec in pairs(langs) do
        for _, linter in ipairs(spec.linters or {}) do
          if not string.match(linter, '^lsp:') then
            linters[linter] = true
          end
        end
      end
      local formatters = {}
      for _, spec in pairs(langs) do
        for _, formatter in ipairs(spec.formatters or {}) do
          formatters[formatter] = true
        end
      end
      local tools = {}
      for _, spec in pairs(langs) do
        for _, tool in ipairs(spec.tools or {}) do
          tools[tool] = true
        end
      end

      local null_ls = require('null-ls')
      local sources = {}
      local format_types = {}

      if linters['golangci_lint'] then
        table.insert(sources, null_ls.builtins.diagnostics.golangci_lint)
      end

      if formatters['stylua'] then
        table.insert(sources, null_ls.builtins.formatting.stylua)
        vim.list_extend(format_types, null_ls.builtins.formatting.stylua.filetypes)
      end
      if formatters['prettier'] then
        table.insert(sources, null_ls.builtins.formatting.prettier)
        vim.list_extend(format_types, null_ls.builtins.formatting.prettier.filetypes)
      end
      if formatters['goimports'] then
        table.insert(sources, null_ls.builtins.formatting.goimports)
        vim.list_extend(format_types, null_ls.builtins.formatting.goimports.filetypes)
      end
      if formatters['ocamlformat'] then
        table.insert(sources, null_ls.builtins.formatting.ocamlformat)
        table.insert(format_types, 'ocamlformat')
      end

      if tools['gomodifytags'] then
        table.insert(sources, null_ls.builtins.code_actions.gomodifytags)
      end
      if tools['impl'] then
        table.insert(sources, null_ls.builtins.code_actions.impl)
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
      local setup = function(name, config)
        local load = (config.meta or {}).delayed_start ~= true
        if load then
          config.on_attach = lsp.on_attach
          config.capabilities = lsp.make_capabilities()
          if config.meta and config.meta.root_patterns then
            config.root_dir = require('lspconfig.util').root_pattern(unpack(config.meta.root_patterns))
          end
          lspconfig[name].setup(config)
        end
      end
      for _, lang in pairs(langs) do
        if lang.enable then
          for name, config in pairs(lang.servers or {}) do
            setup(name, config)
          end
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
