local settings = require('config.settings')

return {
  -- improve vim select/input UI
  {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    config = function()
      require('dressing').setup({
        input = {
          insert_only = false,
        },
        select = {
          backend = 'native',
          builtin = {
            relative = 'cursor',
          },
        },
      })
    end,
  },
  -- improve vim quickfix UI
  { 'kevinhwang91/nvim-bqf', ft = 'qf' },
  { 'stevearc/quicker.nvim', ft = 'qf', opts = {} },
  -- file tree
  {
    'nvim-neo-tree/neo-tree.nvim',
    cmd = { 'Neotree' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    keys = {
      { '<Leader>fl', ':Neotree toggle<CR>', 'n', desc = 'Toggle file list' },
      { '<Leader>sl', ':Neotree document_symbols toggle<CR>', 'n', desc = 'Toggle symbol list' },
      { '<Leader>wf', ':vsplit | Neotree position=current<CR>', 'n', desc = 'Open Neotree Window' },
      { '<Leader>tf', ':tabnew | Neotree position=current<CR>', 'n', desc = 'Open Neotree Tab' },
    },
    opts = {
      sources = { 'filesystem', 'document_symbols' },
    },
  },
  -- filesystem editor
  {
    'stevearc/oil.nvim',
    cmd = { 'Oil' },
    keys = {
      { '<Leader>we', ':vsplit | Oil .<CR>', 'n', desc = 'Open files editor Window' },
      { '<leader>te', ':tabnew | Oil .<CR>', 'n', desc = 'Open files editor Tab' },
    },
    opts = {},
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    enabled = settings.hide_command_line,
    opts = {
      views = {
        cmdline_popup = { position = { row = 0, col = -2 }, relative = 'cursor' },
      },
      lsp = {
        progress = {
          enabled = false, -- use fidget.nvim
        },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
    config = function(_, opts)
      require('noice').setup(opts)
      local noice_fix = vim.api.nvim_create_augroup('noice_fix', {})
      -- FIX: sometimes, the cmdline height will be changed to 1
      vim.api.nvim_create_autocmd({ 'TabEnter' }, {
        group = noice_fix,
        callback = function()
          vim.opt.cmdheight = 0
        end,
      })
    end,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
  },
  {
    'rcarriga/nvim-notify',
    event = 'VeryLazy',
    dependencies = { 'j-hui/fidget.nvim' },
    config = function()
      require('notify').notify = require('fidget').notify
    end,
  },
  {
    'j-hui/fidget.nvim',
    event = 'VeryLazy',
    config = function()
      require('fidget').setup({
        progress = {
          poll_rate = 10,
        },
        notification = {
          poll_rate = 10,
          override_vim_notify = true,
          window = {
            max_width = 120,
          },
        },
      })
    end,
  },
  -- keymapping hint
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('which-key').setup()
    end,
  },
}
