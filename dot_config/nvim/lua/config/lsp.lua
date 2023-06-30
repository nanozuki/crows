local values = require('config.values')

local lsp = {}

-- # types

---@class LspKeyMapper
---@field [1] string key
---@field [2] string|function command
---@field [3] string description

---@alias LspKeyMappers table<string, LspKeyMapper>
---@alias LspOnAttachCallback fun(client:table,bufnr:number)
---@alias LspCapabilitiesMaker fun(caps:table):table

---@class LangServerMeta
---@field auto_setup? boolean default is true
---@field root_patterns string[]
---@field pkg string|string[] the package(s) should be installed

---@class LspConfig: table
---@field meta LangServerMeta

-- # keymap settings

---@type LspKeyMappers
lsp.buffer_keys = {
  goto_decl = { 'gD', vim.lsp.buf.declaration, 'Goto declaration' },
  goto_def = { 'gd', vim.lsp.buf.definition, 'Goto definition' },
  goto_typedef = { 'tp', vim.lsp.buf.type_definition, 'Goto type definition' },
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

function lsp.set_buffer_keymapping(_, bufnr)
  for _, mapper in pairs(lsp.buffer_keys) do
    vim.keymap.set('n', mapper[1], mapper[2], { desc = mapper[3], buffer = bufnr })
  end
end

-- # on_attach settings

---@type LspOnAttachCallback[]
lsp.on_attach_callbacks = {
  lsp.set_buffer_keymapping,
}

--- on_attach function base on settings
---@param client table client object
---@param bufnr number buffer number
function lsp.on_attach(client, bufnr)
  for _, func in ipairs(lsp.on_attach_callbacks) do
    func(client, bufnr)
  end
end

-- # capabilities settings

---@type LspCapabilitiesMaker[]
lsp.capabilities = {}

--- make capabilities base on settings
---@return table capabilities
function lsp.make_capabilities()
  local caps = vim.lsp.protocol.make_client_capabilities()
  for _, func in ipairs(lsp.capabilities) do
    caps = func(caps)
  end
  return caps
end

-- # format settings

---set fomatters by {client = [ filetypes ]}
---@type table<string, string[]>
lsp.formatters = {
  rust_analyzer = { 'rust' },
  terraformls = { 'terraform' },
  zls = { 'zig' },
}

function lsp.format()
  vim.lsp.buf.format({
    filter = function(client)
      return lsp.formatters[client.name] and vim.tbl_contains(lsp.formatters[client.name], vim.bo.filetype)
    end,
  })
end

function lsp.format_on_save()
  local format_group = vim.api.nvim_create_augroup('LspFormat', {})
  vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    group = format_group,
    pattern = '*',
    callback = lsp.format,
  })
end

-- # lang server settings

---@type table<string, LspConfig>
lsp.servers = {
  -- ## built-in languages
  lua_ls = {
    meta = { pkg = 'lua-language-server' },
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
  vimls = { meta = { pkg = 'vim-language-server' } },
  yamlls = { meta = { pkg = 'yaml-language-server' } },
  jsonls = { meta = { pkg = 'json-lsp' } },
  -- ## opt languages
  gopls = {
    meta = {
      auto_setup = values.languages.optional.go,
      pkg = 'gopls',
    },
  },
  rust_analyzer = {
    meta = {
      auto_setup = values.languages.optional.rust,
      pkg = 'rust-analyzer',
    },
    settings = {
      ['rust-analyzer'] = {
        diagnostics = {
          diagnostics = { disabled = { 'unresolved-proc-macro' } },
          checkOnSave = { command = 'clippy' },
        },
      },
    },
  },
  tsserver = {
    meta = {
      auto_setup = values.languages.optional.typescript,
      root_patterns = { 'tsconfig.json', 'jsconfig.json', 'package.json' },
      pkg = 'typescript-language-server',
    },
    single_file_support = false, -- Don't start in deno files
  },
  tailwindcss = {
    meta = {
      auto_setup = values.languages.optional.typescript,
      root_patterns = { 'tailwind.config.js', 'tailwind.config.ts' },
      pkg = 'tailwindcss-language-server',
    },
  },
  denols = {
    meta = {
      auto_setup = values.languages.optional.typescript,
      root_patterns = { 'deno.json', 'deno.jsonc' },
    },
    init_options = {
      enable = true,
      lint = true,
      unstable = true,
    },
  },
  graphql = {
    meta = {
      auto_setup = values.languages.optional.typescript,
      pkg = 'graphql-language-service-cli',
    },
    filetypes = { 'graphql' },
  },
  html = { meta = {
    auto_setup = values.languages.optional.typescript,
    pkg = 'html-lsp',
  } },
  cssls = {
    meta = {
      auto_setup = values.languages.optional.typescript,
      pkg = 'css-lsp',
    },
    settings = {
      css = {
        lint = {
          unknownAtRules = 'ignore',
        },
      },
    },
  },
  eslint = { meta = {
    auto_setup = values.languages.optional.typescript,
    pkg = 'eslint-lsp',
  } },
  ocamllsp = { meta = {
    auto_setup = values.languages.optional.ocaml,
    pkg = 'ocaml-lsp',
  } },
  terraformls = { meta = {
    auto_setup = values.languages.optional.terraform,
    pkg = 'terraform-ls',
  } },
  zls = { meta = {
    auto_setup = values.languages.optional.zig,
    pkg = 'zls',
  } },
}

return lsp
