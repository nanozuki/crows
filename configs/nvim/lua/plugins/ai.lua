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
    ---@module 'sidekick'
    ---@type sidekick.Config
    opts = {
      nes = { enabled = false },
      cli = {
        win = {
          keys = { -- Replace "Ctrl" by "Alt"
            buffers = { '<M-b>', 'buffers', mode = 'nt', desc = 'open buffer picker' },
            files = { '<M-f>', 'files', mode = 'nt', desc = 'open file picker' },
            prompt = { '<M-p>', 'prompt', mode = 't', desc = 'insert prompt or context' },
          },
        },
      },
    },
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
        '<leader>as',
        function()
          require('sidekick.cli').select({ filter = { installed = true } })
        end,
        desc = 'Select CLI',
      },
      {
        '<leader>at',
        function()
          require('sidekick.cli').send({ msg = '{this}', filter = { name = 'opencode' } })
        end,
        mode = { 'x', 'n' },
        desc = 'Send This',
      },
      {
        '<leader>af',
        function()
          require('sidekick.cli').send({ msg = '{file}', filter = { name = 'opencode' } })
        end,
        desc = 'Send File',
      },
      {
        '<leader>av',
        function()
          require('sidekick.cli').send({ msg = '{selection}', filter = { name = 'opencode' } })
        end,
        mode = { 'x' },
        desc = 'Send Visual Selection',
      },
      {
        '<leader>ap',
        function()
          require('sidekick.cli').prompt({ filter = { name = 'opencode' } })
        end,
        mode = { 'n', 'x' },
        desc = 'Sidekick Select Prompt',
      },
    },
  },
}
