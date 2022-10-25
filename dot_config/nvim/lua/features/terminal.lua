---@type Feature
local terminal = { plugins = {} }

terminal.xplr = function()
  local xplr_file = '/tmp/nvim-toggle-xplr'
  local Terminal = require('toggleterm.terminal').Terminal
  local Xplr = Terminal:new({
    cmd = ('xplr > %s'):format(xplr_file),
    hidden = false,
    direction = 'float',
    on_close_exit = true,
    on_close = function()
      local file = require('plenary.path'):new(xplr_file):read()
      vim.schedule(function()
        vim.cmd(('e  %s'):format(file))
      end)
    end,
  })
  local crows = require('crows')
  crows.key.map('Toggle xplr', 'n', '<leader>fx', function()
    Xplr:toggle()
  end)
end

terminal.plugins[#terminal.plugins + 1] = {
  'akinsho/toggleterm.nvim',
  tag = '*',
  config = function()
    require('toggleterm').setup({
      open_mapping = [[<c-\>]],
      direction = 'float',
    })
    require('features.terminal').xplr()
  end,
}

terminal.post = function()
  local crows = require('crows')
  local termcode = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end
  crows.key.map('Open terminal in current window', 'n', '<leader>tw', ':terminal<CR>')
  crows.key.map('Open terminal in new tab', 'n', '<leader>tt', ':tabnew | terminal<CR>')
  crows.key.map('To normal mode in terminal', 't', '<C-K>', termcode([[<C-\><C-N>]]))
end

return terminal
