---@class LanguageSpec
-- To specify whether nvim support edit this language. If enable is true,
-- linters, formatters, tools, and servers should be installed in environment.
---@field enable boolean
---@field linters? string[] list of linter name
---@field formatters? string[] list of formatter name or "lsp:<server_name>"
---@field tools? string[] list of tool name
---@field servers table<string, LspConfig> map lsp config to lsp name

-- define all languages requirement specs, won't execute any tool
---@type table<string, LanguageSpec>
local langs = {}

langs.lua = {
  enable = true,
  formatters = { 'stylua' },
  servers = {
    lua_ls = {
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
          },
          diagnostics = {
            globals = { 'vim' },
          },
          workspace = {
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
        },
      },
    },
  },
}

local has_nodejs = vim.fn.executable('node') == 1

langs.vim = {
  enable = has_nodejs,
  servers = { vimls = {} },
}

langs.yaml = {
  enable = has_nodejs,
  formatters = { 'prettier' },
  servers = { yamlls = {} },
}

langs.json = {
  enable = has_nodejs,
  formatters = { 'prettier' },
  servers = { jsonls = {} },
}

langs.go = {
  enable = vim.fn.executable('go') == 1,
  linters = { 'golangci-lint' },
  formatters = { 'goimports' },
  tools = {
    'gomodifytags',
    'gotests',
    'gotestsum',
    'iferr',
    'impl',
    'dlv',
  },
  servers = { gopls = {} },
}

langs.rust = {
  enable = vim.fn.executable('cargo') == 1,
  formatters = { 'lsp:rust_analyzer' },
  servers = {
    rust_analyzer = {
      settings = {
        ['rust-analyzer'] = {
          diagnostics = {
            diagnostics = { disabled = { 'unresolved-proc-macro' } },
            checkOnSave = { command = 'clippy' },
          },
        },
      },
    },
  },
}

local has_deno = vim.fn.executable('deno') == 1

langs.typescript = {
  enable = has_nodejs,
  linters = { 'eslint_d' },
  formatters = { 'prettier' },
  servers = {
    tsserver = {
      meta = { root_patterns = { 'tsconfig.json', 'jsconfig.json', 'package.json' } },
      single_file_support = not has_deno, -- Don't start in deno files
    },
    tailwindcss = {
      meta = { root_patterns = { 'tailwind.config.js', 'tailwind.config.ts' } },
    },
  },
}

langs.css = {
  enable = has_nodejs,
  formatters = { 'prettier' },
  servers = {
    cssls = {
      lint = {
        unknownAtRules = 'ignore',
      },
    },
  },
}

langs.html = {
  enable = has_nodejs,
  formatters = { 'prettier' },
  servers = { html = {} },
}

langs.deno = {
  enable = has_deno,
  formatters = { 'prettier' },
  servers = {
    denols = {
      meta = { root_patterns = { 'deno.json', 'deno.jsonc' } },
      init_options = {
        enable = true,
        lint = true,
        unstable = true,
      },
    },
  },
}

langs.ocaml = {
  enable = vim.fn.executable('opam') == 1,
  formatters = { 'ocamlformat' },
  servers = { ocamllsp = {} },
}

langs.terraform = {
  enable = vim.fn.executable('terraform') == 1,
  formatters = { 'lsp:terraformls' },
  servers = { terraformls = {} },
}

langs.zig = {
  enable = vim.fn.executable('zig') == 1,
  formatters = { 'lsp:zls' },
  servers = { zls = {} },
}

return langs
