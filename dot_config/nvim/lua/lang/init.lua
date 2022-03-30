local crows = require('crows')

require('lang.lua')
require('lang.go')
require('lang.rust')
require('lang.typescript')
require('lang.fish')

crows.plugin.use({
  'mhartington/formatter.nvim',
  config = function()
    local linters = {
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

    require('formatter').setup({
      filetype = {
        typescript = { linters.prettier },
        javascript = { linters.prettier },
        typescriptreact = { linters.prettier },
        javascriptreact = { linters.prettier },
        css = { linters.prettier },
        html = { linters.prettier },
        json = { linters.prettier },
        yaml = { linters.prettier },
        markdown = { linters.prettier },
        go = { linters.goimports },
        rust = { linters.rustfmt },
        lua = { linters.stylua },
        terraform = { linters.terraform },
      },
    })
    local augroup = require('lib.util').augroup
    local autocmd = require('lib.util').autocmd
    augroup('format_on_save', {
      autocmd('BufWritePost', '*', 'silent! FormatWrite'),
      -- use lsp to extended format, if needed
      -- autocmd('BufWritePre', '<buffer>', 'lua vim.lsp.buf.formatting_seq_sync()'),
    })
  end,
})

local lsp = require('lib.lsp')
local simple_servers = {
  'vimls',
  'zls',
  'terraformls',
  'yamlls',
}

for _, name in ipairs(simple_servers) do
  lsp.set_config(name, {})
end
