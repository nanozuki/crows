local function list_workspace_folders()
  vim.print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end

local function toggle_inlay_hint()
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
  vim.lsp.inlay_hint.enable(not enabled)
end

local function do_code_action(name)
  return function()
    vim.lsp.buf.code_action({
      context = { diagnostics = {}, only = { name } },
      apply = true,
    })
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    -- Generally keymsps for LSP
    local keys = {
      goto_decl = { 'gD', vim.lsp.buf.declaration, 'Goto declaration' },
      goto_def = { 'gd', vim.lsp.buf.definition, 'Goto definition' },
      hover = { 'K', vim.lsp.buf.hover, 'Display hover information' },
      goto_impl = { 'gi', vim.lsp.buf.implementation, 'Goto implementation' },
      sign_help = { '<C-k>', vim.lsp.buf.signature_help, 'Display signature information' },
      add_folder = { '<leader>wa', vim.lsp.buf.add_workspace_folder, 'Add workspace folder' },
      del_folder = { '<leader>wr', vim.lsp.buf.remove_workspace_folder, 'Remove workspace folder' },
      list_folders = { '<leader>wl', list_workspace_folders, 'List workspace folder' },
      type_def = { '<leader>D', vim.lsp.buf.type_definition, 'Goto type definition' },
      rename = { '<leader>rn', vim.lsp.buf.rename, 'Rename symbol' },
      code_action = { '<leader>ca', vim.lsp.buf.code_action, 'Code action' },
      codelens = { '<leader>cl', vim.lsp.codelens.run, 'Code action' },
      list_ref = { 'gr', vim.lsp.buf.references, 'List references' },
      format = { '<leader>bf', vim.lsp.buf.format, 'Format buffer' },
      inlay_hint = { '<leader>lh', toggle_inlay_hint, 'Toggle in[l]ay [h]int' },
      organize_imports = { '<leader>oi', do_code_action('source.organizeImports'), 'Organize imports' },
    }
    for _, mapper in pairs(keys) do
      vim.keymap.set('n', mapper[1], mapper[2], { desc = mapper[3], buffer = args.buf })
    end
  end,
})

vim.lsp.enable({
  'astro',
  'cssls',
  'denols',
  'gleam',
  'gopls',
  'html',
  'jsonls',
  'lua_ls',
  'nil_ls',
  'ocamllsp',
  'pyright',
  'ruff',
  'rust_analyzer',
  'svelte',
  'tailwindcss',
  'terraformls',
  'tinymist',
  'vtsls',
  'yamlls',
  'zls',
})
