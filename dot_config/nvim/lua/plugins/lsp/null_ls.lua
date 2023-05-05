return {
  'jose-elias-alvarez/null-ls.nvim',
  lazy = true,
  config = function()
    local null_ls = require('null-ls')
    local custom = require('config.custom')
    local base = require('plugins.lsp.base')

    -- builtins languages
    local sources = {
      null_ls.builtins.formatting.prettier,
      null_ls.builtins.formatting.stylua,
    }
    local format_types = {}
    vim.list_extend(format_types, null_ls.builtins.formatting.prettier.filetypes)
    vim.list_extend(format_types, null_ls.builtins.formatting.stylua.filetypes)

    -- optional languages
    if custom.opt_languages.go then
      vim.list_extend(sources, {
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.code_actions.gomodifytags,
        null_ls.builtins.code_actions.impl,
        -- TODO: waiting gotests: https://github.com/jose-elias-alvarez/null-ls.nvim/pull/1362
      })
      vim.list_extend(format_types, { 'go' })
    end
    if custom.opt_languages.typescript or custom.opt_languages.go then
      sources[#sources + 1] = null_ls.builtins.formatting.refactoring
    end
    null_ls.setup({ sources = sources })
    vim.list_extend(format_types, { 'go' })
    base.formatters['null-ls'] = format_types
  end,
}
