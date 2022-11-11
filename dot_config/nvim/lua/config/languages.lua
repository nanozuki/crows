local M = {}

local lsp = require('config.lsp')
local format = require('config.format')

-- # built-in languages

function M.viml()
  lsp.set_config('vimls', {})
end

function M.yaml()
  format.formatters.yaml = format.prettier
  lsp.set_config('yamlls', {})
end

function M.json()
  format.formatters.json = format.prettier
  lsp.set_config('jsonls', {})
end

function M.lua()
  format.formatters.lua = format.stylua
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
end

function M.markdown()
  format.formatters.markdown = format.prettier
end

-- # opt-in languages

function M.go()
  format.formatters.go = format.goimports
  lsp.set_config('gopls', {})
  lsp.set_config('golangci_lint_ls', {})
end

function M.terraform()
  format.formatters.terraform = format.terraform
  lsp.set_config('terraformls', {})
end

function M.rust()
  format.formatters.rust = format.rustfmt
  lsp.set_config('rust_analyzer', {
    settings = {
      ['rust-analyzer'] = {
        diagnostics = { disabled = { 'unresolved-proc-macro' } },
        checkOnSave = { command = 'clippy' },
      },
    },
  })
end

function M.typescript()
  format.formatters.typescript = format.prettier
  format.formatters.javascript = format.prettier
  format.formatters.typescriptreact = format.prettier
  format.formatters.javascriptreact = format.prettier
  format.formatters.css = format.prettier
  format.formatters.html = format.prettier
  format.formatters.xml = format.prettier
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
end

function M.zig()
  lsp.set_format({ '*.zig' }, 'zls')
  lsp.set_config('zls', {})
end

return M
