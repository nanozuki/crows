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
---@field delayed_start? boolean default is true
---@field root_patterns? string[]
---@field pkg? string|string[] the package(s) should be installed

---@class LspConfig: table
---@field meta? LangServerMeta

-- # keymap settings

---@type LspKeyMappers
lsp.buffer_keys = {
  goto_decl = { 'gD', vim.lsp.buf.declaration, 'Goto declaration' },
  goto_def = { 'gd', vim.lsp.buf.definition, 'Goto definition' },
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
  codelens = { '<leader>cl', vim.lsp.codelens.run, 'Code action' },
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

-- # about filetypes, move to config/langs.lua later

local langs = require('config.langs')

---@class FiletypeConfig
---@field enable boolean
---@field formatters? string[]
---@field linters? string[]
---@type table<string, FiletypeConfig>
lsp.filetypes = {
  lua = { enable = langs.lua.enable, formatters = { 'stylua' } },
  css = { enable = langs.css.enable, formatters = { 'prettier' } },
  deno = { enable = langs.deno.enable, formatters = { 'prettier' } },
  html = { enable = langs.html.enable, formatters = { 'prettier' } },
  json = { enable = langs.json.enable, formatters = { 'prettier' } },
  yaml = { enable = langs.yaml.enable, formatters = { 'prettier' } },
  go = { enable = langs.go.enable, formatters = { 'goimports' }, linters = { 'golangci-lint' } },
  typescript = { enable = langs.typescript.enable, formatters = { 'prettier' }, linters = { 'eslint_d' } },
  ocaml = { enable = langs.ocaml.enable, formatters = { 'ocamlformat' } },
  nix = { enable = langs.nix.enable, formatters = { 'nixpkgs-fmt' } },
}

return lsp
