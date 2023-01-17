---@class LspKeyMapper
---@field [1] string key
---@field [2] string|function command
---@field [3] string description
---@alias LspKeyMappers table<string, LspKeyMapper>

---@type LspKeyMappers
local keys = {
  diag_float = { '<leader>e', vim.diagnostic.open_float, 'Open diagnostic floating window' },
  diag_prev = { '[d', vim.diagnostic.goto_prev, 'Goto prev diagnostic' },
  diag_next = { ']d', vim.diagnostic.goto_next, 'Goto next diagnostic' },
  diag_loclist = { '<leader>q', vim.diagnostic.setloclist, 'Add buffer diagnostics to the location list.' },
}
for _, mapper in pairs(keys) do
  vim.keymap.set('n', mapper[1], mapper[2], { desc = mapper[3] })
end

for sign, text in pairs(vim.g.diag_signs) do
  local hl = 'DiagnosticSign' .. sign
  vim.fn.sign_define(hl, { text = text, texthl = hl, linehl = '', numhl = '' })
end

---@type LspKeyMappers
local buffer_keys = {
  goto_decl = { 'gD', vim.lsp.buf.declaration, 'Goto declaration' },
  goto_def = { 'gd', vim.lsp.buf.definition, 'Goto definition' },
  goto_typedef = { 'dt', vim.lsp.buf.type_definition, 'Goto type definition' },
  hover = { 'K', vim.lsp.buf.hover, 'Display hover information' },
  goto_impl = { 'gi', vim.lsp.buf.implementation, 'Goto implementation' },
  sign_help = { '<C-k>', vim.lsp.buf.signature_help, 'Display signature information' },
  add_folder = { '<leader>wa', vim.lsp.buf.add_workspace_folder, 'Add workspace folder' },
  del_folder = { '<leader>wr', vim.lsp.buf.remove_workspace_folder, 'Remove workspace folder' },
  list_folders = {
    '<leader>wl',
    function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end,
    'List workspace folder',
  },
  type_def = { '<leader>D', vim.lsp.buf.type_definition, 'Goto type definition' },
  rename = { '<leader>rn', vim.lsp.buf.rename, 'Rename symbol' },
  code_action = { '<leader>ca', vim.lsp.buf.code_action, 'Code action' },
  list_ref = { 'gr', vim.lsp.buf.references, 'List references' },
  -- format = { '<leader>f', vim.lsp.buf.formatting, 'Format buffer' },
}

---on attach function
---@param _ table client object
---@param bufnr number buffer number
local function on_attach(_, bufnr)
  -- buffer mapping
  for _, mapper in pairs(buffer_keys) do
    vim.keymap.set('n', mapper[1], mapper[2], { desc = mapper[3], buffer = bufnr })
  end
  -- Plug('ray-x/lsp_signature.nvim')
  require('lsp_signature').on_attach({ bind = true, handler_opts = { border = 'none' } })
end

local function capabilities()
  local caps = vim.lsp.protocol.make_client_capabilities()
  -- Plug('hrsh7th/cmp-nvim-lsp')
  caps = require('cmp_nvim_lsp').default_capabilities(caps)
  return caps
end

local format_group = vim.api.nvim_create_augroup('LspFormat', {})
local function set_format(pattern, client)
  vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    group = format_group,
    pattern = pattern,
    callback = function()
      vim.lsp.buf.format({ name = client })
    end,
  })
end

local lspconfig = require('lspconfig')
local opt_languages = require('config.custom').opt_languages

---set lsp config
---@param name string language server string
---@param config table language server config
local function set_config(name, config)
  config.on_attach = on_attach
  config.capabilities = capabilities()
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
set_config('yamlls', {
  settings = {
    yaml = {
      schemaStore = {
        enable = true,
      },
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
  set_format('*.ml', 'ocamllsp')
end
if opt_languages.rust then
  -- lsp is controlled by rust_tools.nvim
  set_format('*.rs', 'rust_analyzer')
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
  set_format({ '*.zig' }, 'zls')
  set_config('zls', {})
end

return {
  on_attach = on_attach,
  capabilities = capabilities,
}
