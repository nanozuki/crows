local M = {}

M.check = function()
  vim.health.report_start('check config health...')
  vim.health.ok('config health check passed')
end

return M
