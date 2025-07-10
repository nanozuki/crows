local globals = require('config.globals')
local utils = require('config.utils')

-- # globals
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- # options
-- ## basic
vim.opt.colorcolumn = '120'
vim.opt.ignorecase = true
vim.opt.inccommand = 'split'
vim.opt.jumpoptions = 'stack,view'
vim.opt.modelines = 1
vim.opt.mouse = 'ar'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.showmode = false
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.timeoutlen = 500
vim.opt.undofile = true
vim.opt.updatetime = 250
-- ## linebreak
vim.opt.linebreak = true
vim.opt.showbreak = '->'
vim.opt.breakindent = true
-- ## search
vim.opt.grepprg = 'rg --vimgrep'
-- ## fold
vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 99

vim.api.nvim_create_user_command('SaveAsSudo', function()
  local keys = utils.termcode(':w !sudo tee %')
  vim.api.nvim_feedkeys(keys, 't', true)
end, {})

-- # keyaps
-- ## copy paste
vim.keymap.set('v', '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set('n', '<leader>p', '"+p', { desc = 'Paste from system clipboard' })

-- ## search and replace
vim.keymap.set('v', '<leader>s', 'y/\\V<C-r>"<CR>', { desc = 'Search visual text' })
vim.keymap.set('v', '<leader>r', 'y:%s/\\V<C-r>"//g<Left><Left>', { desc = 'Replace visual text' })

-- ## terminal
vim.keymap.set('n', '<leader>tt', ':tabnew | terminal<CR>', { desc = 'Open terminal in new tab' })
vim.keymap.set('t', '<C-K>', utils.termcode([[<C-\><C-N>]]), { desc = 'To normal mode in terminal' })

-- ## keymap for tab
vim.keymap.set('n', '<leader>tc', ':$tabnew<CR>', { desc = 'Create new tab' })
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', { desc = 'Close current tab' })
vim.keymap.set('n', '<leader>to', ':tabonly<CR>', { desc = 'Close other tabs' })
vim.keymap.set('n', '<leader>tp', ':-tabmove<CR>', { desc = 'Move current tab to previous position' })
vim.keymap.set('n', '<leader>tn', ':+tabmove<CR>', { desc = 'Move current tab to next position ' })

-- ## keymap for win
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

-- # filetypes
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

-- # diagnostic
-- ## keymap
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open diagnostic floating window' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Goto prev diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Goto next diagnostic' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Add buffer diagnostics to the location list.' })
-- ## config
vim.diagnostic.config({
  virtual_lines = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = globals.diagnostic_signs.Error,
      [vim.diagnostic.severity.WARN] = globals.diagnostic_signs.Warn,
      [vim.diagnostic.severity.INFO] = globals.diagnostic_signs.Info,
      [vim.diagnostic.severity.HINT] = globals.diagnostic_signs.Hint,
    },
  },
})

-- # autocmd
-- ## highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
