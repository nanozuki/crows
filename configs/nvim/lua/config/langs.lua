---@class LspConfig: table
---@field autoload boolean if autoload by nvim-lspconfig
---@field root_patterns? string[] see lspconfig.util.root_pattern
---@field config? table<string, any> lsp config

local values = require('config.values')
local has_enabled = values.languages

local servers = {} ---@type table<string, LspConfig>

servers.lua_ls = {
  autoload = true,
  config = {
    settings = {
      Lua = {
        format = { enable = false },
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
}

servers.vimls = {
  autoload = has_enabled.vim,
}

servers.yamlls = {
  autoload = has_enabled.yaml,
}

servers.jsonls = {
  autoload = has_enabled.json,
}

servers.gopls = {
  autoload = has_enabled.go,
}

servers.rust_analyzer = {
  autoload = has_enabled.rust,
  config = {
    settings = {
      ['rust-analyzer'] = {
        diagnostics = {
          diagnostics = { disabled = { 'unresolved-proc-macro' } },
          checkOnSave = { command = 'clippy' },
        },
      },
    },
  },
}

servers.tsserver = {
  autoload = has_enabled.typescript_node,
  root_patterns = { 'tsconfig.json', 'jsconfig.json', 'package.json' },
  config = {
    single_file_support = not has_enabled.typescript_deno, -- Don't start in deno files
  },
}

servers.tailwindcss = {
  autoload = has_enabled.typescript_node,
  root_patterns = { 'tailwind.config.js', 'tailwind.config.ts' },
}

servers.cssls = {
  autoload = has_enabled.typescript_node,
  config = {
    lint = {
      unknownAtRules = 'ignore',
    },
  },
}

servers.html = {
  autoload = has_enabled.typescript_node,
}

servers.denols = {
  autoload = has_enabled.typescript_deno,
  root_patterns = { 'deno.json', 'deno.jsonc' },
  config = {
    init_options = {
      enable = true,
      lint = true,
      unstable = true,
    },
  },
}

servers.ocamllsp = {
  autoload = has_enabled.ocaml,
}

servers.terraformls = {
  autoload = has_enabled.terraform,
}

servers.zls = {
  autoload = has_enabled.zig,
}

servers.nil_ls = {
  autoload = has_enabled.nix,
}

---@class FiletypeConfig
---@field enable boolean
---@field formatters? string[]
---@field linters? string[]
---@field tools? string[]
---@type table<string, FiletypeConfig>
local filetypes = {
  lua = { enable = has_enabled.lua, formatters = { 'stylua' } },
  css = { enable = has_enabled.css, formatters = { 'prettier' } },
  deno = { enable = has_enabled.typescript_deno, formatters = { 'prettier' } },
  html = { enable = has_enabled.html, formatters = { 'prettier' } },
  json = { enable = has_enabled.json, formatters = { 'prettier' } },
  yaml = { enable = has_enabled.yaml, formatters = { 'prettier' } },
  markdown = { enable = true, formatters = { 'prettier' } },
  go = {
    enable = has_enabled.go,
    formatters = { 'goimports' },
    linters = { 'golangci-lint' },
    tools = { 'gomodifytags', 'gotests', 'gotestsum', 'iferr', 'impl', 'dlv' },
  },
  typescript = { enable = has_enabled.typescript_node, formatters = { 'prettier' }, linters = { 'eslint_d' } },
  ocaml = { enable = has_enabled.ocaml, formatters = { 'ocamlformat' } },
  nix = { enable = has_enabled.nix, formatters = { 'nixpkgs-fmt' } },
}

return {
  servers = servers,
  filetypes = filetypes,
}
