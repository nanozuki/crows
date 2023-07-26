local langs = require('config.langs')
local values = require('config.values')

if langs.go.enable and values.use_null_ls then
  vim.api.nvim_buf_create_user_command(0, 'GoModTidy', function(_)
    vim.cmd([[!go mod tidy]])
    vim.cmd([[LspRestart]])
  end, {})
  vim.api.nvim_buf_create_user_command(0, 'GoBuild', '!go build -o /dev/null', {})
end
