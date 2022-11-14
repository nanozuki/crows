require('toggleterm').setup({
  open_mapping = [[<c-\>]],
  direction = 'float',
})

-- xplr toogle terminal
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
vim.keymap.set('n', '<leader>fx', function()
  Xplr:toggle()
end, { desc = 'Toggle xplr' })
