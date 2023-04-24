return {
  'mhartington/formatter.nvim',
  event = 'BufReadPost',
  config = function()
    local function cur_file()
      return vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))
    end

    local function prettier()
      return {
        exe = 'prettier',
        args = { '--stdin-filepath', cur_file(), '--single-quote' },
        stdin = true,
      }
    end

    local function stylua()
      return {
        exe = 'stylua',
        args = { '--search-parent-directories', '--stdin-filepath', cur_file(), '-' },
        stdin = true,
      }
    end

    local function terraform()
      return {
        exe = 'terraform',
        args = { 'fmt', '-' },
        stdin = true,
      }
    end

    local function goimports()
      return {
        exe = 'goimports',
        stdin = true,
      }
    end

    local config = {
      filetype = {
        lua = stylua,
        json = prettier,
        jsonc = prettier,
        yaml = prettier,
        markdown = prettier,
        ['markdown.mdx'] = prettier,
      },
    }
    local custom = require('config.custom')
    if custom.opt_languages.go then
      config.filetype.go = goimports
    end
    if custom.opt_languages.typescript then
      config.filetype.javascript = prettier
      config.filetype.javascriptreact = prettier
      config.filetype.typescript = prettier
      config.filetype.typescriptreact = prettier
      config.filetype.css = prettier
      config.filetype.html = prettier
      config.filetype.graphql = prettier
    end
    if custom.opt_languages.terraform then
      config.filetype.terraform = terraform
    end
    require('formatter').setup(config)

    local group = vim.api.nvim_create_augroup('format_on_save', {})
    vim.api.nvim_create_autocmd('BufWritePost', {
      group = group,
      pattern = '*',
      command = 'silent! FormatWrite',
    })
  end,
}
