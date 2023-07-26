local values = require('config.values')
local langs = require('config.langs')

return {
  -- multi select and edit
  { 'mg979/vim-visual-multi', event = { 'BufReadPre', 'BufNewFile' } },
  -- autopairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup({ check_ts = true })
    end,
  },
  -- surround edit
  { 'machakann/vim-sandwich', event = { 'BufReadPre', 'BufNewFile' } },
  -- comment
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
    config = function()
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end,
  },
  -- git command enhancement
  { 'tpope/vim-fugitive', cmd = 'Git' },
  {
    'TimUntersberger/neogit',
    cmd = 'Neogit',
    dependencies = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim' },
    config = function()
      require('neogit').setup({ integrations = { diffview = true } })
    end,
  },
  {
    'mfussenegger/nvim-lint',
    enabled = not values.use_null_ls,
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      ---@type table<string,string>
      local linter_translate = {
        ['golangci-lint'] = 'golangcilint',
      }
      local linters = {} ---@type table<string, boolean>
      for _, spec in pairs(langs) do
        for _, linter in ipairs(spec.linters or {}) do
          if not string.match(linter, '^lsp:') then
            linters[linter] = true
          end
        end
      end

      local linters_by_ft = {} ---@type table<string, string[]>
      for linter, _ in pairs(linters) do
        for _, filetype in ipairs(values.linter_filetypes[linter] or {}) do
          if not linters_by_ft[filetype] then
            linters_by_ft[filetype] = {}
          end
          if linter_translate[linter] then
            linter = linter_translate[linter]
          end
          table.insert(linters_by_ft[filetype], linter)
        end
      end

      require('lint').linters_by_ft = linters_by_ft
      local lint_group = vim.api.nvim_create_augroup('NvimLint', {})
      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        group = lint_group,
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
  {
    'mhartington/formatter.nvim',
    enabled = not values.use_null_ls,
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      ---@type table<string, (fun():table)>
      local formatter_translate = {
        stylua = require('formatter.filetypes.lua').stylua,
        prettier = require('formatter.defaults').prettier,
        goimports = require('formatter.filetypes.go').goimports,
        ocamlformat = require('formatter.defaults').ocamlformat,
      }

      local formatters = {} ---@type table<string, boolean>
      for _, spec in pairs(langs) do
        if spec.enable then
          for _, formatter in ipairs(spec.formatters or {}) do
            if not string.match(formatter, '^lsp:') then
              formatters[formatter] = true
            end
          end
        end
      end

      local filetypes = {} ---@type table<string, table<string, (fun():table)[]>>
      for formatter, _ in pairs(formatters) do
        for _, filetype in ipairs(values.formatter_filetypes[formatter] or {}) do
          if not filetypes[filetype] then
            filetypes[filetype] = {}
          end
          table.insert(filetypes[filetype], formatter_translate[formatter])
        end
      end

      require('formatter').setup({ filetype = filetypes })
      local format_group = vim.api.nvim_create_augroup('NvimFormat', {})
      vim.api.nvim_create_autocmd({ 'BufWritePost' }, { group = format_group, command = 'FormatWrite' })
    end,
  },
}
