local M = {
  ---@type table<string, fun()>
  formatters = {},
}

local lsp = require('config.lsp')
local format = require('config.format')

-- # built-in languages

function M.viml()
  lsp.set_config('vimls', {})
end

function M.yaml()
  M.formatters.yaml = format.prettier
  lsp.set_config('yamlls', {})
end

function M.json()
  M.formatters.json = format.prettier
  lsp.set_config('jsonls', {})
end

function M.lua()
  M.formatters.lua = format.stylua
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
  M.formatters.markdown = format.prettier
end

-- # opt-in languages

function M.go()
  M.formatters.go = format.goimports
  lsp.set_config('gopls', {})
  lsp.set_config('golangci_lint_ls', {})
end

function M.rust()
  M.formatters.rust = format.rustfmt
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
  M.formatters.typescript = format.prettier
  M.formatters.javascript = format.prettier
  M.formatters.typescriptreact = format.prettier
  M.formatters.javascriptreact = format.prettier
  M.formatters.css = format.prettier
  M.formatters.html = format.prettier
  M.formatters.xml = format.prettier
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

function M.terraform()
  M.formatters.terraform = format.terraform
  lsp.set_config('terraformls', {})
end

function M.zig()
  lsp.set_format({ '*.zig' }, 'zls')
  lsp.set_config('zls', {})
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
