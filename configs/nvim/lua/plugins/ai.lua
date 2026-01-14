return {
  {
    'github/copilot.vim',
    init = function()
      vim.g.copilot_no_tab_map = true
    end,
    enabled = function()
      local cwd = vim.fn.getcwd()
      return not string.match(cwd, 'leetcode')
    end,
    config = function()
      vim.keymap.set('i', '<C-e>', [[copilot#Accept("\<CR>")]], { expr = true, replace_keycodes = false })
      vim.keymap.set('i', '<C-.>', '<Plug>(copilot-next)')
      vim.keymap.set('i', '<C-,>', '<Plug>(copilot-previous)')
    end,
  },
  {
    'folke/sidekick.nvim',
    opts = {},
    keys = {
      {
        '<c-.>',
        function()
          require('sidekick.cli').toggle({ name = 'opencode', focus = true })
        end,
        desc = 'Sidekick Toggle',
        mode = { 'n', 't', 'i', 'x' },
      },
      {
        '<leader>aa',
        function()
          require('sidekick.cli').toggle({ filter = { installed = true } })
        end,
        desc = 'Sidekick Toggle CLI',
      },
      {
        '<leader>as',
        function()
          require('sidekick.cli').select()
        end,
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
        desc = 'Select CLI',
      },
      {
        '<leader>at',
        function()
          require('sidekick.cli').send({ msg = '{this}' })
        end,
        mode = { 'x', 'n' },
        desc = 'Send This',
      },
      {
        '<leader>af',
        function()
          require('sidekick.cli').send({ msg = '{file}' })
        end,
        desc = 'Send File',
      },
      {
        '<leader>av',
        function()
          require('sidekick.cli').send({ msg = '{selection}' })
        end,
        mode = { 'x' },
        desc = 'Send Visual Selection',
      },
      {
        '<leader>ap',
        function()
          require('sidekick.cli').prompt()
        end,
        mode = { 'n', 'x' },
        desc = 'Sidekick Select Prompt',
      },
    },
  },
}
