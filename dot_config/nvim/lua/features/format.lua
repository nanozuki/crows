---@type Feature
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
      local lsp_patterns = table.concat(fmt.by_lsp, ',')
      local augroup = require('crows.util').augroup
      local autocmd = require('crows.util').autocmd
      augroup('format_on_save', {
        autocmd('BufWritePost', '*', 'silent! FormatWrite'),
        autocmd('BufWritePost', lsp_patterns, 'lua vim.lsp.buf.formatting_seq_sync()'),
      })
    end,
  },
}

return format
