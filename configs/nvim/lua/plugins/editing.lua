return {
  -- autopairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup({ check_ts = true })
    end,
  },
  -- surround edit
  {
    'kylechui/nvim-surround',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-surround').setup({})
    end,
  },
  -- comment
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end,
  },
  -- git command enhancement
  { 'tpope/vim-fugitive', cmd = 'Git' },
  {
    'NeogitOrg/neogit',
    cmd = 'Neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
    },
    config = function()
      require('neogit').setup({ integrations = { diffview = true } })
    end,
  },
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('lint').linters_by_ft = {
        go = { 'golangcilint' },
        javascript = { 'eslint' },
        javascriptreact = { 'eslint' },
        python = { 'ruff' },
        svelte = { 'eslint' },
        typescript = { 'eslint' },
        typescriptreact = { 'eslint' },
      }
      local eslint = require('lint.linters.eslint')
      eslint.args[#eslint.args + 1] = '--flag'
      eslint.args[#eslint.args + 1] = 'v10_config_lookup_from_file'
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
    'stevearc/conform.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          css = { 'prettier' },
          deno = { 'prettier' },
          html = { 'prettier' },
          javascript = { 'prettier' },
          javascriptreact = { 'prettier' },
          json = { 'prettier' },
          jsonc = { 'prettier' },
          lua = { 'stylua' },
          markdown = { 'prettier' },
          nix = { 'nixfmt' },
          ocaml = { 'ocamlformat' },
          proto = { 'buf' },
          python = { 'ruff_format', 'ruff_organize_imports', 'ruff_fix' },
          typescript = { 'prettier' },
          typescriptreact = { 'prettier' },
          yaml = { 'prettier' },
        },
        format_on_save = {
          lsp_format = 'fallback',
          timeout_ms = 500,
        },
      })
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
