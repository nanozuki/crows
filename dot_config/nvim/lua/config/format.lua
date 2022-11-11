local function cur_file()
  return vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))
end

local M = {}

M.formatters = {}

M.prettier = function()
  return {
    exe = 'prettier',
    args = { '--stdin-filepath', cur_file(), '--single-quote' },
    stdin = true,
  }
end

M.rustfmt = function()
  return {
    exe = 'rustfmt',
    args = { '--emit=stdout' },
    stdin = true,
  }
end

M.stylua = function()
  return {
    exe = 'stylua',
    args = { '--stdin-filepath', cur_file(), '-' },
    stdin = true,
  }
end

M.terraform = function()
  return {
    exe = 'terraform',
    args = { 'fmt', '-' },
    stdin = true,
  }
end

M.goimports = function()
  return {
    exe = 'goimports',
    stdin = true,
  }
end

function M.load()
  require('formatter').setup({
    filetype = M.formatters,
  })
  local group = vim.api.nvim_create_augroup('format_on_save', {})
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = group,
    pattern = '*',
    command = 'silent! FormatWrite',
  })
end

return M
