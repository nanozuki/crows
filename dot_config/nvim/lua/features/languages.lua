local lsp = require('crows.lsp')
local fmt = require('features.format')

---@type Feature
local fish = {
  plugins = {
    { 'dag/vim-fish', ft = { 'fish' } },
  },
}

---@type Feature
local go = {
  pre = function()
    fmt.by_formatter.go = { fmt.formatters.goimports }
  end,
  plugins = {
    {
      'ray-x/go.nvim',
      ft = { 'go', 'gomod' },
      config = function()
        require('go').setup()
      end,
    },
  },
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
}

---@type Feature
local kitty = {
  plugins = {
    { 'fladson/vim-kitty', ft = { 'kitty' } },
  },
}

---@type Feature
local lua = {
  pre = function()
    fmt.by_formatter.lua = { fmt.formatters.stylua }
  end,
  post = function()
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, 'lua/?.lua')
    table.insert(runtime_path, 'lua/?/init.lua')

    local function workspace_files()
      local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
      if cwd == '~/.config/nvim' then
        -- Make the server aware of Neovim runtime files, only in config cwd
        return vim.api.nvim_get_runtime_file('', true)
      end
      return nil
    end

    local sumneko_lua_settings = {
      cmd = { 'lua-language-server' },
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
            path = runtime_path,
          },
          completion = {
            autoRequire = false,
          },
          diagnostics = {
            globals = { 'vim' },
          },
          workspace = {
            library = workspace_files(),
            maxPreload = 5000,
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      },
    }
    lsp.set_config('sumneko_lua', sumneko_lua_settings)
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
    fmt.by_formatter.terraform = { fmt.formatters.prettier }
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
  end,
  plugins = {
    {
      'mattn/emmet-vim',
      ft = { 'html', 'javascript.jsx', 'typescript.tsx', 'javascriptreact', 'typescriptreact' },
    },
  },
  post = function()
    lsp.set_config('tsserver', {
      root_dir = function(fname)
        return lsp.root_pattern('tsconfig.json')(fname) or lsp.root_pattern('package.json', 'jsconfig.json')(fname)
      end,
    })

    lsp.set_config('tailwindcss', {
      root_dir = lsp.root_pattern('tailwind.config.js', 'tailwind.config.ts'),
    })

    lsp.set_config('denols', {
      root_dir = lsp.root_pattern('deno_root'),
      init_options = {
        enable = true,
        lint = true,
        unstable = true,
      },
    })
    lsp.set_config('graphql', {
      filetypes = { 'graphql' },
    })
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
  fish,
  go,
  json,
  kitty,
  lua,
  markdown,
  rust,
  terraform,
  typescript,
  viml,
  yaml,
  zig,
}
