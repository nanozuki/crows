vim.api.nvim_buf_create_user_command(0, 'GoModTidy', function(_)
  vim.cmd([[:!go mod tidy]])
  vim.cmd([[LspRestart]])
end, {})
