return {
  'garymjr/nvim-snippets',
  dependencies = { 'rafamadriz/friendly-snippets' },
  opts = {
    create_cmp_source = true,
    friendly_snippets = true,
  },
  keys = {
    {
      '<C-j>',
      function()
        if vim.snippet.active({ direction = 1 }) then
          vim.schedule(function()
            vim.snippet.jump(1)
          end)
          return
        end
        return '<C-j>'
      end,
      expr = true,
      silent = true,
      mode = 'i',
    },
    {
      '<C-j>',
      function()
        vim.schedule(function()
          vim.snippet.jump(1)
        end)
      end,
      expr = true,
      silent = true,
      mode = 's',
    },
    {
      '<C-k>',
      function()
        if vim.snippet.active({ direction = -1 }) then
          vim.schedule(function()
            vim.snippet.jump(-1)
          end)
          return
        end
        return '<C-k>'
      end,
      expr = true,
      silent = true,
      mode = { 'i', 's' },
    },
  },
  event = 'InsertEnter',
}
