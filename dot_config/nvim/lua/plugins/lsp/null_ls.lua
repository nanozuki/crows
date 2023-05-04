return {
  'jose-elias-alvarez/null-ls.nvim',
  lazy = true,
  config = function()
    local null_ls = require('null-ls')
    local base = require('plugins.lsp.base')
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.goimports,
      },
    })
    local filetypes = {}
    vim.list_extend(filetypes, null_ls.builtins.formatting.prettier.filetypes)
    vim.list_extend(filetypes, null_ls.builtins.formatting.stylua.filetypes)
    vim.list_extend(filetypes, { 'go' })
    base.fomatters['null-ls'] = filetypes
  end,
}
