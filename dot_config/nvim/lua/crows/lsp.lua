---@class LspModule
---@field keys LspKeyMappers
---@field buffer_keys LspKeyMappers
---@field on_attaches OnAttachFn[]

---@class LspKeyMapper
---@field [1] string key
---@field [2] string command
---@field [3] string introduce

---@alias LspKeyMappers table<string, LspKeyMapper>
---@alias OnAttachFn function(client:table,bufnr:number)

-- local opts = { noremap=true, silent=true }

---@type LspModule
local lsp = {
  keys = {
    diag_float = { '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', 'Open diagnostic floating window' },
    diag_prev = { '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', 'Goto prev diagnostic' },
    diag_next = { ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', 'Goto next diagnostic' },
    diag_loclist = {
      '<space>q',
      '<cmd>lua vim.diagnostic.setloclist()<CR>',
      'Add buffer diagnostics to the location list.',
    },
  },
  buffer_keys = {
    goto_decl = { 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', 'Goto declaration' },
    goto_def = { 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', 'Goto definition' },
    hover = { 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', 'Display hover information' },
    goto_impl = { 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', 'Goto implementation' },
    sign_help = { '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'Display signature infomation' },
    add_folder = { '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', 'Add workspace folder' },
    del_folder = { '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', 'Remove workspace folder' },
    list_folders = {
      '<space>wl',
      '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
      'List workspace folder',
    },
    type_def = { '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', 'Goto type definition' },
    rename = { '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename symbol' },
    code_action = { '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', 'Code action' },
    list_ref = { 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', 'List references' },
    format = { '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', 'Format buffer' },
  },
  on_attaches = {},
}

---set lsp function of the key
---@param mapper LspKeyMapper
---@param command string
function lsp.set_key_cmd(mapper, command)
  mapper[2] = command
end

---set lsp key of the function
---@param mapper LspKeyMapper
---@param key string
function lsp.set_cmd_key(mapper, key)
  mapper[1] = key
end

---add 'on_attach' hook
---@param fn OnAttachFn
function lsp.add_on_attach(fn)
  lsp.on_attaches[#lsp.on_attaches + 1] = fn
end

---mapping lsp keys
---@param bufnr number buffer number
local function mapping(bufnr)
  local wk = require('which-key')
  local mappings = {}
  for _, mapper in pairs(lsp.keys) do
    mappings[mapper[1]] = { mapper[2], mapper[3] }
  end
  wk.register(mappings, { silent = true })

  local buf_mappings = {}
  for _, mapper in pairs(lsp.buffer_keys) do
    buf_mappings[mapper[1]] = { mapper[2], mapper[3] }
  end
  wk.register(buf_mappings, { buffer = bufnr })
end

---on attach function
---@param client table client object
---@param bufnr number buffer number
local function on_attach(client, bufnr)
  mapping(bufnr)
  for _, fn in ipairs(lsp.on_attaches) do
    fn(client, bufnr)
  end
end

local function capabilities()
  local caps = vim.lsp.protocol.make_client_capabilities()
  caps.textDocument.completion.completionItem.snippetSupport = true
  caps.textDocument.completion.completionItem.resolveSupport = {
    properties = { 'documentation', 'detail', 'additionalTextEdits' },
  }
  local exists, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if exists then
    return cmp_nvim_lsp.update_capabilities(caps)
  else
    return caps
  end
end

---set lsp config
---@param name string language server string
---@param config table language server config
function lsp.set_config(name, config)
  local lspconfig = require('lspconfig')
  config.on_attach = on_attach
  config.capabilities = capabilities()
  lspconfig[name].setup(config)
end

function lsp.add_default(name, default_config)
  local configs = require('lspconfig.configs')
  if not configs[name] then
    configs[name] = {
      default_config = default_config,
    }
  end
end

function lsp.root_pattern(...)
  require('lspconfig.util').root_pattern(...)
end

function lsp.stop_all_clients()
  vim.lsp.stop_client(vim.lsp.get_active_clients())
end

return lsp
