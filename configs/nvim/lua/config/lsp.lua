local lsp = {}

-- # types

---@class LspKeyMapper
---@field [1] string key
---@field [2] string|function command
---@field [3] string description

---@alias LspKeyMappers table<string, LspKeyMapper|table<string,LspKeyMapper>>
---@alias LspOnAttachCallback fun(client:table,bufnr:number)
---@alias LspCapabilitiesMaker fun(caps:table):table

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
  code_action = {
    n = { '<leader>ca', vim.lsp.buf.code_action, 'Code action' },
    i = {
      '<C-a>',
      function()
        require('config.lib').feedkeys('<Esc>')
        vim.lsp.buf.code_action()
      end,
      'Code action',
    },
  },
  codelens = { '<leader>cl', vim.lsp.codelens.run, 'Code action' },
  list_ref = { 'gr', vim.lsp.buf.references, 'List references' },

  -- format = { '<leader>f', vim.lsp.buf.formatting, 'Format buffer' },
}

function lsp.set_buffer_keymapping(_, bufnr)
  for _, mapper in pairs(lsp.buffer_keys) do
    if vim.tbl_islist(mapper) then
      vim.keymap.set('n', mapper[1], mapper[2], { desc = mapper[3], buffer = bufnr })
    else
      for mode, keymap in pairs(mapper) do
        vim.keymap.set(mode, keymap[1], keymap[2], { desc = keymap[3], buffer = bufnr })
      end
    end
  end
end

-- # on_attach settings

---@type LspOnAttachCallback[]
lsp.on_attach_callbacks = {
  lsp.set_buffer_keymapping,
}

---@param callback? LspOnAttachCallback Ad hoc additions callback
---@return LspOnAttachCallback
function lsp.on_attach(callback)
  return function(client, bufnr)
    for _, func in ipairs(lsp.on_attach_callbacks) do
      func(client, bufnr)
    end
    if callback then
      callback(client, bufnr)
    end
  end
end

-- # capabilities settings

---@type LspCapabilitiesMaker[]
lsp.capabilities = {}

--- make capabilities base on settings
---@param cap_maker? LspCapabilitiesMaker Ad hoc additions capabilities maker
---@return table capabilities
function lsp.make_capabilities(cap_maker)
  local caps = vim.lsp.protocol.make_client_capabilities()
  caps.workspace.didChangeWatchedFiles.dynamicRegistration = true
  for _, func in ipairs(lsp.capabilities) do
    caps = func(caps)
  end
  if cap_maker then
    caps = cap_maker(caps)
  end
  return caps
end

---setup function, should be registered by lsp config setter
---@type fun(server:LspConfig,on_attach?:LspOnAttachCallback,caps_maker?:LspCapabilitiesMaker):table
lsp.make_config = nil

return lsp
