---@type Feature
local basic = { plugins = {} }

basic.pre = function()
  vim.g.mapleader = ' '
  vim.opt.linebreak = true
  vim.opt.showbreak = '->'
  vim.opt.mouse = 'ar'
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.modelines = 1
  local aug = vim.api.nvim_create_augroup('colorcolumn', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    group = aug,
    pattern = { '*' },
    callback = function()
      vim.opt.colorcolumn = '120'
    end,
  })
  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    group = aug,
    pattern = { '*.txt', '*.md' },
    callback = function()
      vim.opt.colorcolumn = '80'
    end,
  })
end

basic.plugins[#basic.plugins + 1] = 'lewis6991/impatient.nvim'

basic.plugins[#basic.plugins + 1] = {
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
}

-- improve vim select/input UI
basic.plugins[#basic.plugins + 1] = {
  'stevearc/dressing.nvim',
  config = function()
    require('dressing').setup({
      input = { winblend = 0 },
    })
  end,
}

-- improve vim quickfix UI
basic.plugins[#basic.plugins + 1] = {
  'kevinhwang91/nvim-bqf',
  ft = 'qf',
}

return basic
