vim.opt_local.expandtab = false
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4

local org_imports_group = vim.api.nvim_create_augroup('GoOrgImports', {})
vim.api.nvim_create_autocmd('BufWritePost', {
  buffer = 0,
  callback = function()
    require('go.format').org_imports()
  end,
  group = org_imports_group,
})
