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
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'canary',
    dependencies = {
      { 'github/copilot.vim' },
      { 'nvim-lua/plenary.nvim' },
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
