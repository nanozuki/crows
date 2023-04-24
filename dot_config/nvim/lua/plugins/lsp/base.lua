---@class LspKeyMapper
---@field [1] string key
---@field [2] string|function command
---@field [3] string description
---@alias LspKeyMappers table<string, LspKeyMapper>

local M = {}

---@type LspKeyMappers
M.keys = {
  diag_float = { '<leader>e', vim.diagnostic.open_float, 'Open diagnostic floating window' },
  diag_prev = { '[d', vim.diagnostic.goto_prev, 'Goto prev diagnostic' },
  diag_next = { ']d', vim.diagnostic.goto_next, 'Goto next diagnostic' },
  diag_loclist = { '<leader>q', vim.diagnostic.setloclist, 'Add buffer diagnostics to the location list.' },
}

---@type LspKeyMappers
M.buffer_keys = {
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

function M.set_buffer_keymapping(_, bufnr)
  for _, mapper in pairs(M.buffer_keys) do
    vim.keymap.set('n', mapper[1], mapper[2], { desc = mapper[3], buffer = bufnr })
  end
end

---@type (fun(client:table,bufnr:number))[]
M.on_attaches = {
  M.set_buffer_keymapping,
}

---@type (fun(caps:table):table)[]
M.capabilities = {}

---set fomatters by {pattern = client}
---@type table<string, string>
M.fomatters = {}

function M.set_keymapping_and_sign()
  for _, mapper in pairs(M.keys) do
    vim.keymap.set('n', mapper[1], mapper[2], { desc = mapper[3] })
  end

  for sign, text in pairs(vim.g.diag_signs) do
    local hl = 'DiagnosticSign' .. sign
    vim.fn.sign_define(hl, { text = text, texthl = hl, linehl = '', numhl = '' })
  end
end

---on attach function
---@param client table client object
---@param bufnr number buffer number
function M.on_attach(client, bufnr)
  for _, func in ipairs(M.on_attaches) do
    func(client, bufnr)
  end
end

function M.make_capabilities()
  local caps = vim.lsp.protocol.make_client_capabilities()
  for _, func in ipairs(M.capabilities) do
    caps = func(caps)
  end
  return caps
end

function M.set_lsp_format()
  local format_group = vim.api.nvim_create_augroup('LspFormat', {})
  for pattern, client in pairs(M.fomatters) do
    vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
      group = format_group,
      pattern = pattern,
      callback = function()
        vim.lsp.buf.format({ name = client })
      end,
    })
  end
end

return M
