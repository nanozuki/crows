return {
  {
    'zbirenbaum/copilot.lua',
    init = function()
      vim.g.copilot_no_tab_map = true
    end,
    enabled = function()
      local cwd = vim.fn.getcwd()
      return not string.match(cwd, 'leetcode')
    end,
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup({
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = '<C-e>',
            next = '<C-.>',
            prev = '<C-,>',
          },
        },
      })
    end,
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'canary',
    dependencies = {
      { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    },
    opts = {},
    keys = {
      {
        '<leader>cch',
        function()
          local actions = require('CopilotChat.actions')
          require('CopilotChat.integrations.telescope').pick(actions.help_actions())
        end,
        desc = 'CopilotChat - Help actions',
      },
      {
        '<leader>ccp',
        function()
          local actions = require('CopilotChat.actions')
          require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
        end,
        desc = 'CopilotChat - Prompt actions',
      },
      { '<leader>ccc', '<cmd>CopilotChat', desc = 'CopilotChat Command Line' },
    },
  },
}
