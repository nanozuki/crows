return {
  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      local ts = require('nvim-treesitter')
      local parsers = ts.get_available()
      ts.install(parsers, { max_jobs = 8 })
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local language = vim.treesitter.language.get_lang(args.match)
          if (not language) or (not vim.tbl_contains(parsers, language)) then
            return
          end
          vim.treesitter.start()
          vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo[0][0].foldmethod = 'expr'
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    event = { 'BufReadPost', 'BufNewFile' },
    init = function()
      vim.g.no_plugin_maps = true
    end,
    config = function()
      require('nvim-treesitter-textobjects').setup({
        select = {
          lookahead = true,
        },
      })
      local select_keys = {
        af = '@function.outer',
        ['if'] = '@function.inner',
        ac = '@class.outer',
        ic = '@class.inner',
      }
      for key, query in pairs(select_keys) do
        vim.keymap.set({ 'o', 'x' }, key, function()
          require('nvim-treesitter-textobjects.select').select_textobject(query)
        end, { desc = 'Select textobject: ' .. query })
      end
      local move_keys = {
        [']m'] = '@function.outer',
        [']M'] = '@function.outer',
        ['[m'] = '@function.outer',
        ['[M'] = '@function.outer',
        [']c'] = '@class.outer',
        [']C'] = '@class.outer',
        ['[c'] = '@class.outer',
        ['[C'] = '@class.outer',
      }
      for key, query in pairs(move_keys) do
        vim.keymap.set({ 'n', 'x', 'o' }, key, function()
          require('nvim-treesitter-textobjects.move').goto_next_start(query, 'textobjects')
        end)
      end
    end,
  },
}
