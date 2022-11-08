local lsp = require('crows.lsp')
local fmt = require('features.format')

---@type Feature
local go = {
  pre = function()
    fmt.by_formatter.go = { fmt.formatters.goimports }
  end,
  post = function()
    lsp.set_config('gopls', {})
    lsp.set_config('golangci_lint_ls', {})
  end,
}

---@type Feature
local json = {
  pre = function()
    fmt.by_formatter.json = { fmt.formatters.prettier }
  end,
  post = function()
    lsp.set_config('jsonls', {})
  end,
}

---@type Feature
local lua = {
  pre = function()
    fmt.by_formatter.lua = { fmt.formatters.stylua }
  end,
  post = function()
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
  end,
}

---@type Feature
local markdown = {
  pre = function()
    fmt.by_formatter.markdown = { fmt.formatters.prettier }
  end,
}

---@type Feature
local terraform = {
  pre = function()
    fmt.by_formatter.terraform = { fmt.formatters.terraform }
  end,
  post = function()
    lsp.set_config('terraformls', {})
  end,
}

---@type Feature
local rust = {
  pre = function()
    fmt.by_formatter.rust = { fmt.formatters.rustfmt }
  end,
  post = function()
    lsp.set_config('rust_analyzer', {
      settings = {
        ['rust-analyzer'] = {
          diagnostics = { disabled = { 'unresolved-proc-macro' } },
          checkOnSave = { command = 'clippy' },
        },
      },
    })
  end,
}

---@type Feature
local typescript = {
  pre = function()
    fmt.by_formatter.typescript = { fmt.formatters.prettier }
    fmt.by_formatter.javascript = { fmt.formatters.prettier }
    fmt.by_formatter.typescriptreact = { fmt.formatters.prettier }
    fmt.by_formatter.javascriptreact = { fmt.formatters.prettier }
    fmt.by_formatter.css = { fmt.formatters.prettier }
    fmt.by_formatter.html = { fmt.formatters.prettier }
    fmt.by_formatter.xml = { fmt.formatters.prettier }
  end,
  post = function()
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
  end,
}

---@type Feature
local viml = {
  post = function()
    lsp.set_config('vimls', {})
  end,
}

---@type Feature
local yaml = {
  pre = function()
    fmt.by_formatter.yaml = { fmt.formatters.prettier }
  end,
  post = function()
    lsp.set_config('yamlls', {})
  end,
}

---@type Feature
local zig = {
  pre = function()
    table.insert(fmt.by_lsp, '*.zig')
  end,
  post = function()
    lsp.set_config('zls', {})
  end,
}

---@type Feature[]
return {
  go,
  json,
  lua,
  markdown,
  rust,
  terraform,
  typescript,
  viml,
  yaml,
  zig,
}
