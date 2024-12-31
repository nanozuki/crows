local globals = require('config.globals')
local utils = require('config.utils')

-- # basic setting
vim.g.mapleader = ' '
vim.opt.linebreak = true
vim.opt.showbreak = '->'
vim.opt.mouse = 'ar'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.modelines = 1
vim.opt.colorcolumn = '120'
vim.opt.termguicolors = true
vim.opt.scrolloff = 10

vim.api.nvim_create_user_command('SaveAsSudo', function()
  local keys = utils.termcode(':w !sudo tee %')
  vim.api.nvim_feedkeys(keys, 't', true)
end, {})

-- # copy paste
vim.keymap.set('v', '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set('n', '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Also can Use <C-l> to clear highlight, this is built-in keymap
vim.keymap.set('n', '<leader>/', ':nohlsearch<CR>', { desc = 'Clear search' })

-- # search and replace
vim.keymap.set('v', '<leader>s', 'y/\\V<C-r>"<CR>', { desc = 'Search visual text' })
vim.keymap.set('v', '<leader>r', 'y:%s/\\V<C-r>"//g<Left><Left>', { desc = 'Replace visual text' })

vim.opt.grepprg = 'rg --vimgrep'
vim.keymap.set('n', '<leader>sf', function()
  vim.ui.input({ prompt = 'Search in files: ' }, function(input)
    if type(input) ~= 'string' or input == '' then
      return
    end
    vim.cmd(string.format('silent! grep! %s', input))
    vim.cmd.copen()
    vim.cmd.wincmd('J')
  end)
end, { desc = 'Search in files' })

-- # abount filetypes
-- filetype
vim.filetype.add({
  extension = {
    mdx = 'markdown',
    gotmpl = 'gotmpl',
    typ = 'typst',
  },
  name = {
    ['tsconfig.json'] = 'jsonc',
  },
  pattern = {
    ['.*html'] = 'html',
  },
})

-- # indent use editorconfig

-- # fold
vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 99

-- # terminal
vim.keymap.set('n', '<leader>tt', ':tabnew | terminal<CR>', { desc = 'Open terminal in new tab' })
vim.keymap.set('t', '<C-K>', utils.termcode([[<C-\><C-N>]]), { desc = 'To normal mode in terminal' })

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
-- ## config
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = globals.diagnostic_signs.Error,
      [vim.diagnostic.severity.WARN] = globals.diagnostic_signs.Warn,
      [vim.diagnostic.severity.INFO] = globals.diagnostic_signs.Info,
      [vim.diagnostic.severity.HINT] = globals.diagnostic_signs.Hint,
    },
  },
})
