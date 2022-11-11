---@class LspModule
---@field keys LspKeyMappers
---@field buffer_keys LspKeyMappers
---@field on_attaches OnAttachFn[]
---@field caps_setters CapsSetter[]

---@class LspKeyMapper
---@field [1] string key
---@field [2] string command
---@field [3] string introduce

---@alias LspKeyMappers table<string, LspKeyMapper>
---@alias OnAttachFn function(client:table,bufnr:number)
---@alias CapsSetter function(caps:table):table

-- local opts = { noremap=true, silent=true }

---@type LspModule
local lsp = {
  keys = {
    diag_float = { '<leader>e', vim.diagnostic.open_float, 'Open diagnostic floating window' },
    diag_prev = { '[d', vim.diagnostic.goto_prev, 'Goto prev diagnostic' },
    diag_next = { ']d', vim.diagnostic.goto_next, 'Goto next diagnostic' },
    diag_loclist = { '<leader>q', vim.diagnostic.setloclist, 'Add buffer diagnostics to the location list.' },
  },
  buffer_keys = {
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
    list_ref = { 'gr', vim.lsp.buf.references, 'List references' },
    -- format = { '<leader>f', vim.lsp.buf.formatting, 'Format buffer' },
  },
}

local signs = { Error = '', Warn = '', Info = '', Hint = '' }
for sign, text in pairs(signs) do
  local hl = 'DiagnosticSign' .. sign
  vim.fn.sign_define(hl, { text = text, texthl = hl, linehl = '', numhl = '' })
end

---on attach function
---@param client table client object
---@param bufnr number buffer number
local function on_attach(client, bufnr)
  -- mapping
  for _, mapper in pairs(lsp.keys) do
    vim.keymap.set('n', mapper[1], mapper[2], { desc = mapper[3] })
  end
  for _, mapper in pairs(lsp.buffer_keys) do
    vim.keymap.set('n', mapper[1], mapper[2], { desc = mapper[3], buffer = bufnr })
  end
  for _, fn in ipairs(lsp.on_attaches) do
    fn(client, bufnr)
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

---set lsp config
---@param name string language server string
---@param config table language server config
function lsp.set_config(name, config)
  local lspconfig = require('lspconfig')
  config.on_attach = on_attach
  config.capabilities = capabilities()
  lspconfig[name].setup(config)
end

local format_group = vim.api.nvim_create_augroup('LspFormat')
function lsp.set_format(pattern, client)
  vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    group = format_group,
    pattern = pattern,
    callback = function()
      vim.lsp.buf.format({ name = client })
    end,
  })
end

return lsp
