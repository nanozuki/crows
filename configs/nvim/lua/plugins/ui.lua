local values = require('config.values')

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
  {
    'luukvbaal/statuscol.nvim',
    config = function()
      vim.opt.foldcolumn = '1'
      vim.opt.fillchars = { foldopen = '', foldclose = '', foldsep = ' ' }
      vim.opt.signcolumn = 'number'
      local builtin = require('statuscol.builtin')
      -- _G.ScFa = get_fold_action
      -- _G.ScSa = get_sign_action
      -- _G.ScLa = get_lnum_action
      require('statuscol').setup({
        segments = {
          -- {
          --   sign = { name = { 'Diagnostic' }, maxwidth = 2, auto = true },
          --   click = 'v:lua.ScSa',
          -- },
          {
            text = { builtin.lnumfunc },
            sign = {
              name = { 'Diagnostic' },
              colwidth = 1,
              auto = true,
            },
            click = 'v:lua.ScLa',
          },
          { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
        },
      })
    end,
  },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async',
      'neovim/nvim-lspconfig',
    },
    init = function()
      local lsp = require('config.lsp')
      lsp.capabilities[#lsp.capabilities + 1] = function(caps)
        caps.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        }
        return caps
      end
    end,
    config = function()
      require('ufo').setup()
    end,
  },
}
