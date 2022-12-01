local M = {}

local lsp = require('config.lsp')
local lspconfig = require('lspconfig')
local opt_languages = require('config.custom').opt_languages

---set lsp config
---@param name string language server string
---@param config table language server config
local function set_config(name, config)
  config.on_attach = lsp.on_attach
  config.capabilities = lsp.capabilities()
  lspconfig[name].setup(config)
end

--# built-in languages
set_config('sumneko_lua', {
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
set_config('vimls', {})
set_config('yamlls', {})
set_config('jsonls', {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(), -- Plug'b0o/schemastore.nvim'
      validate = { enable = true },
    },
  },
})

--# opt languages
if opt_languages.go then
  set_config('gopls', {
    settings = {
      gopls = {
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  })
  set_config('golangci_lint_ls', {})
end
if opt_languages.ocaml then
  set_config('ocamllsp', {})
  lsp.set_format('*.ml', 'ocamllsp')
end
if opt_languages.rust then
  -- lsp is controlled by rust_tools.nvim
  lsp.set_format('*.rs', 'rust_analyzer')
end
if opt_languages.terraform then
  set_config('terraformls', {})
end
if opt_languages.typescript then
  local util = require('lspconfig.util')
  set_config('tsserver', {
    root_dir = function(fname)
      return util.root_pattern('tsconfig.json')(fname) or util.root_pattern('package.json', 'jsconfig.json')(fname)
    end,
  })

  set_config('tailwindcss', {
    root_dir = util.root_pattern('tailwind.config.js', 'tailwind.config.ts'),
  })
  set_config('denols', {
    root_dir = util.root_pattern('deno_root'),
    init_options = {
      enable = true,
      lint = true,
      unstable = true,
    },
  })
  set_config('graphql', {
    filetypes = { 'graphql' },
  })
  set_config('html', {})
  set_config('cssls', {})
  set_config('eslint', {})
end
if opt_languages.zig then
  lsp.set_format({ '*.zig' }, 'zls')
  set_config('zls', {})
end

return M
