local crows = require('crows')

crows.execute('lang/lua.lua')
crows.execute('lang/go.lua')
crows.execute('lang/rust.lua')
crows.execute('lang/typescript.lua')
crows.execute('lang/fish.lua')

crows.use_plugin({
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
