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
      { '<leader>cco', '<cmd>CopilotChatOpen<cr>', desc = 'CopilotChat Open' },
      { '<leader>ccr', '<cmd>CopilotChatReset<cr>', desc = 'CopilotChat Reset' },
      {
        '<leader>ccq',
        function()
          local input = vim.fn.input('Quick Chat: ')
          if input ~= '' then
            require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
          end
        end,
        desc = 'CopilotChat - Quick chat for buffer',
      },
      {
        '<leader>ccp',
        ':lua require("CopilotChat.integrations.telescope").pick(require("CopilotChat.actions").prompt_actions())<cr>',
        mode = { 'n', 'v' },
        desc = 'CopilotChat Commands',
      },
    },
  },
}
