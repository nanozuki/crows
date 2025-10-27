local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set('n', '<leader>oi', function()
  vim.lsp.buf.code_action({
    context = { diagnostics = {}, only = { 'source.organizeImports' } },
    apply = true,
  })
end, { desc = 'Organize imports', buffer = bufnr })
