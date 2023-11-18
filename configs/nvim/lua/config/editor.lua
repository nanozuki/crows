local values = require('config.values')

-- # basic setting
vim.g.mapleader = ' '
vim.opt.linebreak = true
vim.opt.showbreak = '->'
vim.opt.mouse = 'ar'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.modelines = 1
vim.opt.colorcolumn = '120'
vim.opt.scrolloff = 10
vim.api.nvim_create_user_command('SaveAsSudo', function()
  local key = vim.api.nvim_replace_termcodes(':w !sudo tee %', true, false, true)
  vim.api.nvim_feedkeys(key, 't', false)
end, {})

-- # copy paste
vim.keymap.set('v', '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set('n', '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.keymap.set('n', '<leader>/', ':nohlsearch<CR>', { desc = 'Clear search' })

-- # abount filetypes
-- filetype
vim.filetype.add({
  extension = {
    mdx = 'markdown',
    gotmpl = 'gotmpl',
  },
  name = {
    ['tsconfig.json'] = 'jsonc',
  },
  pattern = {
    ['.*html'] = 'html',
  },
})

-- # indent
vim.cmd('filetype indent on')
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- # fold
vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 99

-- # terminal
local termcode = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end
vim.keymap.set('n', '<leader>tt', ':tabnew | terminal<CR>', { desc = 'Open terminal in new tab' })
vim.keymap.set('t', '<C-K>', termcode([[<C-\><C-N>]]), { desc = 'To normal mode in terminal' })

-- # keymap for tab
vim.keymap.set('n', '<leader>tc', ':$tabnew<CR>', { desc = 'Create new tab' })
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', { desc = 'Close current tab' })
vim.keymap.set('n', '<leader>to', ':tabonly<CR>', { desc = 'Close other tabs' })
vim.keymap.set('n', '<leader>tp', ':-tabmove<CR>', { desc = 'Move current tab to previous position' })
vim.keymap.set('n', '<leader>tn', ':+tabmove<CR>', { desc = 'Move current tab to next position ' })

-- # keymap for win

local function close_floating_win()
  local tabid = vim.api.nvim_get_current_tabpage()
  local wins = vim.api.nvim_tabpage_list_wins(tabid)
  for _, win in ipairs(wins) do
    if vim.api.nvim_win_get_config(win).relative ~= '' then
      vim.api.nvim_win_close(win, false)
    end
  end
end

-- winonly: use <C-W>o to close other windows
vim.keymap.set('n', '<leader>wF', close_floating_win, { desc = 'Close floating windows in this tab' })
vim.keymap.set('n', '<leader>wt', ':vsplit | terminal<CR>', { desc = 'Open terminal window' })

-- # diagnostic
-- ## keymap
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open diagnostic floating window' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Goto prev diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Goto next diagnostic' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Add buffer diagnostics to the location list.' })
-- ## sign
local signs = values.diagnostic_signs
for sign, text in pairs(signs) do
  local hl = 'DiagnosticSign' .. sign
  vim.fn.sign_define(hl, { text = text, texthl = hl, linehl = '', numhl = '' })
end