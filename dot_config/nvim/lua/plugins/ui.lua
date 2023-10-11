local values = require('config.values')

return {
  -- improve vim select/input UI
  {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    config = function()
      require('dressing').setup({
        input = { win_options = { winblend = 0 } },
        select = {
          get_config = function(opts)
            if opts.kind == 'codeaction' then
              return {
                backend = 'builtin',
                builtin = { relative = 'cursor', max_width = 80 },
              }
            end
          end,
        },
      })
    end,
  },
  -- improve vim quickfix UI
  { 'kevinhwang91/nvim-bqf', ft = 'qf' },
  -- file tree
  {
    'nvim-neo-tree/neo-tree.nvim',
    cmd = { 'Neotree' },
    keys = {
      { '<Leader>fl', ':Neotree toggle<CR>', 'n', desc = 'Toggle filetree' },
      { '<Leader>wf', ':vsplit | Neotree position=current<CR>', 'n', desc = 'Open Neotree Window' },
      { '<Leader>tf', ':tabnew | Neotree position=current<CR>', 'n', desc = 'Open Neotree Tab' },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
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
    enabled = values.use_noice,
    opts = {
      views = {
        cmdline_popup = {
          position = { row = 0, col = -2 },
          relative = 'cursor',
        },
      },
      lsp = {
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
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
  },
  {
    'rcarriga/nvim-notify',
    lazy = true,
    config = function()
      local notify = require('notify')
      vim.notify = notify
      ---@diagnostic disable
      notify.setup({
        render = 'wrapped-compact',
        stages = 'fade',
      })
      ---@diagnostic enable
    end,
  },
}
