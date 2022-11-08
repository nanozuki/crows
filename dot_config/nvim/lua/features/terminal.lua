local crows = require('crows')
local termcode = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end
crows.key.map('Open terminal in current window', 'n', '<leader>tw', ':terminal<CR>')
crows.key.map('Open terminal in new tab', 'n', '<leader>tt', ':tabnew | terminal<CR>')
crows.key.map('To normal mode in terminal', 't', '<C-K>', termcode([[<C-\><C-N>]]))
