---@function translate
---@param translator table<string,string>
---@param names string[]
---@return string[]
local function translate_list(translator, names)
  local result = {}
  for _, name in ipairs(names) do
    table.insert(result, translator[name] or name)
  end
  return result
end

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
    'TimUntersberger/neogit',
    cmd = 'Neogit',
    dependencies = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim' },
    config = function()
      require('neogit').setup({ integrations = { diffview = true } })
    end,
  },
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      local translator = { ['golangci-lint'] = 'golangcilint' }
      local linters_by_ft = {} ---@type table<string, string[]>
      local langs = require('config.langs')
      for ft, ft_config in pairs(langs.filetypes) do
        if ft_config.enable then
          linters_by_ft[ft] = translate_list(translator, ft_config.linters or {})
        end
      end

      require('lint').linters_by_ft = linters_by_ft
      local lint_group = vim.api.nvim_create_augroup('NvimLint', {})
      vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost' }, {
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
      local translator = { ['nixpkgs-fmt'] = 'nixpkgs_fmt' }
      local formatters_by_ft = {} ---@type table<string, string[]>
      local langs = require('config.langs')
      for ft, ft_config in pairs(langs.filetypes) do
        if ft_config.enable then
          formatters_by_ft[ft] = translate_list(translator, ft_config.formatters or {})
        end
      end
      require('conform').setup({
        formatters_by_ft = formatters_by_ft,
        format_on_save = {
          lsp_fallback = true,
          timeout_ms = 3000,
        },
      })
      vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
