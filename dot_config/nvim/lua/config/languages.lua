local M = {
  ---@type table<string, fun()>
  formatters = {},
  ---@type table<string, (string|table)[]>
  packages = {},
}

local lsp = require('config.lsp')
local format = require('config.format')

-- # built-in languages

function M.viml()
  lsp.set_config('vimls', {})
  M.packages.viml = { 'vim-language-server' }
end

function M.yaml()
  lsp.set_config('yamlls', {})
  M.formatters.yaml = format.prettier
  M.packages.yaml = { 'yaml-language-server' }
end

function M.json()
  M.formatters.json = format.prettier
  lsp.set_config('jsonls', {
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(), -- Plug'b0o/schemastore.nvim'
        validate = { enable = true },
      },
    },
  })
end

function M.lua()
  require('neodev').setup({}) -- Plug'folke/neodev.nvim'
  lsp.set_config('sumneko_lua', {
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
        diagnostics = {
          globals = { 'vim' },
        },
        telemetry = {
          enable = false,
        },
      },
    },
  })
  M.formatters.lua = format.stylua
  M.packages.lua = { 'lua-language-server', 'stylua' }
end

function M.markdown()
  M.formatters.markdown = format.prettier
end

-- # opt-in languages

function M.go()
  lsp.set_config('gopls', {})
  lsp.set_config('golangci_lint_ls', {})
  M.formatters.go = format.goimports
  M.packages.go = {
    'gopls',
    'golangci-lint',
    'golangci-lint-langserver',
    'goimports',
    'gomodifytags',
    'golines',
    'gotests',
    'gotestsum',
    'iferr',
    'impl',
  }
end

function M.rust()
  lsp.set_config('rust_analyzer', {
    settings = {
      ['rust-analyzer'] = {
        diagnostics = { disabled = { 'unresolved-proc-macro' } },
        checkOnSave = { command = 'clippy' },
      },
    },
  })
  M.formatters.rust = format.rustfmt
  M.packages.rust = { 'rust-analyzer', 'rustfmt' }
end

function M.typescript()
  local util = require('lspconfig.util')
  lsp.set_config('tsserver', {
    root_dir = function(fname)
      return util.root_pattern('tsconfig.json')(fname) or util.root_pattern('package.json', 'jsconfig.json')(fname)
    end,
  })

  lsp.set_config('tailwindcss', {
    root_dir = util.root_pattern('tailwind.config.js', 'tailwind.config.ts'),
  })

  lsp.set_config('denols', {
    root_dir = util.root_pattern('deno_root'),
    init_options = {
      enable = true,
      lint = true,
      unstable = true,
    },
  })
  lsp.set_config('graphql', {
    filetypes = { 'graphql' },
  })
  lsp.set_config('html', {})
  lsp.set_config('cssls', {})
  lsp.set_config('eslint', {})
  M.formatters.typescript = format.prettier
  M.formatters.javascript = format.prettier
  M.formatters.typescriptreact = format.prettier
  M.formatters.javascriptreact = format.prettier
  M.formatters.css = format.prettier
  M.formatters.html = format.prettier
  M.formatters.xml = format.prettier
  M.packages.typescript = {
    'typescript-language-server',
    'tailwindcss-language-server',
    'prettier',
    'graphql-language-service-cli',
    'eslint-lsp',
  }
end

function M.terraform()
  lsp.set_config('terraformls', {})
  M.formatters.terraform = format.terraform
  M.packages.terraform = { 'terraform-ls' }
end

function M.zig()
  lsp.set_format({ '*.zig' }, 'zls')
  lsp.set_config('zls', {})
  M.packages.zig = { 'zls' }
end

function M.ocaml()
  lsp.set_config('ocamllsp', {})
  lsp.set_format('*.ml', 'ocamllsp')
  M.packages.ocaml = { 'ocaml-lsp' }
end

-- # load languages
-- ## built-in languages
M.viml()
M.yaml()
M.json()
M.lua()
M.markdown()
-- ## opt-in languages
for lang, enable in pairs(require('config.custom').opt_languages) do
  if enable then
    M[lang]()
  end
end

return M
