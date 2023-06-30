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
vim.cmd('syntax enable')
vim.cmd('set wildignore+=*/node_modules/*,*.swp,*.pyc,*/venv/*,*/target/*,.DS_Store')
vim.keymap.set('c', 'w!!', 'w !sudo tee %', { desc = 'Save as sudo' })

-- # copy paste
vim.keymap.set('v', '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set('n', '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
vim.opt.ignorecase = true
vim.keymap.set('n', '<leader>/', ':nohlsearch<CR>', { desc = 'Clear search' })

-- # abount filetypes
-- filetype
vim.cmd([[filetype on]])
vim.cmd([[filetype plugin on]])
local filetypes = {
  ['*html'] = 'html',
  ['tsconfig.json'] = 'jsonc',
  ['*.mdx'] = 'markdown',
  ['*.gotmpl'] = 'gotmpl',
}
local ft_group = vim.api.nvim_create_augroup('filetypes', {})
for pattern, filetype in pairs(filetypes) do
  vim.api.nvim_create_autocmd(
    { 'BufNewFile', 'BufRead' },
    { group = ft_group, pattern = pattern, command = 'setfiletype ' .. filetype, once = true }
  )
end

-- # indent
vim.cmd('filetype indent on')
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
local fi_group = vim.api.nvim_create_augroup('fileindent', {})
vim.api.nvim_create_autocmd('FileType', {
  group = fi_group,
  pattern = 'lua,javascript,typescript,javascriptreact,typescriptreact,html,css,scss,xml,yaml,json,terraform,graphql,markdown,jsx',
  command = 'setlocal expandtab ts=2 sw=2 sts=2',
})
vim.api.nvim_create_autocmd('FileType', {
  group = fi_group,
  pattern = 'go,gotmpl',
  command = 'setlocal noexpandtab ts=4 sw=4',
})

-- # fold
vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 99

-- # terminal
local termcode = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end
vim.keymap.set('n', '<leader>tw', ':terminal<CR>', { desc = 'Open terminal in current window' })
vim.keymap.set('n', '<leader>tt', ':tabnew | terminal<CR>', { desc = 'Open terminal in new tab' })
vim.keymap.set('t', '<C-K>', termcode([[<C-\><C-N>]]), { desc = 'To normal mode in terminal' })

-- # keymap for tab
vim.keymap.set('n', '<leader>tc', ':$tabnew<CR>', { desc = 'Create new tab' })
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', { desc = 'Close current tab' })
vim.keymap.set('n', '<leader>to', ':tabonly<CR>', { desc = 'Close other tabs' })
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', { desc = 'Go to next tab' })
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', { desc = 'Go to previous tab' })
vim.keymap.set('n', '<leader>tmp', ':-tabmove<CR>', { desc = 'Move current tab to previous position' })
vim.keymap.set('n', '<leader>tmn', ':+tabmove<CR>', { desc = 'Move current tab to next position ' })

-- # keymap for win
local function win_only()
  local tabid = vim.api.nvim_get_current_tabpage()
  local wins = vim.api.nvim_tabpage_list_wins(tabid)
  local current = vim.api.nvim_get_current_win()
  for _, win in ipairs(wins) do
    if win ~= current then
      vim.api.nvim_win_close(win, false)
    end
  end
end

local function close_floating_win()
  local tabid = vim.api.nvim_get_current_tabpage()
  local wins = vim.api.nvim_tabpage_list_wins(tabid)
  for _, win in ipairs(wins) do
    if vim.api.nvim_win_get_config(win).relative ~= '' then
      vim.api.nvim_win_close(win, false)
    end
  end
end

vim.keymap.set('n', '<leader>wo', win_only, { desc = 'Close other windows in this tab' })
vim.keymap.set('n', '<leader>wO', close_floating_win, { desc = 'Close floating windows in this tab' })

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
