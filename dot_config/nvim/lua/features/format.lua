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

format.plugins = {
  {
    'mhartington/formatter.nvim',
    config = function()
      local fmt = require('features.format')
      require('formatter').setup({
        filetype = fmt.by_formatter,
      })
      local group = vim.api.nvim_create_augroup('format_on_save', {})
      vim.api.nvim_create_autocmd('BufWritePost', {
        group = group,
        pattern = '*',
        command = 'silent! FormatWrite',
      })
      vim.api.nvim_create_autocmd('BufWritePost', {
        group = group,
        pattern = table.concat(fmt.by_lsp, ','),
        callback = vim.lsp.buf.formatting_seq_sync,
      })
    end,
  },
}

return format
