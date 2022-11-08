---@class FormatModule: Feature
---@field by_formatter table
---@field by_lsp table
---@field formatters table

---@type FormatModule
local format = {
  by_formatter = {},
  by_lsp = {},
}

format.formatters = {
  prettier = function()
    return {
      exe = 'prettier',
      args = { '--stdin-filepath', vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), '--single-quote' },
      stdin = true,
    }
  end,
  rustfmt = function()
    return {
      exe = 'rustfmt',
      args = { '--emit=stdout' },
      stdin = true,
    }
  end,
  stylua = function()
    return {
      exe = 'stylua',
      args = { '-' },
      stdin = true,
    }
  end,
  terraform = function()
    return {
      exe = 'terraform',
      args = { 'fmt', '-' },
      stdin = true,
    }
  end,
  goimports = function()
    return {
      exe = 'goimports',
      args = { '-w' },
      stdin = false,
    }
  end,
}

return format
