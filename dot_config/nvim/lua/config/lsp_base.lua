local M = {}

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

---set fomatters by {client = [ filetypes ]}
---@type table<string, string[]>
M.formatters = {}

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
  vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    group = format_group,
    pattern = '*',
    callback = function()
      vim.lsp.buf.format({
        filter = function(client)
          return M.formatters[client.name] and vim.tbl_contains(M.formatters[client.name], vim.bo.filetype)
        end,
      })
    end,
  })
end

return M
