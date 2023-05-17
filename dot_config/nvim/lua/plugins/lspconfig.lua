local base = require('config.lsp_base')
local opt_languages = require('config.custom').opt_languages

---set lsp config
---@param name string language server string
---@param config table language server config
local function set_config(name, config)
  local lspconfig = require('lspconfig')
  config.on_attach = base.on_attach
  config.capabilities = base.make_capabilities()
  lspconfig[name].setup(config)
end

local function config()
  -- # set lang servers
  -- ## built-in languages
  set_config('lua_ls', {
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
          library = (function()
            local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
            if cwd == 'nvim' then
              return vim.api.nvim_get_runtime_file('', true)
            else
              return nil
            end
          end)(),
        },
        telemetry = {
          enable = false,
        },
      },
    },
  })
  set_config('vimls', {})
  set_config('yamlls', {
    settings = {
      yaml = {
        schemas = require('schemastore').yaml.schemas(), -- Plug'b0o/schemastore.nvim'
      },
    },
  })
  set_config('jsonls', {
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(), -- Plug'b0o/schemastore.nvim'
        validate = { enable = true },
      },
    },
  })

  -- ## opt languages
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
    base.formatters.ocamllsp = { 'ocaml' }
  end
  if opt_languages.rust then
    -- lsp is controlled by rust_tools.nvim
    base.formatters.rust_analyzer = { 'rust' }
  end
  if opt_languages.terraform then
    set_config('terraformls', {})
    base.formatters.terraformls = { 'terraform' }
  end
  if opt_languages.typescript then
    local util = require('lspconfig.util')
    set_config('tsserver', {
      root_dir = function(fname)
        return util.root_pattern('tsconfig.json')(fname) or util.root_pattern('package.json', 'jsconfig.json')(fname)
      end,
      single_file_support = false, -- Don't start in deno files
    })

    set_config('tailwindcss', {
      root_dir = util.root_pattern('tailwind.config.js', 'tailwind.config.ts'),
    })
    set_config('denols', {
      root_dir = util.root_pattern('deno.json', 'deno.jsonc'),
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
    set_config('cssls', {
      settings = {
        css = {
          lint = {
            unknownAtRules = 'ignore',
          },
        },
      },
    })
    set_config('eslint', {})
  end
  if opt_languages.zig then
    set_config('zls', {})
    base.formatters.zls = { 'zig' }
  end

  -- # set formatter
  base.set_lsp_format()
end

return {
  'neovim/nvim-lspconfig',
  event = 'BufReadPre',
  config = config,
  dependencies = {
    'ray-x/lsp_signature.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'b0o/schemastore.nvim',
    'jose-elias-alvarez/null-ls.nvim',
  },
}
