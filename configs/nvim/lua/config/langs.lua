---@class LspConfig: table
---@field autoload boolean if autoload by nvim-lspconfig
---@field root_patterns? string[] see lspconfig.util.root_pattern
---@field config? table<string, any> lsp config
---@field on_attach? LspOnAttachCallback additional on_attach function

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

servers.yamlls = {
  autoload = true,
}

servers.jsonls = {
  autoload = true,
}

servers.gopls = {
  autoload = true,
  config = {
    settings = {
      gopls = {
        gofumpt = true,
      },
    },
  },
  on_attach = function(_, bufnr)
    vim.keymap.set('n', '<leader>oi', function()
      vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
    end, { desc = 'Organize imports', buffer = bufnr })
  end,
}

servers.rust_analyzer = {
  autoload = true,
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
  autoload = true,
  root_patterns = { 'tsconfig.json', 'jsconfig.json', 'package.json' },
  config = { single_file_support = false },
}

servers.tailwindcss = {
  autoload = true,
  root_patterns = { 'tailwind.config.js', 'tailwind.config.ts' },
}

servers.cssls = {
  autoload = true,
  config = {
    lint = {
      unknownAtRules = 'ignore',
    },
  },
}

servers.svelte = {
  autoload = false, -- need setup after tsserver
  on_attach = function(client, _)
    vim.api.nvim_create_autocmd('BufWritePost', {
      pattern = { '*.js', '*.ts' },
      callback = function(ctx)
        client.notify('$/onDidChangeTsOrJsFile', { uri = ctx.match })
      end,
    })
  end,
}

servers.html = {
  autoload = true,
}

servers.denols = {
  autoload = true,
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
  autoload = true,
}

servers.terraformls = {
  autoload = true,
}

servers.typst_lsp = {
  autoload = true,
}

servers.zls = {
  autoload = true,
}

servers.nil_ls = {
  autoload = true,
}

---@class FiletypeConfig
---@field enable boolean
---@field formatters? string[]
---@field linters? string[]
---@field tools? string[]
---@type table<string, FiletypeConfig>
local filetypes = {
  lua = { enable = true, formatters = { 'stylua' } },
  css = { enable = true, formatters = { 'prettier' } },
  deno = { enable = true, formatters = { 'prettier' } },
  html = { enable = true, formatters = { 'prettier' } },
  json = { enable = true, formatters = { 'prettier' } },
  yaml = { enable = true, formatters = { 'prettier' } },
  markdown = { enable = true, formatters = { 'prettier' } },
  go = {
    enable = true,
    linters = { 'golangci-lint' },
    tools = { 'gomodifytags', 'gotests', 'gotestsum', 'iferr', 'impl', 'dlv' },
  },
  typescript = { enable = true, formatters = { 'prettier' }, linters = { 'eslint_d' } },
  ocaml = { enable = true, formatters = { 'ocamlformat' } },
  nix = { enable = true, formatters = { 'nixpkgs-fmt' } },
}

return {
  servers = servers,
  filetypes = filetypes,
}
