return {
  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      local parsers, installed ---@type string[], string[]
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          if parsers == nil then
            parsers = require('nvim-treesitter').get_available()
            installed = require('nvim-treesitter').get_installed()
          end
          local language = vim.treesitter.language.get_lang(args.match)
          if vim.tbl_contains(parsers, language) == false then
            return
          end
          if vim.tbl_contains(installed, language) == false then
            if require('nvim-treesitter').install({ language }) == true then
              installed[#installed + 1] = language
              vim.treesitter.start()
            end
          else
            vim.treesitter.start()
          end
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
