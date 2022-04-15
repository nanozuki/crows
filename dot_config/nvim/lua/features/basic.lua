local crows = require('crows')

---@type Feature
local basic = {}

basic.pre = function()
  vim.g.mapleader = ' '
  vim.opt.linebreak = true
  vim.opt.showbreak = '->'
  vim.opt.mouse = 'ar'
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.colorcolumn = '120'
  vim.opt.modelines = 1
end

basic.plugins = {
  'lewis6991/impatient.nvim',
  {
    'rmagatti/auto-session',
    config = function()
      vim.opt.sessionoptions = 'curdir,folds,help,tabpages,terminal,winsize'
      require('auto-session').setup({
        pre_save_cmds = { 'NvimTreeClose' },
        auto_session_suppress_dirs = { '~' },
      })
      require('crows').key.maps({
        ['<leader>s'] = {
          r = { '<cmd>RestoreSession<cr>', 'Restore session' },
          s = { '<cmd>SaveSession<cr>', 'Save session' },
        },
      })
    end,
  },
}

basic.post = function()
  local termcode = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end
  crows.key.map('Open terminal in current window', 'n', '<leader>tw', ':terminal<CR>')
  crows.key.map('Open terminal in new tab', 'n', '<leader>tt', ':tabnew | terminal<CR>')
  crows.key.map('To normal mode in terminal', 't', '<C-K>', termcode([[<C-\><C-N>]]))
end

return basic
