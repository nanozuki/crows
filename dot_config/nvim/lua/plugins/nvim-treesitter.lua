require('nvim-treesitter.configs').setup({
  ensure_installed = 'all',
  ignore_install = { 'phpdoc' },
  highlight = {
    enable = true,
    highlight = {
      enable = true,
      disable = function(lang, bufnr)
        if lang == 'html' and vim.api.nvim_buf_line_count(bufnr) > 500 then
          return true
        end
        for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, 3, false)) do
          if #line > 500 then
            return true
          end
        end
        return false
      end,
    },
  },
})
